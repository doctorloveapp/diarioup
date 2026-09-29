import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckForAppUpdate', () {
    test(
      'restituisce la release solo quando la versione è più recente',
      () async {
        final release = AppRelease(
          version: 'v1.5.0',
          releasePage: Uri.parse(
            'https://github.com/doctorloveapp/diarioup/releases/tag/v1.5.0',
          ),
        );
        final checker = CheckForAppUpdate(_ReleaseRepository(release));

        expect(await checker(installedVersion: '1.4.0+7'), same(release));
        expect(await checker(installedVersion: '1.5.0+8'), isNull);
      },
    );

    test('confronta correttamente tag con prefisso v e build metadata', () {
      expect(isNewerVersion('v1.4.1', '1.4.0+7'), isTrue);
      expect(isNewerVersion('v2.0.0', '1.99.99'), isTrue);
      expect(isNewerVersion('v1.3.9', '1.4.0'), isFalse);
      expect(isNewerVersion('release-candidate', '1.4.0'), isFalse);
    });
  });
}

final class _ReleaseRepository implements AppReleaseRepository {
  const _ReleaseRepository(this.release);

  final AppRelease release;

  @override
  Future<AppRelease> fetchLatest() async => release;
}
