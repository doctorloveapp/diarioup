import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/errors/didup_failure.dart';
import '../auth/session.dart';
import '../auth/didup_auth_service.dart';
import '../auth/session_store.dart';
import '../network/didup_network_client.dart';
import '../network/didup_read_retry.dart';
import '../protocol/didup_protocol_config.dart';

final class DidupClient {
  DidupClient({
    required DidupNetworkClient networkClient,
    required SessionStore sessionStore,
    DateTime Function()? now,
  }) : _network = networkClient,
       _sessionStore = sessionStore,
       _now = now ?? DateTime.now;

  final DidupNetworkClient _network;
  final SessionStore _sessionStore;
  final DateTime Function() _now;
  Future<DidupSession>? _refreshInFlight;
  Future<DidupSession>? _bootstrapInFlight;

  Dio get _dio => _network.dio;
  DidupProtocolConfig get _config => _network.config;

  Future<Map<String, Object?>> fetchDashboard({
    required String profileId,
    required DateTime since,
  }) async {
    try {
      return await _fetchDashboard(profileId: profileId, since: since);
    } on DioException catch (error) {
      throw transportFailure(error);
    }
  }

  Future<Map<String, Object?>> _fetchDashboard({
    required String profileId,
    required DateTime since,
  }) async {
    var session = await _requireSession();
    if (session.expiresWithin(_now().toUtc(), _config.refreshLeeway)) {
      session = await _refreshOnce(session);
    }

    var response = await _network.readRetry.run(
      () => _dashboardRequest(session, profileId, since),
    );
    if (response.statusCode == 401) {
      session = await _refreshOnce(session, force: true);
      response = await _network.readRetry.run(
        () => _dashboardRequest(session, profileId, since),
      );
    }
    _throwForStatus(response);
    return _stringMap(response.data);
  }

  Future<void> logout() async {
    await _sessionStore.clear();
    await _network.clearTransientCookies();
  }

  /// Used to enrich sessions created before class metadata was persisted.
  Future<Map<String, Object?>> fetchProfile({required String profileId}) async {
    try {
      return await _fetchProfile(profileId);
    } on DioException catch (error) {
      throw transportFailure(error);
    }
  }

  Future<Map<String, Object?>> _fetchProfile(String profileId) async {
    var session = await _requireSession();
    if (session.expiresWithin(_now().toUtc(), _config.refreshLeeway)) {
      session = await _refreshOnce(session);
    }
    Future<Response<Object?>> request(DidupSession current) {
      final profile = current.profiles[profileId];
      if (profile == null) throw const PermissionDeniedFailure();
      return _dio.getUri<Object?>(
        _config.apiUri('profilo'),
        options: Options(headers: _sessionHeaders(current, profile)),
      );
    }

    var response = await _network.readRetry.run(() => request(session));
    if (response.statusCode == 401) {
      session = await _refreshOnce(session, force: true);
      response = await _network.readRetry.run(() => request(session));
    }
    _throwForStatus(response);
    final body = _stringMap(response.data);
    if (body['success'] == false) throw const InvalidPayloadFailure();
    final data = _stringMap(body['data']);
    if (_stringMap(data['scheda'])['pk'] != profileId) {
      throw const InvalidPayloadFailure('Profilo ricevuto non corrispondente.');
    }
    return data;
  }

  Future<DidupSession> _requireSession() async {
    final session = await _sessionStore.read();
    if (session == null) throw const SessionExpiredFailure();
    if (session.expiresWithin(_now().toUtc(), _config.refreshLeeway)) {
      return _refreshOnce(session);
    }
    if (!session.usesFamiglia) return _bootstrapOnce(session);
    return session;
  }

  Future<DidupSession> _bootstrapOnce(DidupSession session) async {
    final pending = _bootstrapInFlight;
    if (pending != null) return pending;
    final operation = _bootstrapAndStore(session);
    _bootstrapInFlight = operation;
    try {
      return await operation;
    } finally {
      if (identical(_bootstrapInFlight, operation)) _bootstrapInFlight = null;
    }
  }

  Future<DidupSession> _bootstrapAndStore(DidupSession session) async {
    final renewed = await DioDidupAuthService(
      networkClient: _network,
      now: _now,
    ).bootstrapSession(session);
    final latest = await _sessionStore.read();
    if (latest == null ||
        latest.accessToken != session.accessToken ||
        latest.username != session.username ||
        latest.schoolCode != session.schoolCode) {
      throw const SessionExpiredFailure();
    }
    // A profile switch during the request must not be lost.
    if (latest.activeProfileId != null &&
        !renewed.profiles.containsKey(latest.activeProfileId)) {
      throw const PermissionDeniedFailure();
    }
    final selected = renewed.copyWith(activeProfileId: latest.activeProfileId);
    await _sessionStore.write(selected);
    return selected;
  }

