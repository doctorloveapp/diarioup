import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/pages/info_privacy_page.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mostra il repository subito sotto la versione', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appVersionProvider.overrideWith((ref) async => '1.4.3+10'),
          recentDiagnosticsProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
        ],
        child: const MaterialApp(home: InfoPrivacyPage(profileId: 'profile-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppCopy.appVersion), findsOneWidget);
    expect(find.text(AppCopy.sourceRepository), findsOneWidget);
    expect(find.text(AppCopy.privacyNotice), findsOneWidget);
    expect(
      tester.getTopLeft(find.text(AppCopy.appVersion)).dy,
      lessThan(tester.getTopLeft(find.text(AppCopy.sourceRepository)).dy),
    );
    expect(
      tester.getTopLeft(find.text(AppCopy.sourceRepository)).dy,
      lessThan(tester.getTopLeft(find.text(AppCopy.privacyNotice)).dy),
    );
  });
}
