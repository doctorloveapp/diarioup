import '../agenda/homework_agenda_item.dart';
import '../homework/school_date.dart';

enum HomeworkExportScope { week, day, subject }

final class HomeworkExportSelection {
  const HomeworkExportSelection._({
    required this.scope,
    this.anchorDate,
    this.subjectId,
    this.subjectName,
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

  factory HomeworkExportSelection.subject({
    required String subjectId,
    required String subjectName,
  }) => HomeworkExportSelection._(
    scope: HomeworkExportScope.subject,
    subjectId: subjectId,
    subjectName: subjectName,
  );

  final HomeworkExportScope scope;
  final SchoolDate? anchorDate;
  final String? subjectId;
  final String? subjectName;
}

abstract final class HomeworkExportFilter {
  static List<HomeworkAgendaItem> apply({
    required Iterable<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
  }) {
    final filtered = switch (selection.scope) {
      HomeworkExportScope.week => _forWeek(homework, selection.anchorDate!),
      HomeworkExportScope.day => homework.where(
        (item) => item.dueOn == selection.anchorDate,
      ),
      HomeworkExportScope.subject => homework.where(
        (item) => item.subjectId == selection.subjectId,
      ),
    };
    final result = filtered.toList(growable: false)..sort(_compareHomework);
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
