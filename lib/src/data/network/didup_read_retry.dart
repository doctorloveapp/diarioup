import 'dart:async';

import 'package:dio/dio.dart';

import '../../domain/errors/didup_failure.dart';

typedef RetryPause = Future<void> Function(Duration delay, CancelToken? token);

/// Opt-in for known read-only operations only, including dashboard's read POST.
/// Never wrap credential submission, OAuth code exchange or token rotation.
final class DidupReadRetry {
  const DidupReadRetry({RetryPause? pause}) : _pause = pause ?? _wait;

  final RetryPause _pause;

  Future<T> run<T>(Future<T> Function() operation) async {
    for (var retry = 0; ; retry++) {
      try {
        return await operation();
      } on DioException catch (error) {
        if (retry >= 2 || !_isTransient(error)) rethrow;
        final token = error.requestOptions.cancelToken;
        _throwIfCancelled(token);
        await _pause(Duration(seconds: 1 << retry), token);
        _throwIfCancelled(token);
      }
    }
  }

  static bool _isTransient(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    DioExceptionType.badResponse => const {
      502,
      503,
      504,
    }.contains(error.response?.statusCode),
    _ => false,
  };

  static void _throwIfCancelled(CancelToken? token) {
    final cancellation = token?.cancelError;
    if (cancellation != null) throw cancellation;
  }

  static Future<void> _wait(Duration delay, CancelToken? token) async {
    final elapsed = Completer<void>();
    final timer = Timer(delay, elapsed.complete);
    try {
      await Future.any<void>([
        elapsed.future,
        if (token != null) token.whenCancel.then<void>((error) => throw error),
      ]);
    } finally {
      timer.cancel();
    }
  }
}

/// Never forward Dio's message, URL, headers or payload to the UI/diagnostics.
DidupFailure transportFailure(DioException error) {
  final cause = error.error;
  if (cause is DidupFailure) return cause;
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const RequestTimeoutFailure(),
    _ => const NetworkFailure(),
  };
}
