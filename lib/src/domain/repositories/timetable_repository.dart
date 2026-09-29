import '../timetable/timetable_entry.dart';

abstract interface class TimetableRepository {
  Stream<List<TimetableEntry>> watch(String profileId);

  Future<void> updateCell({
    required String profileId,
    required String entryId,
    required String subjectName,
    required int subjectColorValue,
  });
}
