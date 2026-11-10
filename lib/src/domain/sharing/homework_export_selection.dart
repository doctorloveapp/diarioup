import '../agenda/homework_agenda_item.dart';
import '../homework/school_date.dart';

enum HomeworkExportScope { week, nextWeek, day, subject }

final class HomeworkExportSelection {
  const HomeworkExportSelection._({
    required this.scope,
    this.anchorDate,
    this.subjectsById = const <String, String>{},
  });

  factory HomeworkExportSelection.week(SchoolDate anchorDate) =>
      HomeworkExportSelection._(
        scope: HomeworkExportScope.week,
        anchorDate: anchorDate,
      );

  factory HomeworkExportSelection.day(SchoolDate day) =>
      HomeworkExportSelection._(
        scope: HomeworkExportScope.day,
        anchorDate: day,
      );

  factory HomeworkExportSelection.nextWeek(SchoolDate today) {
    // Civil date arithmetic keeps Monday stable across daylight-saving changes.
    final date = today.toLocalDate();
    final monday = DateTime(date.year, date.month, date.day + 8 - date.weekday);
    return HomeworkExportSelection._(
      scope: HomeworkExportScope.nextWeek,
      anchorDate: SchoolDate(monday.year, monday.month, monday.day),
    );
  }

  factory HomeworkExportSelection.subject({
    required String subjectId,
    required String subjectName,
  }) => HomeworkExportSelection.subjects({subjectId: subjectName});

  factory HomeworkExportSelection.subjects(Map<String, String> subjects) {
    if (subjects.isEmpty ||
        subjects.entries.any(
          (entry) => entry.key.trim().isEmpty || entry.value.trim().isEmpty,
        )) {
      throw ArgumentError('Selezionare almeno una materia valida.');
    }
    return HomeworkExportSelection._(
      scope: HomeworkExportScope.subject,
      subjectsById: Map<String, String>.unmodifiable(subjects),
    );
  }

  final HomeworkExportScope scope;
  final SchoolDate? anchorDate;
  final Map<String, String> subjectsById;
  String? get subjectId =>
      subjectsById.length == 1 ? subjectsById.keys.single : null;
  String? get subjectName =>
      subjectsById.length == 1 ? subjectsById.values.single : null;
}

abstract final class HomeworkExportFilter {
  static List<HomeworkAgendaItem> apply({
    required Iterable<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
  }) {
    final filtered = switch (selection.scope) {
      HomeworkExportScope.week ||
      HomeworkExportScope.nextWeek => _forWeek(homework, selection.anchorDate!),
      HomeworkExportScope.day => homework.where(
        (item) => item.dueOn == selection.anchorDate,
      ),
      HomeworkExportScope.subject => homework.where(
        // Subject exports deliberately have no date window, including overdue
        // and undated items. Completion is personal and excluded in this mode.
        (item) =>
            !item.isDone && selection.subjectsById.containsKey(item.subjectId),
      ),
    };
    final result = filtered.toList(growable: false)
      ..sort((first, second) {
        if (selection.scope == HomeworkExportScope.subject) {
          final firstName = selection.subjectsById[first.subjectId]!;
          final secondName = selection.subjectsById[second.subjectId]!;
          final bySubject = firstName.toLowerCase().compareTo(
            secondName.toLowerCase(),
          );
          if (bySubject != 0) return bySubject;
          final byId = first.subjectId!.compareTo(second.subjectId!);
          if (byId != 0) return byId;
        }
        return _compareHomework(first, second);
      });
    return List<HomeworkAgendaItem>.unmodifiable(result);
  }

  static Iterable<HomeworkAgendaItem> _forWeek(
    Iterable<HomeworkAgendaItem> homework,
    SchoolDate anchorDate,
  ) {
    final anchor = anchorDate.toLocalDate();
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return homework.where((item) {
      final dueDate = item.dueOn?.toLocalDate();
      if (dueDate == null) return false;
      return !dueDate.isBefore(monday) && !dueDate.isAfter(sunday);
    });
  }

  static int _compareHomework(
    HomeworkAgendaItem first,
    HomeworkAgendaItem second,
  ) {
    final firstDue = first.dueOn;
    final secondDue = second.dueOn;
    if (firstDue == null && secondDue != null) return 1;
    if (firstDue != null && secondDue == null) return -1;
    if (firstDue != null && secondDue != null) {
      final byDate = firstDue.compareTo(secondDue);
      if (byDate != 0) return byDate;
    }
    final bySubject = (first.subjectName ?? '').toLowerCase().compareTo(
      (second.subjectName ?? '').toLowerCase(),
    );
    return bySubject != 0
        ? bySubject
        : first.text.toLowerCase().compareTo(second.text.toLowerCase());
  }
}
