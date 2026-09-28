import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/errors/didup_failure.dart';
import '../network/didup_network_client.dart';
import '../protocol/didup_protocol_config.dart';
import 'session.dart';

final class RemoteLoginResult {
  const RemoteLoginResult({required this.session, required this.profiles});

  final DidupSession session;
  final List<StudentProfile> profiles;
}

abstract interface class DidupAuthService {
  Future<RemoteLoginResult> login(AuthCredentials credentials);
}

final class DioDidupAuthService implements DidupAuthService {
  DioDidupAuthService({
    required DidupNetworkClient networkClient,
    Random? secureRandom,
    DateTime Function()? now,
  }) : _network = networkClient,
       _random = secureRandom ?? Random.secure(),
       _now = now ?? DateTime.now;

  final DidupNetworkClient _network;
  final Random _random;
  final DateTime Function() _now;

  DidupProtocolConfig get _config => _network.config;
  Dio get _dio => _network.dio;

  @override
  Future<RemoteLoginResult> login(AuthCredentials credentials) async {
    await _network.clearTransientCookies();
    try {
      final attempt = _createPkceAttempt();
      final authorizationCode = await _obtainAuthorizationCode(
        credentials,
        attempt,
      );
      final oauth = await _exchangeCode(attempt, authorizationCode);
      final rawProfiles = await _applicationLogin(oauth);
      final profileSessions = <String, DidupProfileSession>{};
      final profiles = <StudentProfile>[];
      String? refreshUsername;

      for (var index = 0; index < rawProfiles.length; index++) {
        final loginContext = _stringMap(rawProfiles[index]);
        refreshUsername ??= _optionalString(loginContext['username']);
        final profilePayload = await _loadProfile(oauth, loginContext);
        final profile = _parseProfile(
          profilePayload,
          schoolMinistryCode: _requiredString(loginContext, 'codMin'),
        );
        if (profileSessions.containsKey(profile.sourceProfileId)) {
          throw const InvalidPayloadFailure('Profilo DidUP duplicato.');
        }
        profileSessions[profile.sourceProfileId] = DidupProfileSession(
          sourceProfileId: profile.sourceProfileId,
          appAuthToken: _requiredString(loginContext, 'token'),
          schoolMinistryCode: _requiredString(loginContext, 'codMin'),
          notificationOptions: _parseOptions(loginContext['opzioni']),
          displayLabel: profile.displayLabel,
          academicYear: profile.academicYear,
          academicYearStart: profile.academicYearStart,
        );
        profiles.add(profile);
      }

      if (profiles.isEmpty) {
        throw const InvalidPayloadFailure(
          'Il login non ha restituito profili selezionabili.',
        );
      }

      return RemoteLoginResult(
        session: DidupSession(
          accessToken: oauth.accessToken,
          refreshToken: oauth.refreshToken,
          tokenType: oauth.tokenType,
          scopes: oauth.scopes,
          expiresAt: oauth.expiresAt,
          schoolCode: credentials.schoolCode,
          username: refreshUsername ?? credentials.username,
          profiles: profileSessions,
        ),
        profiles: List<StudentProfile>.unmodifiable(profiles),
      );
    } on DidupFailure {
      rethrow;
    } on DioException catch (_) {
      throw const NetworkFailure();
    } on FormatException catch (_) {
      throw const InvalidPayloadFailure();
    } finally {
      await _network.clearTransientCookies();
    }
  }

  _PkceAttempt _createPkceAttempt() {
    final verifier = _randomString(64);
    final digest = sha256.convert(utf8.encode(verifier)).bytes;
    final challenge = base64Url.encode(digest).replaceAll('=', '');
    return _PkceAttempt(
      verifier: verifier,
      challenge: challenge,
      state: _randomString(32),
      nonce: _randomString(32),
    );
  }

