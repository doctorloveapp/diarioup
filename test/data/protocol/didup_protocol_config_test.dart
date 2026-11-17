import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accetta solo versioni numeriche adatte agli header HTTP', () {
    for (final version in ['1.30', '1.30.3', '1.30.3.1']) {
      expect(DidupProtocolConfig.isValidClientVersion(version), isTrue);
    }
    for (final version in [
      '',
      'latest',
      '1',
      'v1.30.3',
      '1.30.3\r\nx-test: 1',
      '1.30.3\n',
      '1.30.3 ',
      '1.2.3.4.5',
      '١.٣٠.٣',
    ]) {
      expect(DidupProtocolConfig.isValidClientVersion(version), isFalse);
      expect(
        () => DidupProtocolConfig(
          oauthClientId: 'synthetic-client',
          redirectUri: Uri.parse('it.diarioup.test://callback'),
          clientVersion: version,
        ),
        throwsA(isA<CompatibilityFailure>()),
      );
    }
  });
}
