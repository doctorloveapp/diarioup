import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../../domain/errors/didup_failure.dart';
import '../protocol/didup_protocol_config.dart';

final class OAuthPageStep {
  const OAuthPageStep({required this.uri, this.method = 'GET', this.body});

  final Uri uri;
  final String method;
  final String? body;
}

/// Interprets known SSO pages without executing scripts or fetching resources.
/// Only the configured consent endpoint can submit a form or grant scopes.
final class OAuthHtmlNavigator {
  const OAuthHtmlNavigator(this.config);

  final DidupProtocolConfig config;

  OAuthPageStep? nextStep(String source, Uri page) {
    if (!config.isTrustedNetworkUri(page) || source.length > 1024 * 1024) {
      throw const CompatibilityFailure('Pagina OAuth non supportata.');
    }
    final document = html.parse(source);
    final decoded = _decodeUrl(source);
    final callback = RegExp(
      RegExp.escape(config.redirectUri.toString()) + r'''\?[^\s"'<>`\\]+''',
    ).firstMatch(decoded);
    if (callback != null) return _get(page, callback.group(0)!);

    for (final meta in document.querySelectorAll('meta[http-equiv]')) {
      if (meta.attributes['http-equiv']?.toLowerCase() != 'refresh') continue;
      final match = RegExp(
        r'''url\s*=\s*["']?([^"';]+)''',
        caseSensitive: false,
      ).firstMatch(meta.attributes['content'] ?? '');
      if (match != null) return _get(page, match.group(1)!.trim());
    }
    for (final script in document.querySelectorAll('script')) {
      // Read literal destinations only. Never evaluate JavaScript expressions.
      final match = RegExp(
        r'''\blocation(?:\.href)?\s*=\s*["'`]([^"'`]+)["'`]|'''
        r'''\blocation\.(?:replace|assign)\(\s*["'`]([^"'`]+)["'`]''',
      ).firstMatch(script.text);
      if (match != null) {
        return _get(page, _decodeUrl(match.group(1) ?? match.group(2)!));
      }
    }

    final forms = document.querySelectorAll('form');
    final hasPassword = document
        .querySelectorAll('input')
        .any((input) => input.attributes['type']?.toLowerCase() == 'password');
    if (hasPassword) {
      throw const AuthenticationFailure('Argo richiede un nuovo accesso.');
    }
    if (_isConsentPage(page)) {
      for (final form in forms) {
        final step = _consentForm(form, page);
        if (step != null) return step;
      }
    }
    for (final link in document.querySelectorAll('a[href]')) {
      if (_forward.hasMatch(link.text)) {
        return _get(page, link.attributes['href']!);
      }
    }

    // The portal may render consent through an empty app mount instead of a
    // form. Only use the observed fallback at the exact consent endpoint.
    final challenge = page.queryParameters['consent_challenge'];
    final appMount = document.querySelector('#app');
    if (_isConsentPage(page) &&
        forms.isEmpty &&
        appMount != null &&
        challenge != null &&
        challenge.isNotEmpty) {
      return OAuthPageStep(
        uri: page.replace(query: '', fragment: ''),
        method: 'POST',
        body: _encode([
          MapEntry('challenge', challenge),
          for (final scope in config.oauthScopes)
            MapEntry('grant_scope', scope),
          const MapEntry('consent', 'Accetta'),
        ]),
      );
    }
    return null;
  }

