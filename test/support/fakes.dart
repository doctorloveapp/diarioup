import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';

typedef AdapterHandler =
    FutureOr<ResponseBody> Function(RequestOptions options);

final class ScriptedAdapter implements HttpClientAdapter {
  ScriptedAdapter(this.handler);

  final AdapterHandler handler;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(
  int status,
  Object body, {
  Map<String, List<String>> headers = const <String, List<String>>{},
}) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: <String, List<String>>{
    Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    ...headers,
  },
);

ResponseBody redirectResponse(String location) => ResponseBody.fromString(
  '',
  302,
  headers: <String, List<String>>{
    'location': <String>[location],
  },
);

final class MemorySessionStore implements SessionStore {
  MemorySessionStore([this.value]);

  DidupSession? value;
  var writeCount = 0;
  var clearCount = 0;

  @override
  Future<DidupSession?> read() async => value;

  @override
  Future<void> write(DidupSession session) async {
    value = session;
    writeCount++;
  }

  @override
  Future<void> clear() async {
    value = null;
    clearCount++;
  }
}

DidupProtocolConfig testProtocolConfig() => DidupProtocolConfig(
  oauthClientId: 'diarioup-contract-test',
  redirectUri: Uri.parse('it.diarioup.test://oauth-callback'),
  clientVersion: 'contract-test',
);

DidupSession testSession({required DateTime expiresAt}) => DidupSession(
  accessToken: 'synthetic-access',
  refreshToken: 'synthetic-refresh',
  tokenType: 'bearer',
  scopes: const <String>['openid', 'offline'],
  expiresAt: expiresAt,
  schoolCode: 'TEST0000',
  username: 'synthetic-user',
  profiles: <String, DidupProfileSession>{
    'profile-1': DidupProfileSession(
      sourceProfileId: 'profile-1',
      appAuthToken: 'synthetic-app-token',
      schoolMinistryCode: 'TEST0000',
      notificationOptions: const <String, bool>{'compiti': true},
      displayLabel: 'Profilo sintetico',
      academicYear: '2026/2027',
      academicYearStart: DateTime.utc(2026, 9),
    ),
  },
);
