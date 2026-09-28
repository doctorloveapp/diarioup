import 'dart:io';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('genera un documento PDF valido con logo e testo completo', () async {
    final generator = DiarioUpPdfGenerator(
      logoBytes: await File('assets/logo_diarioup.png').readAsBytes(),
      fontBytes: await File(
        'assets/fonts/inter/InterVariable.ttf',
      ).readAsBytes(),
    );
    final longText = List<String>.filled(
      8,
      'Studiare il capitolo e completare gli esercizi assegnati.',
    ).join(' ');

    final bytes = await generator.generate(
      homework: <HomeworkAgendaItem>[
        HomeworkAgendaItem(
          id: 'homework-1',
          profileId: 'profile-1',
          text: longText,
          subjectId: 'italian',
          subjectName: 'Italiano',
          dueOn: const SchoolDate(2026, 10, 2),
          isDone: false,
          changedAfterCompletion: false,
          requiresIdentityReview: false,
          origin: HomeworkOrigin.manual,
          updatedAt: DateTime.utc(2026, 9, 28),
          personalNote: 'Questa nota privata non appartiene al PDF.',
        ),
      ],
      selection: HomeworkExportSelection.week(const SchoolDate(2026, 10, 1)),
      generatedAt: DateTime(2026, 9, 28, 18, 30),
    );

    expect(bytes, isA<Uint8List>());
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(10000));
  });
}
