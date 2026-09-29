import 'package:flutter/material.dart';

import '../../domain/agenda/subject_agenda.dart';
import '../../domain/homework/school_date.dart';
import '../../domain/sharing/homework_export_selection.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';

Future<HomeworkExportSelection?> showHomeworkShareSheet(
  BuildContext context, {
  required List<SubjectAgenda> subjects,
  DateTime? today,
}) {
  final currentDate = today ?? DateTime.now();
  return showModalBottomSheet<HomeworkExportSelection>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _HomeworkShareSheet(
      subjects: subjects,
      today: DateTime(currentDate.year, currentDate.month, currentDate.day),
    ),
  );
}

final class _HomeworkShareSheet extends StatefulWidget {
  const _HomeworkShareSheet({required this.subjects, required this.today});

  final List<SubjectAgenda> subjects;
  final DateTime today;

  @override
  State<_HomeworkShareSheet> createState() => _HomeworkShareSheetState();
}

final class _HomeworkShareSheetState extends State<_HomeworkShareSheet> {
  HomeworkExportScope _scope = HomeworkExportScope.week;
  late DateTime _selectedDay = widget.today;
  String? _selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return FractionallySizedBox(
      heightFactor: 0.78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DiarioUpSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  AppCopy.shareHomework,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: DiarioUpSpacing.xs),
                Text(
                  AppCopy.shareHomeworkBody,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: DiarioUpSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: DiarioUpSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButtonFormField<HomeworkExportScope>(
                    initialValue: _scope,
                    decoration: const InputDecoration(
                      labelText: AppCopy.exportScope,
                      prefixIcon: Icon(Icons.tune_rounded),
                    ),
                    isExpanded: true,
                    items: const <DropdownMenuItem<HomeworkExportScope>>[
                      DropdownMenuItem<HomeworkExportScope>(
                        value: HomeworkExportScope.week,
                        child: Text(AppCopy.exportWeek),
                      ),
                      DropdownMenuItem<HomeworkExportScope>(
                        value: HomeworkExportScope.day,
                        child: Text(AppCopy.exportDay),
                      ),
                      DropdownMenuItem<HomeworkExportScope>(
                        value: HomeworkExportScope.subject,
                        child: Text(AppCopy.exportSubject),
                      ),
                    ],
                    onChanged: (scope) {
                      if (scope != null) setState(() => _scope = scope);
                    },
                  ),
                  const SizedBox(height: DiarioUpSpacing.md),
                  switch (_scope) {
                    HomeworkExportScope.week => _WeekSummary(
                      today: widget.today,
                    ),
                    HomeworkExportScope.day => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_rounded),
                      title: const Text(AppCopy.selectDay),
                      subtitle: Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatMediumDate(_selectedDay),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _pickDay,
                    ),
                    HomeworkExportScope.subject =>
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSubjectId,
                        decoration: const InputDecoration(
                          labelText: AppCopy.selectSubject,
                          prefixIcon: Icon(Icons.menu_book_rounded),
                        ),
                        isExpanded: true,
                        items: widget.subjects
                            .map(
                              (subject) => DropdownMenuItem<String>(
                                value: subject.id,
                                child: Text(
                                  subject.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (subjectId) {
                          setState(() => _selectedSubjectId = subjectId);
                        },
                      ),
                  },
                  const SizedBox(height: DiarioUpSpacing.md),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(DiarioUpSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.privacy_tip_outlined,
                            color: primary,
                            size: 20,
                          ),
                          const SizedBox(width: DiarioUpSpacing.xs),
                          const Expanded(child: Text(AppCopy.exportPrivacy)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: DiarioUpSpacing.md),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: theme.colorScheme.outline)),
            ),
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(
                DiarioUpSpacing.lg,
                DiarioUpSpacing.sm,
                DiarioUpSpacing.lg,
                DiarioUpSpacing.md,
              ),
              child: FilledButton.icon(
                onPressed: _canSubmit ? _submit : null,
                icon: const Icon(Icons.ios_share_rounded),
                label: const Text(AppCopy.sharePdf),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _canSubmit =>
      _scope != HomeworkExportScope.subject || _selectedSubjectId != null;

  Future<void> _pickDay() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(widget.today.year - 2),
      lastDate: DateTime(widget.today.year + 3, 12, 31),
    );
    if (selected != null && mounted) {
      setState(() => _selectedDay = selected);
    }
  }

  void _submit() {
    final schoolDate = SchoolDate(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final selection = switch (_scope) {
      HomeworkExportScope.week => HomeworkExportSelection.week(schoolDate),
      HomeworkExportScope.day => HomeworkExportSelection.day(schoolDate),
      HomeworkExportScope.subject => _subjectSelection(),
    };
    Navigator.of(context).pop(selection);
  }

  HomeworkExportSelection _subjectSelection() {
    final subject = widget.subjects.singleWhere(
      (item) => item.id == _selectedSubjectId,
    );
    return HomeworkExportSelection.subject(
      subjectId: subject.id,
      subjectName: subject.name,
    );
  }
}

final class _WeekSummary extends StatelessWidget {
  const _WeekSummary({required this.today});

  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final localizations = MaterialLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.date_range_rounded),
      title: const Text(AppCopy.exportWeekHint),
      subtitle: Text(
        '${localizations.formatMediumDate(monday)} - '
        '${localizations.formatMediumDate(sunday)}',
      ),
    );
  }
}
