import '../release/app_release.dart';
import '../repositories/app_release_repository.dart';

final class CheckForAppUpdate {
  const CheckForAppUpdate(this._repository);

  final AppReleaseRepository _repository;

  Future<AppRelease?> call({required String installedVersion}) async {
    final release = await _repository.fetchLatest();
    return isNewerVersion(release.version, installedVersion) ? release : null;
  }
}

bool isNewerVersion(String candidate, String installed) {
  final candidateParts = _versionParts(candidate);
  final installedParts = _versionParts(installed);
  if (candidateParts == null || installedParts == null) return false;
  final length = candidateParts.length > installedParts.length
      ? candidateParts.length
      : installedParts.length;
  for (var index = 0; index < length; index++) {
    final candidateValue = index < candidateParts.length
        ? candidateParts[index]
        : 0;
    final installedValue = index < installedParts.length
        ? installedParts[index]
        : 0;
    if (candidateValue != installedValue) {
      return candidateValue > installedValue;
    }
  }
  return false;
}

List<int>? _versionParts(String raw) {
  final normalized = raw.trim().toLowerCase();
  final versionMatch = RegExp(
    r'(?:^|ver|v)(\d+(?:\.\d+)+)',
  ).firstMatch(normalized);
  final fallbackMatch = RegExp(r'(\d+(?:\.\d+)+)').firstMatch(normalized);
  final value = (versionMatch ?? fallbackMatch)?.group(1);
  if (value == null) return null;
  final segments = value.split('.');
  if (segments.isEmpty) return null;
  final parsed = <int>[];
  for (final segment in segments) {
    final number = int.tryParse(segment);
    if (number == null || number < 0) return null;
    parsed.add(number);
  }
  return parsed;
}
