import 'package:flutter/material.dart';

import '../../domain/agenda/subject_agenda.dart';
import '../../domain/homework/school_date.dart';
import '../design_system/diarioup_tokens.dart';
import '../formatters/homework_formatters.dart';
import '../l10n/app_copy.dart';

final class ManualHomeworkDraft {
  const ManualHomeworkDraft({
    required this.text,
    this.subjectId,
    this.dueOn,
    this.note,
  });

  final String text;
  final String? subjectId;
  final SchoolDate? dueOn;
  final String? note;
}

final class ManualSubjectDraft {
  const ManualSubjectDraft({required this.name, required this.colorValue});

  final String name;
  final int colorValue;
}

Future<ManualHomeworkDraft?> showManualHomeworkDialog(
  BuildContext context, {
  required List<SubjectAgenda> subjects,
}) => showDialog<ManualHomeworkDraft>(
  context: context,
  builder: (context) => _ManualHomeworkDialog(subjects: subjects),
);

Future<ManualSubjectDraft?> showManualSubjectDialog(BuildContext context) =>
    showDialog<ManualSubjectDraft>(
      context: context,
      builder: (context) => const _ManualSubjectDialog(),
    );

final class _ManualHomeworkDialog extends StatefulWidget {
  const _ManualHomeworkDialog({required this.subjects});

  final List<SubjectAgenda> subjects;

  @override
  State<_ManualHomeworkDialog> createState() => _ManualHomeworkDialogState();
}

final class _ManualHomeworkDialogState extends State<_ManualHomeworkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _noteController = TextEditingController();
  String? _subjectId;
  SchoolDate? _dueOn;

  @override
  void dispose() {
    _textController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueOn?.toLocalDate() ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _dueOn = SchoolDate(selected.year, selected.month, selected.day);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ManualHomeworkDraft(
        text: _textController.text.trim(),
        subjectId: _subjectId,
        dueOn: _dueOn,
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppCopy.newHomework),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _textController,
                autofocus: true,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: AppCopy.homeworkText,
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? AppCopy.requiredField
                    : null,
              ),
              const SizedBox(height: DiarioUpSpacing.md),
              DropdownButtonFormField<String?>(
                initialValue: _subjectId,
                decoration: const InputDecoration(labelText: AppCopy.subject),
                items: <DropdownMenuItem<String?>>[
                  const DropdownMenuItem<String?>(
                    child: Text(AppCopy.noSubject),
                  ),
                  ...widget.subjects.map(
                    (subject) => DropdownMenuItem<String?>(
                      value: subject.id,
                      child: Text(subject.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _subjectId = value),
              ),
              const SizedBox(height: DiarioUpSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: const Text(AppCopy.dueDate),
                subtitle: Text(formatSchoolDate(_dueOn)),
                trailing: _dueOn == null
                    ? null
                    : IconButton(
                        tooltip: AppCopy.removeDueDate,
                        onPressed: () => setState(() => _dueOn = null),
                        icon: const Icon(Icons.close_rounded),
                      ),
                onTap: _pickDueDate,
              ),
              const SizedBox(height: DiarioUpSpacing.sm),
              TextFormField(
                controller: _noteController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: AppCopy.personalNoteOptional,
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppCopy.cancel),
        ),
        FilledButton(onPressed: _submit, child: const Text(AppCopy.save)),
      ],
    );
  }
}

final class _ManualSubjectDialog extends StatefulWidget {
  const _ManualSubjectDialog();

  @override
  State<_ManualSubjectDialog> createState() => _ManualSubjectDialogState();
}

final class _ManualSubjectDialogState extends State<_ManualSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _colorIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ManualSubjectDraft(
        name: _nameController.text.trim(),
        colorValue: DiarioUpSubjectColors.palette[_colorIndex].toARGB32(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppCopy.newSubject),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: AppCopy.subjectName),
              validator: (value) => value == null || value.trim().isEmpty
                  ? AppCopy.requiredField
                  : null,
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            Text(
              AppCopy.subjectColor,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: DiarioUpSpacing.xs),
            Wrap(
              spacing: DiarioUpSpacing.xs,
              children: <Widget>[
                for (
                  var index = 0;
                  index < DiarioUpSubjectColors.palette.length;
                  index++
                )
                  Semantics(
                    label: '${AppCopy.subjectColor} ${index + 1}',
                    selected: index == _colorIndex,
                    child: IconButton.filledTonal(
                      onPressed: () => setState(() => _colorIndex = index),
                      style: IconButton.styleFrom(
                        backgroundColor: DiarioUpSubjectColors.palette[index]
                            .withValues(alpha: 0.18),
                        foregroundColor: DiarioUpSubjectColors.palette[index],
                      ),
                      icon: Icon(
                        index == _colorIndex
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppCopy.cancel),
        ),
        FilledButton(onPressed: _submit, child: const Text(AppCopy.save)),
      ],
    );
  }
}