  Future<String> _obtainAuthorizationCode(
    AuthCredentials credentials,
    _PkceAttempt attempt,
  ) async {
    final authorizeUri = _config.oauthAuthorizeUri.replace(
      queryParameters: <String, String>{
        'redirect_uri': _config.redirectUri.toString(),
        'client_id': _config.oauthClientId,
        'response_type': 'code',
        'prompt': 'login',
        'state': attempt.state,
        'nonce': attempt.nonce,
        'scope': _config.oauthScopes.join(' '),
        'code_challenge': attempt.challenge,
        'code_challenge_method': 'S256',
      },
    );
    final start = await _dio.getUri<Object?>(authorizeUri);
    final challengeLocation = _redirectLocation(start);
    final loginChallenge = challengeLocation.queryParameters['login_challenge'];
    if (loginChallenge == null || loginChallenge.isEmpty) {
      throw const AuthenticationFailure('Challenge di login mancante.');
    }

    final login = await _dio.postUri<Object?>(
      _config.ssoLoginUri,
      data: <String, String>{
        'challenge': loginChallenge,
        'client_id': _config.oauthClientId,
        'prefill': 'false',
        'famiglia_customer_code': credentials.schoolCode,
        'username': credentials.username,
        'password': credentials.password,
        'login': 'true',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (login.statusCode == 401 || login.statusCode == 403) {
      throw const AuthenticationFailure();
    }

    var location = _redirectLocation(login);
    for (var redirects = 0; redirects < 6; redirects++) {
      if (_config.isRedirectCallback(location)) {
        final returnedState = location.queryParameters['state'];
        final code = location.queryParameters['code'];
        if (returnedState != attempt.state || code == null || code.isEmpty) {
          throw const AuthenticationFailure('Callback OAuth non valida.');
        }
        return code;
      }
      if (!_config.isTrustedNetworkUri(location)) {
        throw const CompatibilityFailure('Redirect OAuth non ammesso.');
      }
      final response = await _dio.getUri<Object?>(location);
      location = _redirectLocation(response);
    }
    throw const AuthenticationFailure('Troppi redirect durante il login.');
  }

  Future<_OAuthToken> _exchangeCode(
    _PkceAttempt attempt,
    String authorizationCode,
  ) async {
    final response = await _dio.postUri<Object?>(
      _config.oauthTokenUri,
      data: <String, String>{
        'code': authorizationCode,
        'grant_type': 'authorization_code',
        'redirect_uri': _config.redirectUri.toString(),
        'code_verifier': attempt.verifier,
        'client_id': _config.oauthClientId,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (response.statusCode != 200) throw const AuthenticationFailure();
    final body = _stringMap(response.data);
    if (body['error'] != null) throw const AuthenticationFailure();
    final accessToken = _requiredString(body, 'access_token');
    final expiresIn = _optionalInt(body['expires_in']);
    return _OAuthToken(
      accessToken: accessToken,
      refreshToken: _optionalString(body['refresh_token']),
      tokenType: _optionalString(body['token_type']) ?? 'bearer',
      scopes: (_optionalString(body['scope']) ?? '')
          .split(' ')
          .where((String value) => value.isNotEmpty)
          .toList(growable: false),
      expiresAt: expiresIn == null
          ? null
          : _now().toUtc().add(Duration(seconds: expiresIn)),
    );
  }

  Future<List<Object?>> _applicationLogin(_OAuthToken oauth) async {
    final response = await _dio.postUri<Object?>(
      _config.apiUri('login'),
      data: <String, Object>{
        'lista-opzioni-notifiche': '{}',
        'lista-x-auth-token': '[]',
        'clientID': _randomString(163),
      },
      options: Options(
        headers: <String, Object>{
          'authorization': 'Bearer ${oauth.accessToken}',
          'argo-client-version': _config.clientVersion,
          'content-type': Headers.jsonContentType,
        },
      ),
    );
    _throwForStatus(response.statusCode);
    final body = _stringMap(response.data);
    if (body['success'] == false) throw const AuthenticationFailure();
    final data = body['data'];
    if (data is! List<Object?>) throw const InvalidPayloadFailure();
    return data;
  }

  Future<Map<String, Object?>> _loadProfile(
    _OAuthToken oauth,
    Map<String, Object?> loginContext,
  ) async {
    final response = await _dio.getUri<Object?>(
      _config.apiUri('profilo'),
      options: Options(
        headers: <String, Object>{
          'authorization': 'Bearer ${oauth.accessToken}',
          'argo-client-version': _config.clientVersion,
          'x-auth-token': _requiredString(loginContext, 'token'),
          'x-cod-min': _requiredString(loginContext, 'codMin'),
        },
      ),
    );
    _throwForStatus(response.statusCode);
    final body = _stringMap(response.data);
    if (body['success'] == false) throw const AuthenticationFailure();
    return _stringMap(body['data']);
  }

  StudentProfile _parseProfile(
    Map<String, Object?> raw, {
    required String schoolMinistryCode,
  }) {
    final sheet = _stringMap(raw['scheda']);
    final student = _stringMap(raw['alunno']);
    final year = _stringMap(raw['anno']);
    return StudentProfile(
      sourceProfileId: _requiredString(sheet, 'pk'),
      displayLabel: _optionalString(student['nominativo']) ?? '',
      schoolMinistryCode: schoolMinistryCode,
      academicYear: _optionalString(year['anno']),
      academicYearStart: _optionalDate(year['dataInizio']),
    );
  }

  Map<String, bool> _parseOptions(Object? value) {
    if (value is! List<Object?>) return const <String, bool>{};
    final result = <String, bool>{};
    for (final item in value) {
      final option = _stringMap(item);
      final key = _optionalString(option['chiave']);
      final optionValue = option['valore'];
      if (key != null && optionValue is bool) result[key] = optionValue;
    }
    return result;
  }

  Uri _redirectLocation(Response<Object?> response) {
    final raw = response.headers.value('location');
    if (raw == null || raw.isEmpty) {
      throw const AuthenticationFailure('Redirect di autenticazione mancante.');
    }
    return response.requestOptions.uri.resolve(raw);
  }

  String _randomString(int length) {
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List<String>.generate(
      length,
      (int _) => alphabet[_random.nextInt(alphabet.length)],
      growable: false,
    ).join();
  }
}

final class _PkceAttempt {
  const _PkceAttempt({
    required this.verifier,
    required this.challenge,
    required this.state,
    required this.nonce,
  });

  final String verifier;
  final String challenge;
  final String state;
  final String nonce;
}

final class _OAuthToken {
  const _OAuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.scopes,
    required this.expiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final List<String> scopes;
  final DateTime? expiresAt;
}

Map<String, Object?> _stringMap(Object? value) {
  if (value is! Map<Object?, Object?>) throw const InvalidPayloadFailure();
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) throw const InvalidPayloadFailure();
    result[key] = entry.value;
  }
  return result;
}

String _requiredString(Map<String, Object?> map, String key) {
  final value = _optionalString(map[key]);
  if (value == null || value.isEmpty) throw const InvalidPayloadFailure();
  return value;
}

String? _optionalString(Object? value) => value is String ? value : null;

int? _optionalInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return value is String ? int.tryParse(value) : null;
}

DateTime? _optionalDate(Object? value) {
  final text = _optionalString(value);
  return text == null ? null : DateTime.tryParse(text);
}

void _throwForStatus(int? status) {
  if (status == 401) throw const SessionExpiredFailure();
  if (status == 403) throw const PermissionDeniedFailure();
  if (status == 410) throw const CompatibilityFailure();
  if (status == 429) throw const RateLimitedFailure();
  if (status == null || status >= 500) throw const NetworkFailure();
  if (status < 200 || status >= 300) throw const AuthenticationFailure();
}
