import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test(
    'rinnova una sessione scaduta e ripete il recupero con il nuovo token',
    () async {
      final now = DateTime.utc(2026, 9, 27, 12);
      final store = MemorySessionStore(
        testSession(expiresAt: now.subtract(const Duration(minutes: 1))),
      );
      var refreshCalls = 0;
      var dashboardCalls = 0;
      final adapter = ScriptedAdapter((RequestOptions request) {
        if (request.uri.path.endsWith('/auth/refresh-token')) {
          refreshCalls++;
          return jsonResponse(
            200,
            <String, Object?>{
              'access_token': 'synthetic-refreshed-access',
              'refresh_token': 'synthetic-rotated-refresh',
              'expires_in': 1800,
              'scope': 'openid offline',
            },
            headers: <String, List<String>>{
              'date': <String>['Sun, 27 Sep 2026 12:00:00 GMT'],
            },
          );
        }
        if (request.uri.path.endsWith('/dashboard/dashboard')) {
          dashboardCalls++;
          expect(
            request.headers['authorization'],
            'Bearer synthetic-refreshed-access',
          );
          return jsonResponse(200, <String, Object?>{
            'success': true,
            'data': <String, Object?>{
              'dati': <Object?>[
                <String, Object?>{'registro': <Object?>[]},
              ],
            },
          });
        }
        return jsonResponse(404, <String, Object?>{});
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final network = DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: dio,
      );
      final client = DidupClient(
        networkClient: network,
        sessionStore: store,
        now: () => now,
      );

      final dashboard = await client.fetchDashboard(
        profileId: 'profile-1',
        since: DateTime(2026, 9),
      );

      expect(dashboard['success'], isTrue);
      expect(refreshCalls, 1);
      expect(dashboardCalls, 1);
      expect(store.value!.accessToken, 'synthetic-refreshed-access');
      expect(store.value!.refreshToken, 'synthetic-rotated-refresh');
      expect(store.writeCount, 1);
    },
  );

  test('invalida la sessione se il rinnovo viene rifiutato', () async {
    final now = DateTime.utc(2026, 9, 27, 12);
    final store = MemorySessionStore(
      testSession(expiresAt: now.subtract(const Duration(minutes: 1))),
    );
    final adapter = ScriptedAdapter((RequestOptions _) {
      return jsonResponse(401, <String, Object?>{'error': 'expired'});
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final client = DidupClient(
      networkClient: DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: dio,
      ),
      sessionStore: store,
      now: () => now,
    );

    await expectLater(
      client.fetchDashboard(profileId: 'profile-1', since: DateTime(2026, 9)),
      throwsA(isA<SessionExpiredFailure>()),
    );
    expect(store.value, isNull);
    expect(store.clearCount, 1);
  });

  test('su 401 rinnova e ripete la richiesta una sola volta', () async {
    final now = DateTime.utc(2026, 9, 27, 12);
    final store = MemorySessionStore(
      testSession(expiresAt: now.add(const Duration(hours: 1))),
    );
    var dashboardCalls = 0;
    var refreshCalls = 0;
    final adapter = ScriptedAdapter((RequestOptions request) {
      if (request.uri.path.endsWith('/dashboard/dashboard')) {
        dashboardCalls++;
        if (dashboardCalls == 1) {
          return jsonResponse(401, <String, Object?>{'error': 'expired'});
        }
        expect(request.headers['authorization'], 'Bearer refreshed-after-401');
        return jsonResponse(200, <String, Object?>{
          'success': true,
          'data': <String, Object?>{
            'dati': <Object?>[
              <String, Object?>{'registro': <Object?>[]},
            ],
          },
        });
      }
      if (request.uri.path.endsWith('/auth/refresh-token')) {
        refreshCalls++;
        return jsonResponse(200, <String, Object?>{
          'access_token': 'refreshed-after-401',
          'refresh_token': 'rotated-after-401',
          'expires_in': 1800,
          'scope': 'openid offline',
        });
      }
      return jsonResponse(404, <String, Object?>{});
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final client = DidupClient(
      networkClient: DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: dio,
      ),
      sessionStore: store,
      now: () => now,
    );

    final result = await client.fetchDashboard(
      profileId: 'profile-1',
      since: DateTime(2026, 9),
    );

    expect(result['success'], isTrue);
    expect(dashboardCalls, 2);
    expect(refreshCalls, 1);
  });
}
