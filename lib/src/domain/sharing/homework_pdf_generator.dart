import 'dart:typed_data';

import '../agenda/homework_agenda_item.dart';
import 'homework_export_selection.dart';

abstract interface class HomeworkPdfGenerator {
  Future<Uint8List> generate({
    required List<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
    required DateTime generatedAt,
  });
}
