import 'dart:convert';

import 'package:diarioup/diarioup.dart';
import 'package:diarioup/src/data/network/didup_read_retry.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  final now = DateTime.utc(2026, 11, 21);

  test(
    'converte una sessione schema 1 preservando il secondo figlio e tutti i compiti',
    () async {
      final first = testSession(expiresAt: now.add(const Duration(hours: 1)));
      final legacy = first.copyWith(
        usesFamiglia: false,
        activeProfileId: 'profile-2',
        profiles: {
          ...first.profiles,
          'profile-2': const DidupProfileSession(
            sourceProfileId: 'profile-2',
            appAuthToken: 'synthetic-old-second',
            schoolMinistryCode: 'TEST0000',
            notificationOptions: {},
            displayLabel: 'Secondo profilo',
          ),
        },
      );
      final raw =
          jsonDecode(const SessionCodec().encode(legacy))
              as Map<String, Object?>;
      raw['schema'] = 1;
      raw.remove('usesFamiglia');
      final store = MemorySessionStore(
        const SessionCodec().decode(jsonEncode(raw)),
      );
      expect(store.value!.usesFamiglia, isFalse);
      final adapter = ScriptedAdapter((request) {
        expect(request.uri.path, isNot(contains('/appfamiglia/')));
        expect(request.uri.host, 'didattica.portaleargo.it');
        expect(request.headers['os-type'], 'WEB');
        expect(request.headers['argo-client-version'], '4.1.0');
        final bootstrap = famigliaBootstrapResponse(request, twoProfiles: true);
        if (bootstrap != null) return bootstrap;
        expect(request.uri.path, '/famiglia/api/dashboard/dashboard');
        expect(request.headers['x-auth-token'], 'synthetic-second-child');
        return jsonResponse(200, {
          'success': true,
          'data': {
            'dati': [
              {
                'registro': [
                  {
                    'pk': 'source-1',
                    'datGiorno': '21/11/2026',
                    'materia': 'Italiano',
                    'compiti': [
                      {
                        'pk': 'nested-1',
                        'compito': 'Compito sintetico',
                        'dataConsegna': '23/11/2026',
                      },
                    ],
                  },
                ],
              },
            ],
          },
        });
      });
      final network = DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: Dio()..httpClientAdapter = adapter,
      );
      addTearDown(network.dio.close);
      final client = DidupClient(
        networkClient: network,
        sessionStore: store,
        now: () => now,
      );
      final response = await client.fetchDashboard(
        profileId: 'profile-2',
        since: now,
      );
      final batch = await HomeworkNormalizer(
        identityRegistry: InMemoryHomeworkIdentityRegistry(),
      ).normalizeDashboard(profileId: 'profile-2', response: response);
      expect(batch.homework.single.text, 'Compito sintetico');
      expect(batch.homework.single.dueOn, const SchoolDate(2026, 11, 23));
      expect(store.value!.usesFamiglia, isTrue);
      expect(store.value!.activeProfileId, 'profile-2');
      expect(
        store.value!.profiles.keys,
        containsAll(['profile-1', 'profile-2']),
      );
      expect(store.value!.profiles['profile-2']!.schoolClassLabel, 'III C');
      final restored = const SessionCodec().decode(
        const SessionCodec().encode(store.value!),
      );
      expect(restored.usesFamiglia, isTrue);
      expect(restored.activeProfileId, 'profile-2');
      final calls = adapter.requests.length;
      await client.fetchDashboard(profileId: 'profile-2', since: now);
      expect(adapter.requests.length, calls + 1);
      expect(
        const SessionCodec().encode(restored),
        isNot(contains('password')),
      );
    },
  );

  test(
    'un bootstrap fallito conserva il token ruotato e riparte senza riusare il refresh',
    () async {
      final store = MemorySessionStore(testSession(expiresAt: now));
      var refreshing = 0;
      var unavailable = true;
      final adapter = ScriptedAdapter((request) {
        expect(request.uri.path, isNot(contains('/appfamiglia/')));
        if (request.uri.path == '/oauth2/token') {
          refreshing++;
          expect(request.data, {
            'grant_type': 'refresh_token',
            'refresh_token': 'synthetic-refresh',
            'client_id': 'diarioup-contract-test',
          });
          expect(request.headers['x-auth-token'], isNull);
          return jsonResponse(200, {
            'access_token': 'rotated-access',
            'refresh_token': 'rotated-refresh',
            'expires_in': 1800,
          });
        }
        if (unavailable) return jsonResponse(503, {});
        final bootstrap = famigliaBootstrapResponse(request);
        if (bootstrap != null) return bootstrap;
        return jsonResponse(200, {
          'success': true,
          'data': {'dati': <Object?>[]},
        });
      });
      final network = DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: Dio()..httpClientAdapter = adapter,
        readRetry: DidupReadRetry(pause: (_, token) async {}),
      );
      addTearDown(network.dio.close);
      final client = DidupClient(
        networkClient: network,
        sessionStore: store,
        now: () => now,
      );
      await expectLater(
        client.fetchDashboard(profileId: 'profile-1', since: now),
        throwsA(isA<NetworkFailure>()),
      );
      expect(store.value!.refreshToken, 'rotated-refresh');
      expect(store.value!.usesFamiglia, isFalse);
      unavailable = false;
      await client.fetchDashboard(profileId: 'profile-1', since: now);
      expect(refreshing, 1);
      expect(store.value!.usesFamiglia, isTrue);
    },
  );

  test('il logout durante il bootstrap non ripristina una sessione', () async {
    final store = MemorySessionStore(
      testSession(
        expiresAt: now.add(const Duration(hours: 1)),
      ).copyWith(usesFamiglia: false),
    );
    final adapter = ScriptedAdapter((request) async {
      if (request.uri.path.endsWith('/profilo')) await store.clear();
      return famigliaBootstrapResponse(request)!;
    });
    final network = DidupNetworkClient.create(
      config: testProtocolConfig(),
      dio: Dio()..httpClientAdapter = adapter,
    );
    addTearDown(network.dio.close);
    await expectLater(
      DidupClient(
        networkClient: network,
        sessionStore: store,
        now: () => now,
      ).fetchDashboard(profileId: 'profile-1', since: now),
      throwsA(isA<SessionExpiredFailure>()),
    );
    expect(store.value, isNull);
  });

  test(
    'un figlio non più disponibile non viene sostituito dal primo',
    () async {
      final original = testSession(
        expiresAt: now.add(const Duration(hours: 1)),
      ).copyWith(usesFamiglia: false, activeProfileId: 'profile-2');
      final store = MemorySessionStore(original);
      final adapter = ScriptedAdapter((request) {
        // The server now returns only the other child.
        return famigliaBootstrapResponse(request)!;
      });
      final network = DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: Dio()..httpClientAdapter = adapter,
      );
      addTearDown(network.dio.close);
      await expectLater(
        DidupClient(
          networkClient: network,
          sessionStore: store,
          now: () => now,
        ).fetchDashboard(profileId: 'profile-2', since: now),
        throwsA(isA<PermissionDeniedFailure>()),
      );
      expect(store.value, same(original));
      expect(store.value!.activeProfileId, 'profile-2');
      expect(
        adapter.requests.where((r) => r.uri.path.contains('dashboard')),
        isEmpty,
      );
    },
  );

  test(
    'invalid_grant richiede nuovo accesso senza esporre error_description',
    () async {
      final store = MemorySessionStore(testSession(expiresAt: now));
      final adapter = ScriptedAdapter(
        (request) => jsonResponse(400, {
          'error': 'invalid_grant',
          'error_description': 'private-marker',
        }),
      );
      final network = DidupNetworkClient.create(
        config: testProtocolConfig(),
        dio: Dio()..httpClientAdapter = adapter,
      );
      addTearDown(network.dio.close);
      await expectLater(
        DidupClient(
          networkClient: network,
          sessionStore: store,
          now: () => now,
        ).fetchDashboard(profileId: 'profile-1', since: now),
        throwsA(
          isA<SessionExpiredFailure>().having(
            (failure) => failure.message,
            'message',
            isNot(contains('private-marker')),
          ),
        ),
      );
      expect(store.value, isNull);
      expect(adapter.requests, hasLength(1));
    },
  );
}
