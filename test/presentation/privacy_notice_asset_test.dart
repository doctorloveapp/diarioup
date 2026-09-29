import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('la data della privacy usa spazi non separabili', () async {
    final notice = await File(
      'assets/privacy/informativa_privacy.txt',
    ).readAsString();

    expect(notice, contains('29\u00A0Settembre\u00A02026'));
  });
}
