import '../../domain/errors/didup_failure.dart';

final class DidupProtocolConfig {
  DidupProtocolConfig({
    required this.oauthClientId,
    required this.redirectUri,
    required this.clientVersion,
    Uri? apiBaseUri,
    Uri? oauthAuthorizeUri,
    Uri? oauthTokenUri,
    Uri? ssoLoginUri,
    this.oauthScopes = const <String>[
      'openid',
      'offline',
      'profile',
      'user.roles',
      'argo',
    ],
    this.appRefreshProcedure = 'initState_global_random_12345',
    this.refreshLeeway = const Duration(seconds: 90),
  }) : apiBaseUri =
           apiBaseUri ??
           Uri.parse('https://www.portaleargo.it/appfamiglia/api/rest/'),
       oauthAuthorizeUri =
           oauthAuthorizeUri ??
           Uri.parse('https://auth.portaleargo.it/oauth2/auth'),
       oauthTokenUri =
           oauthTokenUri ??
           Uri.parse('https://auth.portaleargo.it/oauth2/token'),
       ssoLoginUri =
           ssoLoginUri ??
           Uri.parse('https://www.portaleargo.it/auth/sso/login') {
    if (oauthClientId.trim().isEmpty || clientVersion.trim().isEmpty) {
      throw const CompatibilityFailure(
        'Client OAuth e versione devono provenire da una configurazione verificata.',
      );
    }
    if (!redirectUri.hasScheme || oauthScopes.isEmpty) {
      throw const CompatibilityFailure('Configurazione OAuth incompleta.');
    }
    for (final uri in <Uri>[
      this.apiBaseUri,
      this.oauthAuthorizeUri,
      this.oauthTokenUri,
      this.ssoLoginUri,
    ]) {
      if (uri.scheme != 'https' || uri.host.isEmpty) {
        throw const CompatibilityFailure(
          'Gli endpoint DidUP devono usare HTTPS e un host esplicito.',
        );
      }
    }
  }

  final Uri apiBaseUri;
  final Uri oauthAuthorizeUri;
  final Uri oauthTokenUri;
  final Uri ssoLoginUri;

  /// Deve appartenere a DiarioUp o essere autorizzato esplicitamente da Argo.
  final String oauthClientId;
  final Uri redirectUri;

  /// Valore verificato nel gate di compatibilita, mai auto-inventato.
  final String clientVersion;
  final List<String> oauthScopes;
  final String appRefreshProcedure;
  final Duration refreshLeeway;

  Set<String> get trustedHosts => <String>{
    apiBaseUri.host.toLowerCase(),
    oauthAuthorizeUri.host.toLowerCase(),
    oauthTokenUri.host.toLowerCase(),
    ssoLoginUri.host.toLowerCase(),
  };

  Uri apiUri(String relativePath) => apiBaseUri.resolve(relativePath);

  bool isTrustedNetworkUri(Uri uri) =>
      uri.scheme == 'https' && trustedHosts.contains(uri.host.toLowerCase());

  bool isRedirectCallback(Uri uri) =>
      uri.scheme == redirectUri.scheme &&
      uri.host == redirectUri.host &&
      uri.path == redirectUri.path;
}
