import 'package:flutter/material.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../design_system/diarioup_tokens.dart';
import '../formatters/homework_formatters.dart';
import '../l10n/app_copy.dart';

final class HomeworkTile extends StatelessWidget {
  const HomeworkTile({
    required this.item,
    required this.onChanged,
    required this.onTap,
    this.showSubject = true,
    super.key,
  });

  final HomeworkAgendaItem item;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final bool showSubject;

  @override
  Widget build(BuildContext context) {
    final color = DiarioUpSubjectColors.resolve(
      identity: item.subjectId ?? item.subjectName ?? item.id,
    );
    final subjectLabel = showSubject ? item.subjectName : null;
    final metadata = <String>[
      ?subjectLabel,
      homeworkCountdown(item.dueOn),
      if (item.changedAfterCompletion) AppCopy.changedAfterCompletion,
      if (item.requiresIdentityReview) AppCopy.identityReview,
    ];
    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            ColoredBox(color: color, child: const SizedBox(width: 4)),
            Expanded(
              child: ListTile(
                leading: Checkbox(
                  value: item.isDone,
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                  },
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                title: Text(
                  item.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: item.isDone
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                subtitle: Text(metadata.join(' · ')),
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
