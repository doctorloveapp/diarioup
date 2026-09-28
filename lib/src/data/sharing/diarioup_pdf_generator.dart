import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/homework/school_date.dart';
import '../../domain/sharing/homework_export_selection.dart';
import '../../domain/sharing/homework_pdf_generator.dart';

final class DiarioUpPdfGenerator implements HomeworkPdfGenerator {
  DiarioUpPdfGenerator({
    required Uint8List logoBytes,
    required Uint8List fontBytes,
  }) : _logo = pw.MemoryImage(logoBytes),
       _font = pw.Font.ttf(fontBytes.buffer.asByteData());

  final pw.MemoryImage _logo;
  final pw.Font _font;

  static final PdfColor _indigo = PdfColor.fromHex('#4F46E5');
  static final PdfColor _ink = PdfColor.fromHex('#111827');
  static final PdfColor _secondary = PdfColor.fromHex('#475569');
  static final PdfColor _border = PdfColor.fromHex('#CBD5E1');
  static final PdfColor _surfaceTint = PdfColor.fromHex('#F8FAFC');

  @override
  Future<Uint8List> generate({
    required List<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
    required DateTime generatedAt,
  }) async {
    final document = pw.Document(
      title: 'Compiti DiarioUp',
      creator: 'DiarioUp',
      subject: 'Elenco dei compiti da fare',
      theme: pw.ThemeData.withFont(base: _font, bold: _font),
    );
    final selectionLabel = _selectionLabel(selection);

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 28),
        header: (context) => _buildHeader(selectionLabel),
        footer: (context) => _buildFooter(context, generatedAt),
        build: (context) => <pw.Widget>[
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: _surfaceTint,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              border: pw.Border.all(color: _border, width: 0.6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  selectionLabel,
                  style: pw.TextStyle(
                    color: _ink,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '${homework.length} ${homework.length == 1 ? 'compito' : 'compiti'}',
                  style: pw.TextStyle(color: _secondary, fontSize: 9),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: const <String>['Materia', 'Testo', 'Scadenza'],
            data: homework
                .map(
                  (item) => <String>[
                    _clean(item.subjectName) ?? 'Senza materia',
                    _clean(item.text) ?? '',
                    item.dueOn == null
                        ? 'Senza scadenza'
                        : _formatDate(item.dueOn!),
                  ],
                )
                .toList(growable: false),
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(color: _border, width: 0.5),
              bottom: pw.BorderSide(color: _border, width: 0.7),
            ),
            columnWidths: const <int, pw.TableColumnWidth>{
              0: pw.FlexColumnWidth(1.6),
              1: pw.FlexColumnWidth(4.6),
              2: pw.FlexColumnWidth(1.5),
            },
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.topLeft,
            headerPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            headerDecoration: pw.BoxDecoration(color: _indigo),
            oddRowDecoration: pw.BoxDecoration(color: _surfaceTint),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 9.5,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(
              color: _ink,
              fontSize: 9.5,
              lineSpacing: 1.8,
            ),
            textStyleBuilder: (column, data, row) => pw.TextStyle(
              color: column == 2 ? _secondary : _ink,
              fontSize: 9.5,
              lineSpacing: 1.8,
              fontWeight: column == 0 ? pw.FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );

    return document.save();
  }

  pw.Widget _buildHeader(String selectionLabel) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(
            width: 40,
            height: 40,
            padding: const pw.EdgeInsets.all(3),
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: _border, width: 0.6),
            ),
            child: pw.Image(_logo, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  'DiarioUp',
                  style: pw.TextStyle(
                    color: _indigo,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Compiti da fare - $selectionLabel',
                  style: pw.TextStyle(color: _secondary, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, DateTime generatedAt) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _border, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Text(
            'Generato localmente il ${_formatDateTime(generatedAt)}',
            style: pw.TextStyle(color: _secondary, fontSize: 7.5),
          ),
          pw.Text(
            'Pagina ${context.pageNumber} di ${context.pagesCount}',
            style: pw.TextStyle(color: _secondary, fontSize: 7.5),
          ),
        ],
      ),
    );
  }

  String _selectionLabel(HomeworkExportSelection selection) {
    return switch (selection.scope) {
      HomeworkExportScope.day => 'Giorno ${_formatDate(selection.anchorDate!)}',
      HomeworkExportScope.subject =>
        'Materia ${_clean(selection.subjectName) ?? 'selezionata'}',
      HomeworkExportScope.week => _weekLabel(selection.anchorDate!),
    };
  }

  String _weekLabel(SchoolDate anchorDate) {
    final anchor = anchorDate.toLocalDate();
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return 'Settimana ${_formatDateTimeDate(monday)} - '
        '${_formatDateTimeDate(sunday)}';
  }

  String _formatDate(SchoolDate date) =>
      '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';

  String _formatDateTimeDate(DateTime date) =>
      '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';

  String _formatDateTime(DateTime date) =>
      '${_formatDateTimeDate(date)} alle '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String? _clean(String? value) {
    final clean = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
    return clean == null || clean.isEmpty ? null : clean;
  }
}
