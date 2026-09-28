sealed class DidupFailure implements Exception {
  const DidupFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class AuthenticationFailure extends DidupFailure {
  const AuthenticationFailure([super.message = 'Accesso non riuscito.']);
}

final class SessionExpiredFailure extends DidupFailure {
  const SessionExpiredFailure([
    super.message = 'La sessione e scaduta. Accedi di nuovo.',
  ]);
}

final class PermissionDeniedFailure extends DidupFailure {
  const PermissionDeniedFailure([
    super.message = 'Il profilo non consente questa operazione.',
  ]);
}

final class RateLimitedFailure extends DidupFailure {
  const RateLimitedFailure({this.retryAfter, String? message})
    : super(message ?? 'Troppe richieste. Riprova piu tardi.');

  final Duration? retryAfter;
}

final class CompatibilityFailure extends DidupFailure {
  const CompatibilityFailure([
    super.message = 'Il collegamento DidUP richiede una verifica tecnica.',
  ]);
}

final class NetworkFailure extends DidupFailure {
  const NetworkFailure([super.message = 'Rete non disponibile.']);
}

final class InvalidPayloadFailure extends DidupFailure {
  const InvalidPayloadFailure([
    super.message = 'La risposta DidUP non ha il formato atteso.',
  ]);
}
