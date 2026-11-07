import 'package:diarioup/src/data/auth/oauth_html_navigator.dart';
import 'package:diarioup/src/domain/errors/didup_failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  final config = testProtocolConfig();
  final navigator = OAuthHtmlNavigator(config);
  final page = config.ssoLoginUri.resolve('consent/?consent_challenge=c1');

  test('invia consenso con CSRF, scope ripetuti e solo pulsante Accetta', () {
    final step = navigator.nextStep('''
      <form action="/auth/sso/consent/" method="post">
        <input type="hidden" name="challenge" value="c1">
        <input type="hidden" name="_csrf" value="tok&amp;en">
        <input type="checkbox" name="grant_scope" value="openid" checked>
        <input type="checkbox" name="grant_scope" value="argo">
        <input type="checkbox" name="remember" value="true">
        <input disabled name="disabled" value="bad">
        <fieldset disabled><input name="nested" value="bad"></fieldset>
        <button name="submit" value="deny">Rifiuta</button>
        <button name="submit" value="accept">Accetta</button>
      </form>
    ''', page)!;
    expect(step.method, 'POST');
    expect(step.uri.path, '/auth/sso/consent/');
    final fields = Uri(query: step.body).queryParametersAll;
    expect(fields['challenge'], ['c1']);
    expect(fields['_csrf'], ['tok&en']);
    expect(fields['grant_scope'], ['openid', 'argo']);
    expect(fields['submit'], ['accept']);
    expect(fields.keys, isNot(contains('remember')));
    expect(fields.keys, isNot(contains('disabled')));
    expect(fields.keys, isNot(contains('nested')));
  });

  test('il fallback consenso usa solo scope configurati e endpoint esatto', () {
    final step = navigator.nextStep('<div id="app"></div>', page)!;
    expect(step.method, 'POST');
    expect(step.uri.query, isEmpty);
    final fields = Uri(query: step.body).queryParametersAll;
    expect(fields['grant_scope'], config.oauthScopes);
    expect(fields['consent'], ['Accetta']);
    expect(
      navigator.nextStep(
        '<div id="app"></div>',
        config.oauthAuthorizeUri.replace(
          queryParameters: {'consent_challenge': 'c1'},
        ),
      ),
      isNull,
    );
    expect(
      navigator.nextStep('<div id="app"></div>', page.replace(query: '')),
      isNull,
    );
  });

  test('non invia moduli di login, rifiuti o pagine di manutenzione', () {
    expect(
      () => navigator.nextStep(
        '<form><input type="password" name="password"></form>',
        page,
      ),
      throwsA(isA<AuthenticationFailure>()),
    );
    expect(
      navigator.nextStep(
        '''<form method="post"><input name="challenge" value="c1">
      <button name="submit" value="deny">Rifiuta</button></form>''',
        page,
      ),
      isNull,
    );
    expect(
      navigator.nextStep(
        '<title>Dati personali</title><p>Manutenzione</p>',
        page,
      ),
      isNull,
    );
  });

  test('non autorizza scope ulteriori o form verso host diversi', () {
    for (final markup in [
      '<form action="https://untrusted.invalid/collect"><input name="_csrf" value="private"></form>',
      '<form action="https://auth.portaleargo.it/auth/sso/consent/"><input name="_csrf" value="private"></form>',
      '<form action="javascript:alert(1)"><input name="_csrf" value="private"></form>',
      '<form><input name="grant_scope" value="unexpected_scope"></form>',
    ]) {
      expect(
        () => navigator.nextStep(markup, page),
        throwsA(isA<CompatibilityFailure>()),
      );
    }
  });

  test('riconosce meta refresh, JS letterale e link Continua senza eseguirli', () {
    for (final markup in [
      '<meta http-equiv="refresh" content="0; url=/auth/sso/fine?x=1&amp;y=2">',
      r'''<script>window.location.href = '/auth/sso/fine?x=1\u0026y=2';</script>''',
      '<script>location.replace("/auth/sso/fine?x=1&y=2");</script>',
      '<a href="/auth/sso/fine?x=1&amp;y=2">Continua</a>',
    ]) {
      final step = navigator.nextStep(markup, page)!;
      expect(step.method, 'GET');
      expect(step.uri.path, '/auth/sso/fine');
      expect(step.uri.queryParameters, {'x': '1', 'y': '2'});
    }
    expect(
      navigator.nextStep(
        '<script>location.href = calculateTarget();</script>',
        page,
      ),
      isNull,
    );
  });

  test('blocca destinazioni non autorizzate anche nei redirect HTML', () {
    for (final markup in [
      '<meta http-equiv="refresh" content="0; url=https://untrusted.invalid">',
      '<script>location.href = "https://untrusted.invalid";</script>',
      '<a href="https://untrusted.invalid">Continua</a>',
    ]) {
      expect(
        () => navigator.nextStep(markup, page),
        throwsA(isA<CompatibilityFailure>()),
      );
    }
  });

  test(
    'callback incorporato viene riconosciuto senza GET verso lo schema app',
    () {
      final step = navigator.nextStep(
        '<a href="${config.redirectUri}?code=test-code&amp;state=test-state">Continua</a>',
        page,
      )!;
      expect(step.uri.queryParameters, {
        'code': 'test-code',
        'state': 'test-state',
      });
      expect(config.isRedirectCallback(step.uri), isTrue);
    },
  );
}
