enum AppFlavor { demo, development, production }

final class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.didupOauthClientId,
    required this.didupRedirectUri,
    required this.didupClientVersion,
  });

  factory AppEnvironment.fromDartDefines() {
    const rawFlavor = String.fromEnvironment(
      'DIARIOUP_ENV',
      defaultValue: 'demo',
    );
    final flavor = switch (rawFlavor) {
      'development' => AppFlavor.development,
      'production' => AppFlavor.production,
      _ => AppFlavor.demo,
    };
    return AppEnvironment(
      flavor: flavor,
      didupOauthClientId: const String.fromEnvironment('DIDUP_OAUTH_CLIENT_ID'),
      didupRedirectUri: const String.fromEnvironment('DIDUP_REDIRECT_URI'),
      didupClientVersion: const String.fromEnvironment('DIDUP_CLIENT_VERSION'),
    );
  }

  final AppFlavor flavor;
  final String didupOauthClientId;
  final String didupRedirectUri;
  final String didupClientVersion;

  bool get isDemo => flavor == AppFlavor.demo;

  bool get hasDidupConfiguration =>
      didupOauthClientId.isNotEmpty &&
      didupRedirectUri.isNotEmpty &&
      didupClientVersion.isNotEmpty;
}
