import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
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
          );
        }
        if (request.uri.path == '/auth/sso/login') {
          final form = request.data! as Map<String, String>;
          expect(form['password'], isNotEmpty);
          return redirectResponse(
            '${config.oauthAuthorizeUri.origin}/oauth2/continue',
          );
        }
        if (request.uri.path == '/oauth2/continue') {
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
          return jsonResponse(200, <String, Object?>{
            'success': true,
            'data': <Object?>[
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
          });
        }
        if (request.uri.path.endsWith('/profilo')) {
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
      final repository = DidupRepositoryImpl(
        authService: authService,
        client: DidupClient(networkClient: network, sessionStore: store),
        sessionStore: store,
        normalizer: HomeworkNormalizer(
          identityRegistry: InMemoryHomeworkIdentityRegistry(),
        ),
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
    },
  );
}
