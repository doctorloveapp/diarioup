import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../domain/errors/didup_failure.dart';
import '../../domain/homework/homework.dart';
import '../../domain/homework/school_date.dart';
import 'homework_identity_registry.dart';

final class HomeworkNormalizer {
  HomeworkNormalizer({
    required HomeworkIdentityRegistry identityRegistry,
    DateTime Function()? now,
  }) : _identityRegistry = identityRegistry,
       _now = now ?? DateTime.now;

  final HomeworkIdentityRegistry _identityRegistry;
  final DateTime Function() _now;

  Future<HomeworkBatch> normalizeDashboard({
    required String profileId,
    required Map<String, Object?> response,
  }) async {
    if (response['success'] == false) {
      throw const InvalidPayloadFailure('Dashboard DidUP non riuscita.');
    }
    final envelope = _stringMap(response['data']);
    final rawData = envelope['dati'];
    if (rawData is! List<Object?> || rawData.isEmpty) {
      throw const InvalidPayloadFailure('Dashboard priva di dati.');
    }
    final dashboard = _stringMap(rawData.first);
    final directive = _directive(dashboard);
    final rawRecords = dashboard['registro'];
    if (rawRecords == null) {
      return HomeworkBatch(
        homework: const <Homework>[],
        deletedSourceRecordIds: const <String>[],
        directive: directive,
        isPartial: true,
      );
    }
    if (rawRecords is! List<Object?>) throw const InvalidPayloadFailure();

    final homework = <Homework>[];
    final deleted = <String>[];
    var isPartial = false;
    final observedAt = _now().toUtc();

    for (final rawRecord in rawRecords) {
      final record = _stringMap(rawRecord);
      final sourcePk = _requiredString(record, 'pk');
      final operation = _optionalString(record['operazione'])?.toUpperCase();
      if (operation == 'D') {
        deleted.add(sourcePk);
        continue;
      }
      final rawAssignedOn =
          record['datGiorno'] ?? record['data'] ?? record['datEvento'];
      final assignedOn = _parseSchoolDate(rawAssignedOn);
      if (_hasText(rawAssignedOn) && assignedOn == null) isPartial = true;
      final sourceRecord = SourceRecordReference(
        sourcePrimaryKey: sourcePk,
        revision:
            _optionalString(record['revisione']) ??
            _optionalString(record['revision']),
        operation: SourceRecordOperation.insertOrUpdate,
        recordDay: assignedOn,
      );
      final subjectName = _cleanText(_optionalString(record['materia']) ?? '');
      final subjectId =
          _optionalString(record['pkMateria']) ??
          _optionalString(record['sourceSubjectId']);
      final rawHomework = record['compiti'];
      if (rawHomework == null) continue;
      if (rawHomework is! List<Object?>) {
        isPartial = true;
        continue;
      }

      for (var position = 0; position < rawHomework.length; position++) {
        final item = _stringMap(rawHomework[position]);
        final text = _cleanText(
          _optionalString(item['compito']) ??
              _optionalString(item['testo']) ??
              '',
        );
        if (text.isEmpty) {
          isPartial = true;
          continue;
        }
        final rawDueOn = item['dataConsegna'] ?? item['dueDate'];
        final dueOn = _parseSchoolDate(rawDueOn);
        if (_hasText(rawDueOn) && dueOn == null) isPartial = true;
        final sourceItemId =
            _optionalString(item['pk']) ?? _optionalString(item['id']);
        final revision = sha256
            .convert(utf8.encode('$text\u0000${dueOn?.toString() ?? ''}'))
            .toString();
        final identity = await _identityRegistry.resolve(
          profileId: profileId,
          sourceRecordId: sourcePk,
          position: position,
          contentRevision: revision,
          sourceItemId: sourceItemId,
        );
        homework.add(
          Homework(
            id: identity.id,
            profileId: profileId,
            sourceRecord: sourceRecord,
            nestedIdentity: identity.nestedIdentity,
            sourceItemId: sourceItemId,
            identityConfidence: identity.confidence,
            origin: HomeworkOrigin.argo,
            subject: subjectName.isEmpty && subjectId == null
                ? null
                : SubjectReference(
                    name: subjectName,
                    sourceSubjectId: subjectId,
                  ),
            text: text,
            assignedOn: assignedOn,
            dueOn: dueOn,
            contentRevision: revision,
            firstSeenAt: observedAt,
            updatedAt: observedAt,
            requiresIdentityReview: identity.requiresReview,
          ),
        );
      }
    }

    return HomeworkBatch(
      homework: List<Homework>.unmodifiable(homework),
      deletedSourceRecordIds: List<String>.unmodifiable(deleted),
      directive: directive,
      isPartial: isPartial,
    );
  }
}

SyncDirective _directive(Map<String, Object?> dashboard) {
  if (_asBool(dashboard['profiloDisabilitato'])) {
    return SyncDirective.profileDisabled;
  }
  if (_asBool(dashboard['ricaricaDati'])) return SyncDirective.reload;
  if (_asBool(dashboard['rimuoviDatiLocali'])) {
    return SyncDirective.rebuildSourceCache;
  }
  return SyncDirective.incremental;
}

bool _asBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    return const <String>{
      'S',
      'SI',
      'TRUE',
      '1',
    }.contains(value.trim().toUpperCase());
  }
  return false;
}

bool _hasText(Object? value) => value is String && value.trim().isNotEmpty;

SchoolDate? _parseSchoolDate(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  final text = value.trim();
  final italian = RegExp(r'^(\d{2})/(\d{2})/(\d{4})').firstMatch(text);
  if (italian != null) {
    return _safeSchoolDate(
      int.parse(italian.group(3)!),
      int.parse(italian.group(2)!),
      int.parse(italian.group(1)!),
    );
  }
  final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
  if (iso != null) {
    return _safeSchoolDate(
      int.parse(iso.group(1)!),
      int.parse(iso.group(2)!),
      int.parse(iso.group(3)!),
    );
  }
  return null;
}

SchoolDate? _safeSchoolDate(int year, int month, int day) {
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) return null;
  return SchoolDate(year, month, day);
}

String _cleanText(String value) {
  var text = value
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");
  final lines = text
      .split(RegExp(r'\r?\n'))
      .map((String line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim());
  text = lines.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  return text;
}

Map<String, Object?> _stringMap(Object? value) {
  if (value is! Map<Object?, Object?>) throw const InvalidPayloadFailure();
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) throw const InvalidPayloadFailure();
    result[key] = entry.value;
  }
  return result;
}

String _requiredString(Map<String, Object?> map, String key) {
  final value = _optionalString(map[key]);
  if (value == null || value.isEmpty) throw const InvalidPayloadFailure();
  return value;
}

String? _optionalString(Object? value) => value is String ? value : null;
