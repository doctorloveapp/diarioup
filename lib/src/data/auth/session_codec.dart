import 'dart:convert';

import '../../domain/errors/didup_failure.dart';
import '../../domain/auth/student_gender.dart';
import 'session.dart';

final class SessionCodec {
  const SessionCodec();

  String encode(DidupSession session) => jsonEncode(<String, Object?>{
    'schema': 1,
    'accessToken': session.accessToken,
    'refreshToken': session.refreshToken,
    'tokenType': session.tokenType,
    'scopes': session.scopes,
    'expiresAt': session.expiresAt?.toUtc().toIso8601String(),
    'schoolCode': session.schoolCode,
    'username': session.username,
    'activeProfileId': session.activeProfileId,
    'profiles': <String, Object?>{
      for (final entry in session.profiles.entries)
        entry.key: <String, Object?>{
          'sourceProfileId': entry.value.sourceProfileId,
          'appAuthToken': entry.value.appAuthToken,
          'schoolMinistryCode': entry.value.schoolMinistryCode,
          'notificationOptions': entry.value.notificationOptions,
          'displayLabel': entry.value.displayLabel,
          'gender': entry.value.gender.name,
          'academicYear': entry.value.academicYear,
          'academicYearStart': entry.value.academicYearStart
              ?.toUtc()
              .toIso8601String(),
        },
    },
  });

  DidupSession decode(String encoded) {
    try {
      final root = _stringMap(jsonDecode(encoded));
      if (root['schema'] != 1) {
        throw const InvalidPayloadFailure('Versione sessione non supportata.');
      }
      final rawProfiles = _stringMap(root['profiles']);
      final profiles = <String, DidupProfileSession>{};
      for (final entry in rawProfiles.entries) {
        final value = _stringMap(entry.value);
        profiles[entry.key] = DidupProfileSession(
          sourceProfileId: _requiredString(value, 'sourceProfileId'),
          appAuthToken: _requiredString(value, 'appAuthToken'),
          schoolMinistryCode: _requiredString(value, 'schoolMinistryCode'),
          notificationOptions: _stringBoolMap(value['notificationOptions']),
          displayLabel: _optionalString(value['displayLabel']) ?? '',
          gender: _decodeGender(value['gender']),
          academicYear: _optionalString(value['academicYear']),
          academicYearStart: _optionalDate(value['academicYearStart']),
        );
      }
      return DidupSession(
        accessToken: _requiredString(root, 'accessToken'),
        refreshToken: _optionalString(root['refreshToken']),
        tokenType: _requiredString(root, 'tokenType'),
        scopes: _stringList(root['scopes']),
        expiresAt: _optionalDate(root['expiresAt']),
        schoolCode: _requiredString(root, 'schoolCode'),
        username: _requiredString(root, 'username'),
        profiles: profiles,
        activeProfileId: _optionalString(root['activeProfileId']),
      );
    } on FormatException catch (_) {
      throw const InvalidPayloadFailure('Sessione locale non leggibile.');
    } on TypeError catch (_) {
      throw const InvalidPayloadFailure('Sessione locale non valida.');
    }
  }
}

Map<String, Object?> _stringMap(Object? value) {
  if (value is! Map<Object?, Object?>) {
    throw const InvalidPayloadFailure();
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) throw const InvalidPayloadFailure();
    result[key] = entry.value;
  }
  return result;
}

Map<String, bool> _stringBoolMap(Object? value) {
  final map = _stringMap(value);
  return <String, bool>{
    for (final entry in map.entries)
      if (entry.value case final bool value) entry.key: value,
  };
}

String _requiredString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! String || value.isEmpty) throw const InvalidPayloadFailure();
  return value;
}

String? _optionalString(Object? value) => value is String ? value : null;

DateTime? _optionalDate(Object? value) {
  final text = _optionalString(value);
  return text == null ? null : DateTime.tryParse(text);
}

List<String> _stringList(Object? value) {
  if (value is! List<Object?>) return const <String>[];
  return value.whereType<String>().toList(growable: false);
}

StudentGender _decodeGender(Object? value) {
  final name = _optionalString(value);
  for (final gender in StudentGender.values) {
    if (gender.name == name) return gender;
  }
  return StudentGender.unknown;
}
