import '../../domain/errors/didup_failure.dart';
import '../l10n/app_copy.dart';

/// Only fixed, local copy is displayed; exception payloads never reach the UI.
String syncFailureMessage(Object? error) => switch (error) {
  SessionExpiredFailure() || AuthenticationFailure() => AppCopy.syncSignInAgain,
  PermissionDeniedFailure() => AppCopy.syncPermissionDenied,
  RequestTimeoutFailure() => AppCopy.loginRequestTimeout,
  NetworkFailure() => AppCopy.loginNetworkUnavailable,
  RateLimitedFailure() => AppCopy.syncRateLimited,
  CompatibilityFailure() => AppCopy.syncCompatibilityError,
  InvalidPayloadFailure() => AppCopy.syncPayloadError,
  _ => AppCopy.syncError,
};

bool syncRequiresAuthentication(Object? error) =>
    error is SessionExpiredFailure || error is AuthenticationFailure;
