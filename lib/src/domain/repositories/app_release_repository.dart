import '../release/app_release.dart';

abstract interface class AppReleaseRepository {
  Future<AppRelease> fetchLatest();
}
