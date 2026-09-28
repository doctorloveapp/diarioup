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
      fileName: _fileName(generatedAt),
      origin: origin,
    );
    return HomeworkShareResult(
      status: HomeworkShareStatus.shared,
      itemCount: selectedHomework.length,
    );
  }

  String _fileName(DateTime generatedAt) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return 'DiarioUp-compiti-'
        '${generatedAt.year}${twoDigits(generatedAt.month)}'
        '${twoDigits(generatedAt.day)}-'
        '${twoDigits(generatedAt.hour)}${twoDigits(generatedAt.minute)}.pdf';
  }
}
