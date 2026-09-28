import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../domain/errors/didup_failure.dart';
import '../protocol/didup_protocol_config.dart';

final class DidupNetworkClient {
  DidupNetworkClient._({
    required this.dio,
    required this.cookieJar,
    required this.config,
  });

  factory DidupNetworkClient.create({
    required DidupProtocolConfig config,
    Dio? dio,
    CookieJar? cookieJar,
  }) {
    final resolvedDio = dio ?? Dio();
    resolvedDio.options = resolvedDio.options.copyWith(
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      followRedirects: false,
      maxRedirects: 0,
      validateStatus: (int? status) =>
          status != null && status >= 200 && status < 500,
      responseType: ResponseType.json,
      headers: <String, Object>{'accept': 'application/json'},
    );
    final resolvedJar = cookieJar ?? CookieJar();
    resolvedDio.interceptors.add(_TrustedHostInterceptor(config));
    resolvedDio.interceptors.add(CookieManager(resolvedJar));

    // Nessun LogInterceptor: header, cookie e payload scolastici non sono loggabili.
    return DidupNetworkClient._(
      dio: resolvedDio,
      cookieJar: resolvedJar,
      config: config,
    );
  }

  final Dio dio;
  final CookieJar cookieJar;
  final DidupProtocolConfig config;

  Future<void> clearTransientCookies() => cookieJar.deleteAll();
}

final class _TrustedHostInterceptor extends Interceptor {
  const _TrustedHostInterceptor(this._config);

  final DidupProtocolConfig _config;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_config.isTrustedNetworkUri(options.uri)) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: const CompatibilityFailure(
            'Destinazione di rete non ammessa.',
          ),
        ),
      );
      return;
    }
    handler.next(options);
  }
}
