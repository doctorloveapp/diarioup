import '../sharing/homework_file_sharer.dart';

abstract interface class UserDataExporter {
  Future<int> exportJson({required String profileId, ShareSheetOrigin? origin});
}
