import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test(
    'login PKCE restituisce tutti i profili e non persiste la password',
    () async {
      final config = testProtocolConfig();
      String? state;
      final adapter = ScriptedAdapter((RequestOptions request) {
        if (request.uri.path == '/oauth2/auth') {
          state = request.uri.queryParameters['state'];
          expect(request.uri.queryParameters['code_challenge_method'], 'S256');
          return redirectResponse(
            '${config.ssoLoginUri}?login_challenge=synthetic-challenge',
            cookies: const <String>[
              'oauth_csrf=csrf-value; Path=/; Secure; HttpOnly',
            ],
          );
        }
        if (request.uri.path == '/auth/sso/login') {
          final form = Uri.splitQueryString(request.data! as String);
          expect(form['password'], isNotEmpty);
          expect(request.headers['cookie'], isNull);
          return redirectResponse(
            '${config.oauthAuthorizeUri.origin}/oauth2/continue-1',
          );
        }
        if (request.uri.path == '/oauth2/continue-1') {
          expect(request.headers['cookie'], contains('oauth_csrf=csrf-value'));
          return redirectResponse(
            '${config.ssoLoginUri.resolve('/auth/sso/continue-2')}',
            cookies: const <String>[
              'sso_session=sso-value; Path=/; Secure; HttpOnly',
            ],
          );
        }
        if (request.uri.path == '/auth/sso/continue-2') {
          expect(request.headers['cookie'], isNull);
          return redirectResponse(
            '${config.oauthAuthorizeUri.origin}/oauth2/continue-3',
          );
        }
        if (request.uri.path == '/oauth2/continue-3') {
          expect(request.headers['cookie'], contains('oauth_csrf=csrf-value'));
          expect(request.headers['cookie'], contains('sso_session=sso-value'));
          return redirectResponse(
            '${config.redirectUri}?code=synthetic-code&state=$state',
          );
        }
        if (request.uri.path == '/oauth2/token') {
          return jsonResponse(200, <String, Object?>{
            'access_token': 'synthetic-access',
            'refresh_token': 'synthetic-refresh',
            'token_type': 'bearer',
            'scope': 'openid offline',
            'expires_in': 900,
          });
        }
        if (request.uri.path.endsWith('/login')) {
          expect(request.headers['x-date-exp-auth'], isNotNull);
          return jsonResponse(200, <String, Object?>{
            'success': true,
            // Dal 28/09/2026 Argo puo annidare le righe in contenitori
            // diversi da `data`; questo riproduce il formato osservato.
            'data': <String, Object?>{
              'dati': <Object?>[
                <String, Object?>{
                  'token': 'synthetic-app-token-1',
                  'codMin': 'TEST0000',
                  'username': 'synthetic-user',
                  'opzioni': <Object?>[
                    <String, Object?>{'chiave': 'compiti', 'valore': true},
                  ],
                },
                <String, Object?>{
                  'token': 'synthetic-app-token-2',
                  'codMin': 'TEST0000',
                  'username': 'synthetic-user',
                  'opzioni': <Object?>[],
                },
              ],
            },
          });
        }
        if (request.uri.path.endsWith('/profilo')) {
          expect(request.headers['x-date-exp-auth'], isNotNull);
          final appToken = request.headers['x-auth-token'];
          final suffix = appToken == 'synthetic-app-token-1' ? '1' : '2';
          return jsonResponse(200, <String, Object?>{
            'success': true,
            'data': <String, Object?>{
              'scheda': <String, Object?>{'pk': 'profile-$suffix'},
              'alunno': <String, Object?>{'nominativo': 'Profilo $suffix'},
              'anno': <String, Object?>{
                'anno': '2026/2027',
                'dataInizio': '2026-09-01T00:00:00Z',
              },
            },
          });
        }
        return jsonResponse(404, <String, Object?>{});
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final network = DidupNetworkClient.create(config: config, dio: dio);
      final store = MemorySessionStore();
      final authService = DioDidupAuthService(networkClient: network);
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = DidupRepositoryImpl(
        authService: authService,
        client: DidupClient(networkClient: network, sessionStore: store),
        database: database,
        sessionStore: store,
        normalizer: HomeworkNormalizer(
          identityRegistry: InMemoryHomeworkIdentityRegistry(),
        ),
        adapterVersion: 'contract-test',
      );
      final password = String.fromCharCodes(
        List<int>.generate(48, (int index) => 33 + (index * 17) % 90),
      );
      final credentials = AuthCredentials(
        schoolCode: 'TEST0000',
        username: 'synthetic-user',
        password: password,
      );

      final result = await repository.login(credentials);

      expect(result.profiles, hasLength(2));
      expect(result.requiresProfileSelection, isTrue);
      expect(store.writeCount, 1);
      final encoded = const SessionCodec().encode(store.value!);
      expect(encoded, isNot(contains(password)));
      expect(encoded.toLowerCase(), isNot(contains('password')));
      expect(credentials.toString(), isNot(contains(password)));

      final selectedProfile = result.profiles.last;
      await repository.rememberActiveProfile(selectedProfile.sourceProfileId);
      final restoredProfile = await repository.restoreActiveProfile();

      expect(store.writeCount, 2);
      expect(store.value!.activeProfileId, selectedProfile.sourceProfileId);
      expect(restoredProfile!.sourceProfileId, selectedProfile.sourceProfileId);
    },
  );

  test('credenziali rifiutate da Argo non producono una sessione', () async {
    final config = testProtocolConfig();
    final adapter = ScriptedAdapter((RequestOptions request) {
      if (request.uri.path == '/oauth2/auth') {
        return redirectResponse(
          '${config.ssoLoginUri}?login_challenge=synthetic-challenge',
        );
      }
      if (request.uri.path == '/auth/sso/login') {
        return jsonResponse(401, <String, Object?>{'success': false});
      }
      fail('Richiesta inattesa dopo il rifiuto delle credenziali.');
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final network = DidupNetworkClient.create(config: config, dio: dio);
    final authService = DioDidupAuthService(networkClient: network);

    await expectLater(
      authService.login(
        AuthCredentials(
          schoolCode: 'TEST0000',
          username: 'utente-errato',
          password: 'password-errata',
        ),
      ),
      throwsA(isA<AuthenticationFailure>()),
    );
    expect(adapter.requests, hasLength(2));
  });

  test(
    'un redirect mancante identifica lo stadio senza dati sensibili',
    () async {
      final config = testProtocolConfig();
      final adapter = ScriptedAdapter(
        (RequestOptions request) => jsonResponse(200, <String, Object?>{}),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final network = DidupNetworkClient.create(config: config, dio: dio);
      final authService = DioDidupAuthService(networkClient: network);

      await expectLater(
        authService.login(
          AuthCredentials(
            schoolCode: 'TEST0000',
            username: 'synthetic-user',
            password: 'synthetic-password',
          ),
        ),
        throwsA(
          isA<CompatibilityFailure>().having(
            (failure) => failure.message,
            'message',
            'Avvio OAuth senza redirect (HTTP 200).',
          ),
        ),
      );
    },
  );
}
