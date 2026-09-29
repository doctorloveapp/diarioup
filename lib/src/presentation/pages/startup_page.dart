import 'package:flutter/material.dart';

import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../widgets/brand_mark.dart';

final class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(DiarioUpSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BrandMark(),
                SizedBox(height: DiarioUpSpacing.lg),
                SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                SizedBox(height: DiarioUpSpacing.md),
                Text(AppCopy.restoringSession),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
