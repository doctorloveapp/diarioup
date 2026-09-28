import 'package:flutter/material.dart';

import '../design_system/diarioup_tokens.dart';

final class InfoRow extends StatelessWidget {
  const InfoRow({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 24,
          color: DiarioUpColors.verdePetrolio,
          semanticLabel: null,
        ),
        const SizedBox(width: DiarioUpSpacing.sm),
        Expanded(child: Text(text)),
      ],
    );
  }
}
