import 'package:flutter/material.dart';

import '../design_system/diarioup_tokens.dart';

final class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    super.key,
    this.maxWidth = 560,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(DiarioUpSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
