import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../routing/app_router.dart';
import 'homework_tile.dart';

final class SubjectsPanel extends ConsumerWidget {
  const SubjectsPanel({required this.profileId, super.key});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsAgendaProvider(profileId));
    final homework = ref.watch(homeworkAgendaProvider(profileId));
    return subjects.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _SubjectsError(
        onRetry: () => ref.invalidate(subjectsAgendaProvider(profileId)),
      ),
      data: (values) => homework.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _SubjectsError(
          onRetry: () => ref.invalidate(homeworkAgendaProvider(profileId)),
        ),
        data: (items) => _SubjectList(
          subjects: values,
          homework: items,
          onChanged: (item, value) =>
              _setCompleted(context, ref, item: item, value: value),
        ),
      ),
    );
  }

  Future<void> _setCompleted(
    BuildContext context,
    WidgetRef ref, {
    required HomeworkAgendaItem item,
    required bool value,
  }) async {
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      await repository.setHomeworkCompleted(
        profileId: profileId,
        homeworkId: item.id,
        isDone: value,
      );
      if (!context.mounted || !value) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: const Text(AppCopy.homeworkCompleted),
          action: SnackBarAction(
            label: AppCopy.undo,
            onPressed: () async {
              await repository.setHomeworkCompleted(
                profileId: profileId,
                homeworkId: item.id,
                isDone: false,
              );
            },
          ),
        ),
      );
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.homework,
        DiagnosticCode.completionUpdateFailed,
      );
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(content: Text(AppCopy.completionUpdateError)),
      );
    }
  }
}

final class _SubjectList extends StatelessWidget {
  const _SubjectList({
    required this.subjects,
    required this.homework,
    required this.onChanged,
  });

  final List<SubjectAgenda> subjects;
  final List<HomeworkAgendaItem> homework;
  final void Function(HomeworkAgendaItem item, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(DiarioUpSpacing.lg),
          child: Text(AppCopy.noSubjects),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          AppCopy.subjects,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.xs),
        Text(
          AppCopy.subjectsBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        for (final subject in subjects) ...<Widget>[
          _SubjectCard(
            subject: subject,
            homework: homework
                .where((item) => item.subjectId == subject.id)
                .toList(growable: false),
            onChanged: onChanged,
          ),
          const SizedBox(height: DiarioUpSpacing.sm),
        ],
      ],
    );
  }
}

final class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.homework,
    required this.onChanged,
  });

  final SubjectAgenda subject;
  final List<HomeworkAgendaItem> homework;
  final void Function(HomeworkAgendaItem item, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    final color = DiarioUpSubjectColors.resolve(
      storedValue: subject.colorValue,
      identity: subject.id,
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.16),
          child: Icon(Icons.menu_book_rounded, color: color),
        ),
        title: Text(subject.name),
        subtitle: Text(
          AppCopy.subjectHomeworkCount(
            pending: subject.pendingHomework,
            total: subject.totalHomework,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          DiarioUpSpacing.sm,
          0,
          DiarioUpSpacing.sm,
          DiarioUpSpacing.sm,
        ),
        children: homework.isEmpty
            ? const <Widget>[
                Padding(
                  padding: EdgeInsets.all(DiarioUpSpacing.md),
                  child: Text(AppCopy.noHomeworkForSubject),
                ),
              ]
            : homework
                  .map(
                    (item) => HomeworkTile(
                      item: item,
                      showSubject: false,
                      onChanged: (value) => onChanged(item, value),
                      onTap: () => context.pushNamed(
                        AppRoutes.homeworkDetailName,
                        pathParameters: <String, String>{'homeworkId': item.id},
                      ),
                    ),
                  )
                  .toList(growable: false),
      ),
    );
  }
}

final class _SubjectsError extends StatelessWidget {
  const _SubjectsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.tonal(
        onPressed: onRetry,
        child: const Text(AppCopy.retry),
      ),
    );
  }
}
