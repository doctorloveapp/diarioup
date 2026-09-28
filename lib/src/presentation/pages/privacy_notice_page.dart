import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';

final class PrivacyNoticePage extends StatelessWidget {
  const PrivacyNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppCopy.privacyNotice)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/privacy/informativa_privacy.txt'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text(AppCopy.diagnosticsLoadError));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(DiarioUpSpacing.lg),
            child: SelectableText(
              snapshot.data!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          );
        },
      ),
    );
  }
}