  Future<Response<Object?>> _dashboardRequest(
    DidupSession session,
    String profileId,
    DateTime since,
  ) {
    final profile = session.profiles[profileId];
    if (profile == null) {
      throw const PermissionDeniedFailure('Profilo non disponibile.');
    }
    return _dio.postUri<Object?>(
      _config.apiUri('dashboard/dashboard'),
      data: <String, Object>{
        'dataultimoaggiornamento': _formatApiDate(since),
        'opzioni': _encodeOptions(profile.notificationOptions),
      },
      options: Options(headers: _sessionHeaders(session, profile)),
    );
  }

  Future<DidupSession> _refreshOnce(
    DidupSession session, {
    bool force = false,
  }) async {
    if (!force &&
        !session.expiresWithin(_now().toUtc(), _config.refreshLeeway)) {
      return session;
    }
    final activeRefresh = _refreshInFlight;
    if (activeRefresh != null) return activeRefresh;
    if (force) {
      final latest = await _sessionStore.read();
      if (latest != null && latest.accessToken != session.accessToken) {
        return latest;
      }
    }

    final refresh = _performRefresh(session);
    _refreshInFlight = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshInFlight, refresh)) _refreshInFlight = null;
    }
  }

  Future<DidupSession> _performRefresh(DidupSession session) async {
    final refreshToken = session.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await _invalidateIfCurrent(session);
      throw const SessionExpiredFailure();
    }
    try {
      final response = await _dio.postUri<Object?>(
        _config.oauthTokenUri,
        data: <String, String>{
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _config.oauthClientId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final body = _stringMap(response.data);
      if (body['error'] == 'invalid_grant' || response.statusCode == 401) {
        await _invalidateIfCurrent(session);
        throw const SessionExpiredFailure();
      }
      if (body['error'] != null) {
        throw const CompatibilityFailure(
          'Il server OAuth non ha autorizzato il rinnovo della sessione.',
        );
      }
      _throwForStatus(response);
      final expiresIn = _optionalInt(body['expires_in']);
      if (expiresIn == null || expiresIn <= 0) {
        throw const InvalidPayloadFailure(
          'Scadenza del token rinnovato non valida.',
        );
      }
      final serverDate = DateTime.tryParse(
        response.headers.value('date') ?? '',
      );
      final refreshed = session.copyWith(
        usesFamiglia: false,
        accessToken: _requiredString(body, 'access_token'),
        refreshToken:
            _optionalString(body['refresh_token']) ?? session.refreshToken,
        tokenType: _optionalString(body['token_type']) ?? session.tokenType,
        scopes: _optionalString(body['scope'])
            ?.split(' ')
            .where((String value) => value.isNotEmpty)
            .toList(growable: false),
        expiresAt: (serverDate ?? _now().toUtc()).toUtc().add(
          Duration(seconds: expiresIn),
        ),
      );
      final latest = await _sessionStore.read();
      if (latest == null || latest.accessToken != session.accessToken) {
        throw const SessionExpiredFailure();
      }
      // Save rotated tokens before bootstrap: a temporary web failure must not
      // cause the next attempt to reuse a consumed refresh token.
      final preserved = refreshed.copyWith(
        activeProfileId: latest.activeProfileId,
      );
      await _sessionStore.write(preserved);
      return _bootstrapOnce(preserved);
    } on DidupFailure {
      rethrow;
    } on DioException catch (error) {
      throw transportFailure(error);
    }
  }

  Future<void> _invalidateIfCurrent(DidupSession session) async {
    final latest = await _sessionStore.read();
    if (latest?.accessToken == session.accessToken) {
      await _sessionStore.clear();
    }
  }

  Map<String, Object> _sessionHeaders(
    DidupSession session,
    DidupProfileSession profile,
  ) => <String, Object>{
    'accept': 'application/json',
    'content-type': Headers.jsonContentType,
    'argo-client-version': _config.famigliaVersion,
    'os-type': 'WEB',
    'authorization': 'Bearer ${session.accessToken}',
    'x-auth-token': profile.appAuthToken,
    'x-cod-min': profile.schoolMinistryCode,
  };
}

String _formatApiDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  String three(int number) => number.toString().padLeft(3, '0');
  return '${local.year.toString().padLeft(4, '0')}-'
      '${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}:${two(local.second)}.'
      '${three(local.millisecond)}';
}

String _encodeOptions(Map<String, bool> options) {
  return jsonEncode(options);
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

void _throwForStatus(Response<Object?> response) {
  final status = response.statusCode;
  if (status == 401) throw const SessionExpiredFailure();
  if (status == 403) throw const PermissionDeniedFailure();
  if (status == 410) throw const CompatibilityFailure();
  if (status == 429) {
    final seconds = int.tryParse(response.headers.value('retry-after') ?? '');
    throw RateLimitedFailure(
      retryAfter: seconds == null
          ? const Duration(minutes: 15)
          : Duration(seconds: seconds),
    );
  }
  if (status == null || status >= 500) throw const NetworkFailure();
  if (status < 200 || status >= 300) throw const InvalidPayloadFailure();
}
