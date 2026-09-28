final class AuthCredentials {
  AuthCredentials({
    required String schoolCode,
    required String username,
    required this.password,
  }) : schoolCode = schoolCode.trim(),
       username = username.trim() {
    if (this.schoolCode.isEmpty || this.username.isEmpty || password.isEmpty) {
      throw ArgumentError('I campi di accesso obbligatori non sono completi.');
    }
  }

  final String schoolCode;
  final String username;

  /// Usata esclusivamente durante il login interattivo e mai serializzata.
  final String password;

  @override
  String toString() => 'AuthCredentials(<redacted>)';
}
