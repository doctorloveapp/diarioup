import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/homework/homework.dart';
import '../controllers/app_flow_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../formatters/homework_formatters.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';

final class HomeworkDetailPage extends ConsumerStatefulWidget {
  const HomeworkDetailPage({required this.homeworkId, super.key});

  final String homeworkId;

  @override
  ConsumerState<HomeworkDetailPage> createState() => _HomeworkDetailPageState();
}

final class _HomeworkDetailPageState extends ConsumerState<HomeworkDetailPage> {
  final _noteController = TextEditingController();
  String? _loadedHomeworkId;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileId = ref.watch(
      appFlowProvider.select((state) => state.activeProfile?.sourceProfileId),
    );
    if (profileId == null) return const SizedBox.shrink();
    final detail = ref.watch(
      homeworkDetailProvider((
        profileId: profileId,
        homeworkId: widget.homeworkId,
      )),
    );
    final loadedItem = detail.asData?.value;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text(AppCopy.homeworkDetail)),
      bottomNavigationBar: loadedItem == null
          ? null
          : _SaveNoteBar(
              isSaving: _isSaving,
              onSave: () => _saveNote(profileId, loadedItem),
            ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _DetailError(
          onRetry: () => ref.invalidate(
            homeworkDetailProvider((
              profileId: profileId,
              homeworkId: widget.homeworkId,
            )),
          ),
        ),
        data: (item) {
          if (item == null) {
            return const Center(child: Text(AppCopy.homeworkNotAvailable));
          }
          if (_loadedHomeworkId != item.id) {
            _loadedHomeworkId = item.id;
            _noteController.text = item.personalNote ?? '';
          }
          return _DetailContent(
            item: item,
            noteController: _noteController,
            onCompletionChanged: (value) =>
                _setCompleted(profileId, item, value),
          );
        },
      ),
    );
  }

  Future<void> _saveNote(String profileId, HomeworkAgendaItem item) async {
    setState(() => _isSaving = true);
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      await repository.updateHomeworkNote(
        profileId: profileId,
        homeworkId: item.id,
        note: _noteController.text,
      );
      if (!mounted) return;
      _showMessage(AppCopy.noteSaved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.homework,
        DiagnosticCode.noteUpdateFailed,
      );
      if (!mounted) return;
      _showMessage(AppCopy.noteSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _setCompleted(
    String profileId,
    HomeworkAgendaItem item,
    bool value,
  ) async {
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      await repository.setHomeworkCompleted(
        profileId: profileId,
        homeworkId: item.id,
        isDone: value,
      );
      if (!mounted || !value) return;
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
      if (!mounted) return;
      _showMessage(AppCopy.completionUpdateError);
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.item,
    required this.noteController,
    required this.onCompletionChanged,
  });

  final HomeworkAgendaItem item;
  final TextEditingController noteController;
  final ValueChanged<bool> onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final color = DiarioUpSubjectColors.resolve(
      identity: item.subjectId ?? item.subjectName ?? item.id,
    );
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        DiarioUpSpacing.lg,
        DiarioUpSpacing.lg,
        DiarioUpSpacing.lg,
        DiarioUpSpacing.xl,
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                item.subjectName ?? AppCopy.noSubject,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ),
            Chip(label: Text(homeworkCountdown(item.dueOn))),
          ],
        ),
        const SizedBox(height: DiarioUpSpacing.md),
        SelectableText(
          item.text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        Card(
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: item.isDone,
                onChanged: (value) {
                  if (value != null) onCompletionChanged(value);
                },
                title: const Text(AppCopy.completed),
              ),
              const Divider(height: 1),
              _DetailRow(
                icon: Icons.today_outlined,
                label: AppCopy.sourceDate,
                value: formatSchoolDate(item.assignedOn),
              ),
              _DetailRow(
                icon: Icons.event_available_outlined,
                label: AppCopy.dueDate,
                value: formatSchoolDate(item.dueOn),
              ),
              _DetailRow(
                icon: item.origin == HomeworkOrigin.argo
                    ? Icons.cloud_download_outlined
                    : Icons.edit_note_rounded,
                label: AppCopy.origin,
                value: item.origin == HomeworkOrigin.argo
                    ? AppCopy.originArgo
                    : AppCopy.originManual,
              ),
              _DetailRow(
                icon: Icons.update_rounded,
                label: AppCopy.lastUpdate,
                value: _formatTechnicalDate(item.updatedAt),
              ),
            ],
          ),
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        Text(
          AppCopy.personalNote,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: DiarioUpSpacing.xs),
        TextField(
          controller: noteController,
          minLines: 3,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          scrollPadding: const EdgeInsets.only(bottom: 160),
          decoration: const InputDecoration(
            hintText: AppCopy.personalNoteHint,
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

final class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, maxLines: 1),
      subtitle: Text(value),
    );
  }
}

final class _SaveNoteBar extends StatelessWidget {
  const _SaveNoteBar({required this.isSaving, required this.onSave});

  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        DiarioUpSpacing.lg,
        DiarioUpSpacing.sm,
        DiarioUpSpacing.lg,
        DiarioUpSpacing.sm,
      ),
      child: FilledButton.icon(
        onPressed: isSaving ? null : onSave,
        icon: isSaving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: const Text(AppCopy.saveNote),
      ),
    );
  }
}

final class _DetailError extends StatelessWidget {
  const _DetailError({required this.onRetry});

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

String _formatTechnicalDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
