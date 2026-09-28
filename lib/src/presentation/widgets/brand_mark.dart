import 'package:flutter/material.dart';

import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';

final class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final imageSize = compact ? 40.0 : 96.0;
    return Semantics(
      label: AppCopy.appName,
      image: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/logo_diarioup.png',
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          if (compact) ...<Widget>[
            const SizedBox(width: DiarioUpSpacing.xs),
            Text(
              AppCopy.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ],
      ),
    );
  }
}
