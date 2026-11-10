import 'dart:io';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatta la scadenza con il giorno della settimana', () {
    expect(
      DiarioUpPdfGenerator.formatDueDate(const SchoolDate(2026, 9, 29)),
      'Martedì 29/09/2026',
    );
  });

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
    if (const bool.fromEnvironment('DIARIOUP_PDF_REVIEW')) {
      await Directory('tmp/pdfs').create(recursive: true);
      await File('tmp/pdfs/settimana.pdf').writeAsBytes(bytes);
    }
  });

  test('genera PDF multipagina raggruppato per materie con testi lunghi', () async {
    final generator = DiarioUpPdfGenerator(
      logoBytes: await File('assets/logo_diarioup.png').readAsBytes(),
      fontBytes: await File(
        'assets/fonts/inter/InterVariable.ttf',
      ).readAsBytes(),
    );
    final homework = <HomeworkAgendaItem>[
      for (var index = 0; index < 72; index++)
        HomeworkAgendaItem(
          id: 'sample-$index',
          profileId: 'profile-1',
          subjectId: index % 2 == 0 ? 'greek' : 'math',
          subjectName: index % 2 == 0 ? 'Lingua e cultura greca' : 'Matematica',
          text:
              'ATTIVITA_${index.toString().padLeft(2, '0')} - ${index == 0 ? 'Ripassare il programma precedente. ' : ''}'
              'Studiare il capitolo assegnato e completare gli esercizi. '
              'Annotare i passaggi e preparare una breve sintesi per la lezione.',
          dueOn: index == 0
              ? const SchoolDate(2024, 1, 2)
              : index == 70
              ? null
              : SchoolDate(2030, 11, index % 28 + 1),
          isDone: index == 68,
          changedAfterCompletion: false,
          requiresIdentityReview: false,
          origin: HomeworkOrigin.manual,
          updatedAt: DateTime.utc(2026, 11, 10),
          personalNote: 'NOTA_PRIVATA_DA_ESCLUDERE',
        ),
    ];
    final bytes = await generator.generate(
      homework: homework,
      selection: HomeworkExportSelection.subjects({
        'math': 'Matematica',
        'greek': 'Lingua e cultura greca',
      }),
      generatedAt: DateTime(2026, 11, 10, 18),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(10000));
    if (const bool.fromEnvironment('DIARIOUP_PDF_REVIEW')) {
      await Directory('tmp/pdfs').create(recursive: true);
      await File('tmp/pdfs/materie.pdf').writeAsBytes(bytes);
    }
  });

  test(
    'esporta uno storico esteso senza il limite predefinito di 20 pagine',
    () async {
      final generator = DiarioUpPdfGenerator(
        logoBytes: await File('assets/logo_diarioup.png').readAsBytes(),
        fontBytes: await File(
          'assets/fonts/inter/InterVariable.ttf',
        ).readAsBytes(),
      );
      final bytes = await generator.generate(
        homework: [
          for (var index = 0; index < 400; index++)
            HomeworkAgendaItem(
              id: 'history-$index',
              profileId: 'profile-1',
              subjectId: 'italian',
              subjectName: 'Italiano',
              text: List.filled(
                4,
                'Studiare il capitolo assegnato e completare gli esercizi, preparando una sintesi scritta.',
              ).join(' '),
              isDone: false,
              changedAfterCompletion: false,
              requiresIdentityReview: false,
              origin: HomeworkOrigin.manual,
              updatedAt: DateTime.utc(2026, 11, 10),
            ),
        ],
        selection: HomeworkExportSelection.subjects({'italian': 'Italiano'}),
        generatedAt: DateTime(2026, 11, 10),
      );
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    },
  );
}
