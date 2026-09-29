import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/agenda/subject_agenda.dart';
import '../../domain/timetable/timetable_entry.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';

enum _TimetableView { professor, subject }

final class TimetablePage extends ConsumerStatefulWidget {
  const TimetablePage({
    required this.profileId,
    required this.onClose,
    super.key,
  });

  final String profileId;
  final VoidCallback onClose;

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

final class _TimetablePageState extends ConsumerState<TimetablePage> {
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();
  var _view = _TimetableView.professor;

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timetable = ref.watch(timetableProvider(widget.profileId));
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                DiarioUpSpacing.md,
                DiarioUpSpacing.xs,
                DiarioUpSpacing.xs,
                0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppCopy.timetable,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    tooltip: AppCopy.closeTimetable,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DiarioUpSpacing.md,
              DiarioUpSpacing.xs,
              DiarioUpSpacing.md,
              DiarioUpSpacing.md,
            ),
            child: SegmentedButton<_TimetableView>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<_TimetableView>>[
                ButtonSegment<_TimetableView>(
                  value: _TimetableView.professor,
                  icon: Icon(Icons.person_outline_rounded),
                  label: Text(AppCopy.professorView),
                ),
                ButtonSegment<_TimetableView>(
                  value: _TimetableView.subject,
                  icon: Icon(Icons.menu_book_outlined),
                  label: Text(AppCopy.subjectView),
                ),
              ],
              selected: <_TimetableView>{_view},
              onSelectionChanged: (selection) {
                setState(() => _view = selection.single);
              },
            ),
          ),
          Expanded(
            child: timetable.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _TimetableError(
                onRetry: () =>
                    ref.invalidate(timetableProvider(widget.profileId)),
              ),
              data: _buildTable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<TimetableEntry> entries) {
    final byCell = <(SchoolWeekday, int), TimetableEntry>{
      for (final entry in entries) (entry.weekday, entry.period): entry,
    };
    final rowCount = entries.fold<int>(
      6,
      (maximum, entry) => entry.period > maximum ? entry.period : maximum,
    );
    final outline = Theme.of(context).colorScheme.outline;
    return Scrollbar(
      controller: _verticalController,
      child: SingleChildScrollView(
        controller: _verticalController,
        padding: const EdgeInsets.fromLTRB(
          DiarioUpSpacing.md,
          0,
          DiarioUpSpacing.md,
          DiarioUpSpacing.lg,
        ),
        child: Scrollbar(
          controller: _horizontalController,
          notificationPredicate: (notification) => notification.depth == 1,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 764,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
                child: Table(
                  border: TableBorder.all(color: outline),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(64),
                    1: FixedColumnWidth(140),
                    2: FixedColumnWidth(140),
                    3: FixedColumnWidth(140),
                    4: FixedColumnWidth(140),
                    5: FixedColumnWidth(140),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      children: <Widget>[
                        const _HeaderCell(AppCopy.timetableHour),
                        for (final day in SchoolWeekday.values)
                          _HeaderCell(_weekdayLabel(day)),
                      ],
                    ),
                    for (var period = 1; period <= rowCount; period++)
                      TableRow(
                        children: <Widget>[
                          _HourCell(_roman(period)),
                          for (final day in SchoolWeekday.values)
                            _LessonCell(
                              entry: byCell[(day, period)],
                              view: _view,
                              onTap: (entry) => _editEntry(entry),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editEntry(TimetableEntry entry) async {
    List<SubjectAgenda> subjects;
    try {
      subjects = await ref.read(
        subjectsAgendaProvider(widget.profileId).future,
      );
    } on Object {
      subjects = const <SubjectAgenda>[];
    }
    if (!mounted) return;
    final draft = await showDialog<_TimetableCellDraft>(
      context: context,
      builder: (context) =>
          _TimetableCellDialog(entry: entry, subjects: subjects),
    );
    if (draft == null || !mounted) return;
    try {
      final repository = await ref.read(timetableRepositoryProvider.future);
      await repository.updateCell(
        profileId: widget.profileId,
        entryId: entry.id,
        subjectName: draft.subjectName,
        subjectColorValue: draft.colorValue,
      );
      if (mounted) _showMessage(AppCopy.timetableSaved);
    } on Object {
      if (mounted) _showMessage(AppCopy.timetableSaveError);
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(DiarioUpSpacing.sm),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge,
    ),
  );
}

final class _HourCell extends StatelessWidget {
  const _HourCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 76,
    child: Center(
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

final class _LessonCell extends StatelessWidget {
  const _LessonCell({
    required this.entry,
    required this.view,
    required this.onTap,
  });

  final TimetableEntry? entry;
  final _TimetableView view;
  final ValueChanged<TimetableEntry> onTap;

  @override
  Widget build(BuildContext context) {
    final value = entry;
    if (value == null) {
      return const SizedBox(height: 76, child: Center(child: Text('—')));
    }
    final subject = value.subjectName;
    final label = view == _TimetableView.professor
        ? value.professorName
        : subject ?? AppCopy.timetableEmptySubject;
    final color = DiarioUpSubjectColors.resolve(
      storedValue: value.subjectColorValue,
      identity: subject ?? value.professorName,
    );
    return Material(
      color: color.withValues(alpha: subject == null ? 0.05 : 0.16),
      child: InkWell(
        onTap: () => onTap(value),
        child: SizedBox(
          height: 76,
          child: Padding(
            padding: const EdgeInsets.all(DiarioUpSpacing.xs),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _TimetableCellDialog extends StatefulWidget {
  const _TimetableCellDialog({required this.entry, required this.subjects});

  final TimetableEntry entry;
  final List<SubjectAgenda> subjects;

  @override
  State<_TimetableCellDialog> createState() => _TimetableCellDialogState();
}

final class _TimetableCellDialogState extends State<_TimetableCellDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.entry.subjectName);
    _colorValue =
        widget.entry.subjectColorValue ?? DiarioUpColors.indaco.toARGB32();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppCopy.editTimetableCell),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '${_weekdayLabel(widget.entry.weekday)} · ${_roman(widget.entry.period)} ora',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: DiarioUpSpacing.xs),
              Text('${AppCopy.professor}: ${widget.entry.professorName}'),
              const SizedBox(height: DiarioUpSpacing.md),
              TextFormField(
                controller: _subjectController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: AppCopy.subject,
                  hintText: AppCopy.timetableSubjectHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? AppCopy.requiredField
                    : null,
              ),
              if (widget.subjects.isNotEmpty) ...<Widget>[
                const SizedBox(height: DiarioUpSpacing.sm),
                Wrap(
                  spacing: DiarioUpSpacing.xs,
                  runSpacing: DiarioUpSpacing.xs,
                  children: widget.subjects
                      .map(
                        (subject) => ActionChip(
                          label: Text(subject.name),
                          onPressed: () {
                            _subjectController.text = subject.name;
                            if (subject.colorValue case final color?) {
                              setState(() => _colorValue = color);
                            }
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: DiarioUpSpacing.md),
              Text(
                AppCopy.subjectColor,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: DiarioUpSpacing.xs),
              Wrap(
                spacing: DiarioUpSpacing.sm,
                runSpacing: DiarioUpSpacing.sm,
                children: DiarioUpThemeChoices.primary
                    .map((color) {
                      final value = color.toARGB32();
                      final selected = _colorValue == value;
                      return Semantics(
                        button: true,
                        selected: selected,
                        label: AppCopy.subjectColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            DiarioUpSpacing.xl,
                          ),
                          onTap: () => setState(() => _colorValue = value),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.outline,
                                width: selected ? 3 : 1,
                              ),
                            ),
                            child: selected
                                ? Icon(
                                    Icons.check_rounded,
                                    color: color.computeLuminance() > 0.5
                                        ? DiarioUpColors.inchiostro
                                        : DiarioUpColors.superficie,
                                  )
                                : null,
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
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
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              _TimetableCellDraft(
                subjectName: _subjectController.text.trim(),
                colorValue: _colorValue,
              ),
            );
          },
          child: const Text(AppCopy.save),
        ),
      ],
    );
  }
}

final class _TimetableCellDraft {
  const _TimetableCellDraft({
    required this.subjectName,
    required this.colorValue,
  });

  final String subjectName;
  final int colorValue;
}

final class _TimetableError extends StatelessWidget {
  const _TimetableError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline_rounded),
          const SizedBox(height: DiarioUpSpacing.sm),
          const Text(AppCopy.timetableLoadError, textAlign: TextAlign.center),
          const SizedBox(height: DiarioUpSpacing.sm),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(AppCopy.retry),
          ),
        ],
      ),
    ),
  );
}

String _roman(int value) => switch (value) {
  1 => 'I',
  2 => 'II',
  3 => 'III',
  4 => 'IV',
  5 => 'V',
  6 => 'VI',
  7 => 'VII',
  _ => '$value',
};

String _weekdayLabel(SchoolWeekday weekday) => switch (weekday) {
  SchoolWeekday.monday => AppCopy.monday,
  SchoolWeekday.tuesday => AppCopy.tuesday,
  SchoolWeekday.wednesday => AppCopy.wednesday,
  SchoolWeekday.thursday => AppCopy.thursday,
  SchoolWeekday.friday => AppCopy.friday,
};
