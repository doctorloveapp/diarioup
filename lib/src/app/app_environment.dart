final class AppEnvironment {
  const AppEnvironment({
    required this.didupOauthClientId,
    required this.didupRedirectUri,
    required this.didupClientVersion,
  });

  factory AppEnvironment.fromDartDefines() => const AppEnvironment(
    didupOauthClientId: String.fromEnvironment('DIDUP_OAUTH_CLIENT_ID'),
    didupRedirectUri: String.fromEnvironment('DIDUP_REDIRECT_URI'),
    didupClientVersion: String.fromEnvironment('DIDUP_CLIENT_VERSION'),
  );

  final String didupOauthClientId;
  final String didupRedirectUri;
  final String didupClientVersion;

  bool get hasDidupConfiguration =>
      didupOauthClientId.isNotEmpty &&
      didupRedirectUri.isNotEmpty &&
      didupClientVersion.isNotEmpty;
}
