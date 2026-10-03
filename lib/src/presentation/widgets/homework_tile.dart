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
    final theme = Theme.of(context);
    final color = DiarioUpSubjectColors.resolve(
      identity: item.subjectId ?? item.subjectName ?? item.id,
    );
    final subjectLabel = item.subjectName?.trim();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            ColoredBox(color: color, child: const SizedBox(width: 4)),
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DiarioUpSpacing.xs,
                    DiarioUpSpacing.sm,
                    DiarioUpSpacing.xs,
                    DiarioUpSpacing.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: item.isDone,
                        onChanged: (value) {
                          if (value != null) onChanged(value);
                        },
                      ),
                      const SizedBox(width: DiarioUpSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (showSubject) ...<Widget>[
                              _SubjectBadge(
                                label:
                                    subjectLabel == null || subjectLabel.isEmpty
                                    ? AppCopy.noSubject
                                    : subjectLabel,
                                color: color,
                              ),
                              const SizedBox(height: DiarioUpSpacing.xs),
                            ],
                            Text(
                              item.text,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.3,
                                decoration: item.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: DiarioUpSpacing.xs),
                            Wrap(
                              spacing: DiarioUpSpacing.sm,
                              runSpacing: DiarioUpSpacing.xxs,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                _MetadataLabel(
                                  icon: Icons.schedule_rounded,
                                  label: homeworkCountdown(item.dueOn),
                                ),
                                if (item.changedAfterCompletion)
                                  const _MetadataLabel(
                                    icon: Icons.update_rounded,
                                    label: AppCopy.changedAfterCompletion,
                                  ),
                                if (item.requiresIdentityReview)
                                  const _MetadataLabel(
                                    icon: Icons.flag_outlined,
                                    label: AppCopy.identityReview,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: DiarioUpSpacing.xs),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SubjectBadge extends StatelessWidget {
  const _SubjectBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DiarioUpSpacing.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DiarioUpSpacing.xs,
          vertical: DiarioUpSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.menu_book_rounded, color: color, size: 16),
            const SizedBox(width: DiarioUpSpacing.xxs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _MetadataLabel extends StatelessWidget {
  const _MetadataLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: color),
        const SizedBox(width: DiarioUpSpacing.xxs),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
