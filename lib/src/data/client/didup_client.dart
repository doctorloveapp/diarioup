import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/errors/didup_failure.dart';
import '../auth/session.dart';
import '../auth/session_store.dart';
import '../network/didup_network_client.dart';
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

  Dio get _dio => _network.dio;
  DidupProtocolConfig get _config => _network.config;

  Future<Map<String, Object?>> fetchDashboard({
    required String profileId,
    required DateTime since,
  }) async {
    var session = await _requireSession();
    if (session.expiresWithin(_now().toUtc(), _config.refreshLeeway)) {
      session = await _refreshOnce(session);
    }

    var response = await _dashboardRequest(session, profileId, since);
    if (response.statusCode == 401) {
      session = await _refreshOnce(session, force: true);
      response = await _dashboardRequest(session, profileId, since);
    }
    _throwForStatus(response);
    return _stringMap(response.data);
  }

  Future<void> logout() async {
    await _sessionStore.clear();
    await _network.clearTransientCookies();
  }

  Future<DidupSession> _requireSession() async {
    final session = await _sessionStore.read();
    if (session == null) throw const SessionExpiredFailure();
    return session;
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
      await _sessionStore.clear();
      throw const SessionExpiredFailure();
    }
    final profile = session.profiles.values.firstOrNull;
    if (profile == null) {
      await _sessionStore.clear();
      throw const SessionExpiredFailure();
    }

    try {
      final response = await _dio.postUri<Object?>(
        _config.apiUri('auth/refresh-token'),
        data: <String, Object>{
          'r-token': refreshToken,
          'client-id': _config.oauthClientId,
          'scopes': '[${session.scopes.join(', ')}]',
          'old-bearer': session.accessToken,
          'primo-accesso': 'false',
          'ripeti-login': 'false',
          if (session.expiresAt != null)
            'exp-bearer': _formatApiDate(session.expiresAt!),
          'ts-app': _formatApiDate(_now()),
          'proc': _config.appRefreshProcedure,
          'username': session.username,
        },
        options: Options(headers: _sessionHeaders(session, profile)),
      );
      if (response.statusCode == 400 || response.statusCode == 401) {
        await _sessionStore.clear();
        throw const SessionExpiredFailure();
      }
      _throwForStatus(response);
      final body = _stringMap(response.data);
      if (body['error'] != null) {
        await _sessionStore.clear();
        throw const SessionExpiredFailure();
      }
      final expiresIn = _optionalInt(body['expires_in']);
      final serverDate = DateTime.tryParse(
        response.headers.value('date') ?? '',
      );
      final refreshed = session.copyWith(
        accessToken: _requiredString(body, 'access_token'),
        refreshToken:
            _optionalString(body['refresh_token']) ?? session.refreshToken,
        tokenType: _optionalString(body['token_type']) ?? session.tokenType,
        scopes: _optionalString(body['scope'])
            ?.split(' ')
            .where((String value) => value.isNotEmpty)
            .toList(growable: false),
        expiresAt: expiresIn == null
            ? session.expiresAt
            : (serverDate ?? _now().toUtc()).toUtc().add(
                Duration(seconds: expiresIn),
              ),
      );
      await _sessionStore.write(refreshed);
      return refreshed;
    } on DidupFailure {
      rethrow;
    } on DioException catch (_) {
      throw const NetworkFailure();
    }
  }

  Map<String, Object> _sessionHeaders(
    DidupSession session,
    DidupProfileSession profile,
  ) => <String, Object>{
    'accept': 'application/json',
    'content-type': Headers.jsonContentType,
    'argo-client-version': _config.clientVersion,
    'authorization': 'Bearer ${session.accessToken}',
    'x-auth-token': profile.appAuthToken,
    'x-cod-min': profile.schoolMinistryCode,
    if (session.expiresAt != null)
      'x-date-exp-auth': _formatApiDate(session.expiresAt!),
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
