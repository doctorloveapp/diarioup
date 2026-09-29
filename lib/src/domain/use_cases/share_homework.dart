import '../homework/school_date.dart';
import '../repositories/didup_repository.dart';
import '../sharing/homework_export_selection.dart';
import '../sharing/homework_file_sharer.dart';
import '../sharing/homework_pdf_generator.dart';

enum HomeworkShareStatus { shared, empty }

final class HomeworkShareResult {
  const HomeworkShareResult({required this.status, required this.itemCount});

  final HomeworkShareStatus status;
  final int itemCount;
}

final class ShareHomework {
  const ShareHomework({
    required DidupRepository repository,
    required HomeworkPdfGenerator pdfGenerator,
    required HomeworkFileSharer fileSharer,
    DateTime Function()? now,
  }) : _repository = repository,
       _pdfGenerator = pdfGenerator,
       _fileSharer = fileSharer,
       _now = now ?? DateTime.now;

  final DidupRepository _repository;
  final HomeworkPdfGenerator _pdfGenerator;
  final HomeworkFileSharer _fileSharer;
  final DateTime Function() _now;

  Future<HomeworkShareResult> call({
    required String profileId,
    required HomeworkExportSelection selection,
    ShareSheetOrigin? origin,
  }) async {
    final allHomework = await _repository
        .watchHomework(profileId: profileId)
        .first;
    final selectedHomework = HomeworkExportFilter.apply(
      homework: allHomework,
      selection: selection,
    );
    if (selectedHomework.isEmpty) {
      return const HomeworkShareResult(
        status: HomeworkShareStatus.empty,
        itemCount: 0,
      );
    }

    final generatedAt = _now();
    final bytes = await _pdfGenerator.generate(
      homework: selectedHomework,
      selection: selection,
      generatedAt: generatedAt,
    );
    await _fileSharer.sharePdf(
      bytes: bytes,
      fileName: _fileName(selection, generatedAt),
      origin: origin,
    );
    return HomeworkShareResult(
      status: HomeworkShareStatus.shared,
      itemCount: selectedHomework.length,
    );
  }

  String _fileName(HomeworkExportSelection selection, DateTime generatedAt) {
    return switch (selection.scope) {
      HomeworkExportScope.week => _weekFileName(selection.anchorDate!),
      HomeworkExportScope.day =>
        'giorno_${_schoolDatePart(selection.anchorDate!)}.pdf',
      HomeworkExportScope.subject =>
        'materia_${_slug(selection.subjectName)}_dal_'
            '${_dateTimePart(generatedAt)}.pdf',
    };
  }

  String _weekFileName(SchoolDate anchorDate) {
    final anchor = anchorDate.toLocalDate();
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return 'settimana_${_dateTimePart(monday)}_a_'
        '${_dateTimePart(sunday)}.pdf';
  }

  String _schoolDatePart(SchoolDate date) =>
      '${_twoDigits(date.day)}_${_twoDigits(date.month)}_${date.year}';

  String _dateTimePart(DateTime date) =>
      '${_twoDigits(date.day)}_${_twoDigits(date.month)}_${date.year}';

  String _slug(String? value) {
    final normalized = (value ?? 'selezionata')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[àáâäãå]'), 'a')
        .replaceAll(RegExp('[èéêë]'), 'e')
        .replaceAll(RegExp('[ìíîï]'), 'i')
        .replaceAll(RegExp('[òóôöõ]'), 'o')
        .replaceAll(RegExp('[ùúûü]'), 'u')
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return normalized.isEmpty ? 'selezionata' : normalized;
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