  OAuthPageStep? _consentForm(Element form, Uri page) {
    final action = page.resolve(form.attributes['action'] ?? '');
    if (!config.isTrustedNetworkUri(action) ||
        action.origin != page.origin ||
        !_isConsentPage(action)) {
      throw const CompatibilityFailure(
        'Destinazione consenso OAuth non ammessa.',
      );
    }
    final method = (form.attributes['method'] ?? 'get').toUpperCase();
    if (method != 'POST' && method != 'GET') {
      throw const CompatibilityFailure('Metodo consenso OAuth non supportato.');
    }
    final fields = <MapEntry<String, String>>[];
    final buttons = <Element>[];
    for (final input in form.querySelectorAll('input, button')) {
      if (_disabled(input)) {
        continue;
      }
      final name = input.attributes['name'] ?? '';
      final type =
          (input.attributes['type'] ??
                  (input.localName == 'button' ? 'submit' : 'text'))
              .toLowerCase();
      final value = input.attributes['value'] ?? '';
      if (type == 'submit') {
        buttons.add(input);
        continue;
      }
      if (name.isEmpty ||
          const {'button', 'reset', 'file', 'image'}.contains(type)) {
        continue;
      }
      final isScope = const {
        'grant_scope',
        'grant_scope[]',
        'scope',
        'scopes',
      }.contains(name);
      if (isScope) {
        final scopes = value
            .split(RegExp(r'\s+'))
            .where((value) => value.isNotEmpty);
        if (scopes.isEmpty ||
            scopes.any((scope) => !config.oauthScopes.contains(scope))) {
          throw const CompatibilityFailure('Scope OAuth non richiesto.');
        }
      }
      if ((type == 'checkbox' || type == 'radio') &&
          !isScope &&
          !input.attributes.containsKey('checked')) {
        continue;
      }
      fields.add(
        MapEntry(
          name,
          value.isEmpty && (type == 'checkbox' || type == 'radio')
              ? 'on'
              : value,
        ),
      );
    }
    Element? selected;
    for (final button in buttons) {
      final label =
          '${button.attributes['name'] ?? ''} ${button.attributes['value'] ?? ''} ${button.text}';
      if (!_negative.hasMatch(label) && _positive.hasMatch(label)) {
        selected = button;
        break;
      }
    }
    if (buttons.isNotEmpty && selected == null) return null;
    if (selected != null && (selected.attributes['name'] ?? '').isNotEmpty) {
      fields.add(
        MapEntry(
          selected.attributes['name']!,
          selected.attributes['value'] ?? '',
        ),
      );
    }
    if (fields.isEmpty) return null;
    final body = _encode(fields);
    if (method == 'POST') {
      return OAuthPageStep(uri: action, method: method, body: body);
    }
    return OAuthPageStep(
      uri: action.replace(
        query: [if (action.query.isNotEmpty) action.query, body].join('&'),
      ),
    );
  }

  bool _isConsentPage(Uri uri) {
    final endpoint = config.ssoLoginUri.resolve('consent/');
    return uri.origin == endpoint.origin &&
        uri.path.replaceFirst(RegExp(r'/$'), '') ==
            endpoint.path.replaceFirst(RegExp(r'/$'), '');
  }

  bool _disabled(Element input) {
    if (input.attributes.containsKey('disabled')) return true;
    for (var parent = input.parent; parent != null; parent = parent.parent) {
      if (parent.localName == 'fieldset' &&
          parent.attributes.containsKey('disabled')) {
        return true;
      }
    }
    return false;
  }

  OAuthPageStep _get(Uri page, String destination) {
    final uri = page.resolve(destination.trim());
    if (!config.isRedirectCallback(uri) && !config.isTrustedNetworkUri(uri)) {
      throw const CompatibilityFailure(
        'Destinazione pagina OAuth non ammessa.',
      );
    }
    return OAuthPageStep(uri: uri);
  }

  static final _negative = RegExp(
    r'rifiut|nega|deny|reject|annull|cancel|indietro',
    caseSensitive: false,
  );
  static final _positive = RegExp(
    r'accett|accept|consent|autoriz|approve|continu|prosegui|avanti',
    caseSensitive: false,
  );
  static final _forward = RegExp(
    r'continu|prosegui|avanti|apri|accedi all',
    caseSensitive: false,
  );

  static String _decodeUrl(String value) => value
      .replaceAll('&amp;', '&')
      .replaceAll(r'\/', '/')
      .replaceAll(r'\u0026', '&')
      .replaceAll(r'\u003d', '=')
      .replaceAll(r'\x26', '&');

  static String _encode(List<MapEntry<String, String>> fields) => fields
      .map(
        (field) =>
            '${Uri.encodeQueryComponent(field.key)}=${Uri.encodeQueryComponent(field.value)}',
      )
      .join('&');
}
