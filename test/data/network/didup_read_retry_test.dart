import 'dart:async';

import 'package:diarioup/src/data/network/didup_read_retry.dart';
import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'timeout e gateway temporanei usano al massimo due retry con backoff',
    () async {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
        DioExceptionType.badResponse,
      ]) {
        final pauses = <Duration>[];
        var calls = 0;
        final retry = DidupReadRetry(
          pause: (delay, _) async => pauses.add(delay),
        );
        final result = await retry.run(() async {
          if (++calls < 3) throw _error(type, status: 503);
          return 'ok';
        });
        expect(result, 'ok');
        expect(calls, 3);
        expect(pauses, [
          const Duration(seconds: 1),
          const Duration(seconds: 2),
        ]);
      }
    },
  );

  test('un guasto persistente si ferma dopo tre richieste', () async {
    var calls = 0;
    final retry = DidupReadRetry(pause: (_, token) async {});
    await expectLater(
      retry.run<void>(() async {
        calls++;
        throw _error(DioExceptionType.receiveTimeout);
      }),
      throwsA(isA<DioException>()),
    );
    expect(calls, 3);
  });

  test(
    'rifiuti, rate limit e guasti non transitori non vengono ripetuti',
    () async {
      final retry = DidupReadRetry(
        pause: (_, token) async => fail('Attesa non prevista'),
      );
      for (final status in [400, 401, 403, 404, 410, 429, 500, 501]) {
        var calls = 0;
        await expectLater(
          retry.run<void>(() async {
            calls++;
            throw _error(DioExceptionType.badResponse, status: status);
          }),
          throwsA(isA<DioException>()),
        );
        expect(calls, 1);
      }
      for (final type in [
        DioExceptionType.badCertificate,
        DioExceptionType.cancel,
        DioExceptionType.unknown,
      ]) {
        var calls = 0;
        await expectLater(
          retry.run<void>(() async {
            calls++;
            throw _error(type);
          }),
          throwsA(isA<DioException>()),
        );
        expect(calls, 1);
      }
    },
  );

  test('accetta 502 e 504 oltre a 503', () async {
    for (final status in [502, 504]) {
      var calls = 0;
      final retry = DidupReadRetry(pause: (_, token) async {});
      expect(
        await retry.run(() async {
          if (++calls == 1) {
            throw _error(DioExceptionType.badResponse, status: status);
          }
          return status;
        }),
        status,
      );
      expect(calls, 2);
    }
  });

  test('la cancellazione interrompe il backoff e cancella il timer', () async {
    final token = CancelToken();
    final firstCall = Completer<void>();
    var calls = 0;
    final pending = const DidupReadRetry().run<void>(() async {
      calls++;
      firstCall.complete();
      throw _error(DioExceptionType.connectionError, token: token);
    });
    final check = expectLater(
      pending,
      throwsA(
        isA<DioException>().having(
          (error) => error.type,
          'type',
          DioExceptionType.cancel,
        ),
      ),
    );
    await firstCall.future;
    await Future<void>.delayed(Duration.zero);
    token.cancel();
    await check;
    expect(calls, 1);
  });

  test(
    'gli errori di dominio non espongono URL, header o messaggi del trasporto',
    () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final failure = transportFailure(_error(type));
        expect(failure, isA<RequestTimeoutFailure>());
        expect(failure.toString(), isNot(contains('DETTAGLIO_NON_PUBBLICO')));
      }
      expect(
        transportFailure(_error(DioExceptionType.connectionError)),
        isA<NetworkFailure>(),
      );
      const blocked = CompatibilityFailure();
      expect(
        transportFailure(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            error: blocked,
          ),
        ),
        same(blocked),
      );
    },
  );
}

DioException _error(DioExceptionType type, {int? status, CancelToken? token}) {
  final options = RequestOptions(
    path: '/DETTAGLIO_NON_PUBBLICO',
    cancelToken: token,
  );
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response<Object?>(requestOptions: options, statusCode: status),
    message: 'DETTAGLIO_NON_PUBBLICO',
  );
}
