import 'package:cookie_jar/cookie_jar.dart';
import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test('configura timeout, cookie volatili e nessun logger HTTP', () {
    final client = DidupNetworkClient.create(config: testProtocolConfig());

    expect(client.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(client.dio.options.receiveTimeout, const Duration(seconds: 20));
    expect(client.cookieJar, isA<CookieJar>());
    expect(client.cookieJar, isNot(isA<PersistCookieJar>()));
    expect(client.dio.interceptors.whereType<CookieManager>(), hasLength(1));
    expect(client.dio.interceptors.whereType<LogInterceptor>(), isEmpty);
  });

  test('rifiuta host fuori allowlist prima del trasporto', () async {
    final adapter = ScriptedAdapter(
      (RequestOptions _) => jsonResponse(200, <String, Object?>{}),
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final client = DidupNetworkClient.create(
      config: testProtocolConfig(),
      dio: dio,
    );

    await expectLater(
      client.dio.getUri<Object?>(Uri.parse('https://invalid.example/data')),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests, isEmpty);
  });
}
