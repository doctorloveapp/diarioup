// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class LocalUsers extends Table with TableInfo<LocalUsers, LocalUsersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalUsers(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'it\''),
  );
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'system\''),
  );
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'Europe/Rome\''),
  );
  late final GeneratedColumn<String> preferencesJson = GeneratedColumn<String>(
    'preferences_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'{}\''),
  );
  late final GeneratedColumn<String> privacyNoticeVersion =
      GeneratedColumn<String>(
        'privacy_notice_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<String> ageBand = GeneratedColumn<String>(
    'age_band',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locale,
    theme,
    timeZone,
    preferencesJson,
    privacyNoticeVersion,
    ageBand,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUsersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUsersData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      preferencesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferences_json'],
      )!,
      privacyNoticeVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}privacy_notice_version'],
      ),
      ageBand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_band'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  LocalUsers createAlias(String alias) {
    return LocalUsers(attachedDatabase, alias);
  }
}

class LocalUsersData extends DataClass implements Insertable<LocalUsersData> {
  final String id;
  final String locale;
  final String theme;
  final String timeZone;
  final String preferencesJson;
  final String? privacyNoticeVersion;
  final String? ageBand;
  final DateTime createdAt;
  const LocalUsersData({
    required this.id,
    required this.locale,
    required this.theme,
    required this.timeZone,
    required this.preferencesJson,
    this.privacyNoticeVersion,
    this.ageBand,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['locale'] = Variable<String>(locale);
    map['theme'] = Variable<String>(theme);
    map['time_zone'] = Variable<String>(timeZone);
    map['preferences_json'] = Variable<String>(preferencesJson);
    if (!nullToAbsent || privacyNoticeVersion != null) {
      map['privacy_notice_version'] = Variable<String>(privacyNoticeVersion);
    }
    if (!nullToAbsent || ageBand != null) {
      map['age_band'] = Variable<String>(ageBand);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      locale: Value(locale),
      theme: Value(theme),
      timeZone: Value(timeZone),
      preferencesJson: Value(preferencesJson),
      privacyNoticeVersion: privacyNoticeVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(privacyNoticeVersion),
      ageBand: ageBand == null && nullToAbsent
          ? const Value.absent()
          : Value(ageBand),
      createdAt: Value(createdAt),
    );
  }

  factory LocalUsersData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUsersData(
      id: serializer.fromJson<String>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      theme: serializer.fromJson<String>(json['theme']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      preferencesJson: serializer.fromJson<String>(json['preferencesJson']),
      privacyNoticeVersion: serializer.fromJson<String?>(
        json['privacyNoticeVersion'],
      ),
      ageBand: serializer.fromJson<String?>(json['ageBand']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locale': serializer.toJson<String>(locale),
      'theme': serializer.toJson<String>(theme),
      'timeZone': serializer.toJson<String>(timeZone),
      'preferencesJson': serializer.toJson<String>(preferencesJson),
      'privacyNoticeVersion': serializer.toJson<String?>(privacyNoticeVersion),
      'ageBand': serializer.toJson<String?>(ageBand),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalUsersData copyWith({
    String? id,
    String? locale,
    String? theme,
    String? timeZone,
    String? preferencesJson,
    Value<String?> privacyNoticeVersion = const Value.absent(),
    Value<String?> ageBand = const Value.absent(),
    DateTime? createdAt,
  }) => LocalUsersData(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    theme: theme ?? this.theme,
    timeZone: timeZone ?? this.timeZone,
    preferencesJson: preferencesJson ?? this.preferencesJson,
    privacyNoticeVersion: privacyNoticeVersion.present
        ? privacyNoticeVersion.value
        : this.privacyNoticeVersion,
    ageBand: ageBand.present ? ageBand.value : this.ageBand,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalUsersData copyWithCompanion(LocalUsersCompanion data) {
    return LocalUsersData(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      theme: data.theme.present ? data.theme.value : this.theme,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      preferencesJson: data.preferencesJson.present
          ? data.preferencesJson.value
          : this.preferencesJson,
      privacyNoticeVersion: data.privacyNoticeVersion.present
          ? data.privacyNoticeVersion.value
          : this.privacyNoticeVersion,
      ageBand: data.ageBand.present ? data.ageBand.value : this.ageBand,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersData(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('theme: $theme, ')
          ..write('timeZone: $timeZone, ')
          ..write('preferencesJson: $preferencesJson, ')
          ..write('privacyNoticeVersion: $privacyNoticeVersion, ')
          ..write('ageBand: $ageBand, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locale,
    theme,
    timeZone,
    preferencesJson,
    privacyNoticeVersion,
    ageBand,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUsersData &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.theme == this.theme &&
          other.timeZone == this.timeZone &&
          other.preferencesJson == this.preferencesJson &&
          other.privacyNoticeVersion == this.privacyNoticeVersion &&
          other.ageBand == this.ageBand &&
          other.createdAt == this.createdAt);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUsersData> {
  final Value<String> id;
  final Value<String> locale;
  final Value<String> theme;
  final Value<String> timeZone;
  final Value<String> preferencesJson;
  final Value<String?> privacyNoticeVersion;
  final Value<String?> ageBand;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.theme = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.privacyNoticeVersion = const Value.absent(),
    this.ageBand = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    this.locale = const Value.absent(),
    this.theme = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.privacyNoticeVersion = const Value.absent(),
    this.ageBand = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<LocalUsersData> custom({
    Expression<String>? id,
    Expression<String>? locale,
    Expression<String>? theme,
    Expression<String>? timeZone,
    Expression<String>? preferencesJson,
    Expression<String>? privacyNoticeVersion,
    Expression<String>? ageBand,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (theme != null) 'theme': theme,
      if (timeZone != null) 'time_zone': timeZone,
      if (preferencesJson != null) 'preferences_json': preferencesJson,
      if (privacyNoticeVersion != null)
        'privacy_notice_version': privacyNoticeVersion,
      if (ageBand != null) 'age_band': ageBand,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? locale,
    Value<String>? theme,
    Value<String>? timeZone,
    Value<String>? preferencesJson,
    Value<String?>? privacyNoticeVersion,
    Value<String?>? ageBand,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      timeZone: timeZone ?? this.timeZone,
      preferencesJson: preferencesJson ?? this.preferencesJson,
      privacyNoticeVersion: privacyNoticeVersion ?? this.privacyNoticeVersion,
      ageBand: ageBand ?? this.ageBand,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (preferencesJson.present) {
      map['preferences_json'] = Variable<String>(preferencesJson.value);
    }
    if (privacyNoticeVersion.present) {
      map['privacy_notice_version'] = Variable<String>(
        privacyNoticeVersion.value,
      );
    }
    if (ageBand.present) {
      map['age_band'] = Variable<String>(ageBand.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('theme: $theme, ')
          ..write('timeZone: $timeZone, ')
          ..write('preferencesJson: $preferencesJson, ')
          ..write('privacyNoticeVersion: $privacyNoticeVersion, ')
          ..write('ageBand: $ageBand, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ArgoConnections extends Table
    with TableInfo<ArgoConnections, ArgoConnectionsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ArgoConnections(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_users (id)',
    ),
  );
  late final GeneratedColumn<String> schoolMinistryCode =
      GeneratedColumn<String>(
        'school_ministry_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'family\''),
  );
  late final GeneratedColumn<String> secretReference = GeneratedColumn<String>(
    'secret_reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sessionState = GeneratedColumn<String>(
    'session_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'active\''),
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    schoolMinistryCode,
    role,
    secretReference,
    sessionState,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'argo_connections';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, schoolMinistryCode},
  ];
  @override
  ArgoConnectionsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArgoConnectionsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      schoolMinistryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_ministry_code'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      secretReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secret_reference'],
      )!,
      sessionState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_state'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  ArgoConnections createAlias(String alias) {
    return ArgoConnections(attachedDatabase, alias);
  }
}

class ArgoConnectionsData extends DataClass
    implements Insertable<ArgoConnectionsData> {
  final String id;
  final String userId;
  final String schoolMinistryCode;
  final String role;
  final String secretReference;
  final String sessionState;
  final DateTime updatedAt;
  const ArgoConnectionsData({
    required this.id,
    required this.userId,
    required this.schoolMinistryCode,
    required this.role,
    required this.secretReference,
    required this.sessionState,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['school_ministry_code'] = Variable<String>(schoolMinistryCode);
    map['role'] = Variable<String>(role);
    map['secret_reference'] = Variable<String>(secretReference);
    map['session_state'] = Variable<String>(sessionState);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ArgoConnectionsCompanion toCompanion(bool nullToAbsent) {
    return ArgoConnectionsCompanion(
      id: Value(id),
      userId: Value(userId),
      schoolMinistryCode: Value(schoolMinistryCode),
      role: Value(role),
      secretReference: Value(secretReference),
      sessionState: Value(sessionState),
      updatedAt: Value(updatedAt),
    );
  }

  factory ArgoConnectionsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArgoConnectionsData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      schoolMinistryCode: serializer.fromJson<String>(
        json['schoolMinistryCode'],
      ),
      role: serializer.fromJson<String>(json['role']),
      secretReference: serializer.fromJson<String>(json['secretReference']),
      sessionState: serializer.fromJson<String>(json['sessionState']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'schoolMinistryCode': serializer.toJson<String>(schoolMinistryCode),
      'role': serializer.toJson<String>(role),
      'secretReference': serializer.toJson<String>(secretReference),
      'sessionState': serializer.toJson<String>(sessionState),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ArgoConnectionsData copyWith({
    String? id,
    String? userId,
    String? schoolMinistryCode,
    String? role,
    String? secretReference,
    String? sessionState,
    DateTime? updatedAt,
  }) => ArgoConnectionsData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    schoolMinistryCode: schoolMinistryCode ?? this.schoolMinistryCode,
    role: role ?? this.role,
    secretReference: secretReference ?? this.secretReference,
    sessionState: sessionState ?? this.sessionState,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ArgoConnectionsData copyWithCompanion(ArgoConnectionsCompanion data) {
    return ArgoConnectionsData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      schoolMinistryCode: data.schoolMinistryCode.present
          ? data.schoolMinistryCode.value
          : this.schoolMinistryCode,
      role: data.role.present ? data.role.value : this.role,
      secretReference: data.secretReference.present
          ? data.secretReference.value
          : this.secretReference,
      sessionState: data.sessionState.present
          ? data.sessionState.value
          : this.sessionState,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArgoConnectionsData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('schoolMinistryCode: $schoolMinistryCode, ')
          ..write('role: $role, ')
          ..write('secretReference: $secretReference, ')
          ..write('sessionState: $sessionState, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    schoolMinistryCode,
    role,
    secretReference,
    sessionState,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArgoConnectionsData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.schoolMinistryCode == this.schoolMinistryCode &&
          other.role == this.role &&
          other.secretReference == this.secretReference &&
          other.sessionState == this.sessionState &&
          other.updatedAt == this.updatedAt);
}

class ArgoConnectionsCompanion extends UpdateCompanion<ArgoConnectionsData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> schoolMinistryCode;
  final Value<String> role;
  final Value<String> secretReference;
  final Value<String> sessionState;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ArgoConnectionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.schoolMinistryCode = const Value.absent(),
    this.role = const Value.absent(),
    this.secretReference = const Value.absent(),
    this.sessionState = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArgoConnectionsCompanion.insert({
    required String id,
    required String userId,
    required String schoolMinistryCode,
    this.role = const Value.absent(),
    required String secretReference,
    this.sessionState = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       schoolMinistryCode = Value(schoolMinistryCode),
       secretReference = Value(secretReference),
       updatedAt = Value(updatedAt);
  static Insertable<ArgoConnectionsData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? schoolMinistryCode,
    Expression<String>? role,
    Expression<String>? secretReference,
    Expression<String>? sessionState,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (schoolMinistryCode != null)
        'school_ministry_code': schoolMinistryCode,
      if (role != null) 'role': role,
      if (secretReference != null) 'secret_reference': secretReference,
      if (sessionState != null) 'session_state': sessionState,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArgoConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? schoolMinistryCode,
    Value<String>? role,
    Value<String>? secretReference,
    Value<String>? sessionState,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ArgoConnectionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      schoolMinistryCode: schoolMinistryCode ?? this.schoolMinistryCode,
      role: role ?? this.role,
      secretReference: secretReference ?? this.secretReference,
      sessionState: sessionState ?? this.sessionState,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (schoolMinistryCode.present) {
      map['school_ministry_code'] = Variable<String>(schoolMinistryCode.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (secretReference.present) {
      map['secret_reference'] = Variable<String>(secretReference.value);
    }
    if (sessionState.present) {
      map['session_state'] = Variable<String>(sessionState.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArgoConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('schoolMinistryCode: $schoolMinistryCode, ')
          ..write('role: $role, ')
          ..write('secretReference: $secretReference, ')
          ..write('sessionState: $sessionState, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class StudentProfiles extends Table
    with TableInfo<StudentProfiles, StudentProfilesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  StudentProfiles(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> connectionId = GeneratedColumn<String>(
    'connection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES argo_connections (id)',
    ),
  );
  late final GeneratedColumn<String> sourceProfileId = GeneratedColumn<String>(
    'source_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    connectionId,
    sourceProfileId,
    academicYear,
    alias,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profiles';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {connectionId, sourceProfileId},
  ];
  @override
  StudentProfilesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfilesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      connectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_id'],
      )!,
      sourceProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_profile_id'],
      )!,
      academicYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  StudentProfiles createAlias(String alias) {
    return StudentProfiles(attachedDatabase, alias);
  }
}

class StudentProfilesData extends DataClass
    implements Insertable<StudentProfilesData> {
  final String id;
  final String connectionId;
  final String sourceProfileId;
  final String academicYear;
  final String alias;
  final DateTime updatedAt;
  const StudentProfilesData({
    required this.id,
    required this.connectionId,
    required this.sourceProfileId,
    required this.academicYear,
    required this.alias,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['connection_id'] = Variable<String>(connectionId);
    map['source_profile_id'] = Variable<String>(sourceProfileId);
    map['academic_year'] = Variable<String>(academicYear);
    map['alias'] = Variable<String>(alias);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentProfilesCompanion toCompanion(bool nullToAbsent) {
    return StudentProfilesCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      sourceProfileId: Value(sourceProfileId),
      academicYear: Value(academicYear),
      alias: Value(alias),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudentProfilesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfilesData(
      id: serializer.fromJson<String>(json['id']),
      connectionId: serializer.fromJson<String>(json['connectionId']),
      sourceProfileId: serializer.fromJson<String>(json['sourceProfileId']),
      academicYear: serializer.fromJson<String>(json['academicYear']),
      alias: serializer.fromJson<String>(json['alias']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'connectionId': serializer.toJson<String>(connectionId),
      'sourceProfileId': serializer.toJson<String>(sourceProfileId),
      'academicYear': serializer.toJson<String>(academicYear),
      'alias': serializer.toJson<String>(alias),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudentProfilesData copyWith({
    String? id,
    String? connectionId,
    String? sourceProfileId,
    String? academicYear,
    String? alias,
    DateTime? updatedAt,
  }) => StudentProfilesData(
    id: id ?? this.id,
    connectionId: connectionId ?? this.connectionId,
    sourceProfileId: sourceProfileId ?? this.sourceProfileId,
    academicYear: academicYear ?? this.academicYear,
    alias: alias ?? this.alias,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudentProfilesData copyWithCompanion(StudentProfilesCompanion data) {
    return StudentProfilesData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      sourceProfileId: data.sourceProfileId.present
          ? data.sourceProfileId.value
          : this.sourceProfileId,
      academicYear: data.academicYear.present
          ? data.academicYear.value
          : this.academicYear,
      alias: data.alias.present ? data.alias.value : this.alias,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfilesData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('sourceProfileId: $sourceProfileId, ')
          ..write('academicYear: $academicYear, ')
          ..write('alias: $alias, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    connectionId,
    sourceProfileId,
    academicYear,
    alias,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfilesData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.sourceProfileId == this.sourceProfileId &&
          other.academicYear == this.academicYear &&
          other.alias == this.alias &&
          other.updatedAt == this.updatedAt);
}

class StudentProfilesCompanion extends UpdateCompanion<StudentProfilesData> {
  final Value<String> id;
  final Value<String> connectionId;
  final Value<String> sourceProfileId;
  final Value<String> academicYear;
  final Value<String> alias;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudentProfilesCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.sourceProfileId = const Value.absent(),
    this.academicYear = const Value.absent(),
    this.alias = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentProfilesCompanion.insert({
    required String id,
    required String connectionId,
    required String sourceProfileId,
    required String academicYear,
    required String alias,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       connectionId = Value(connectionId),
       sourceProfileId = Value(sourceProfileId),
       academicYear = Value(academicYear),
       alias = Value(alias),
       updatedAt = Value(updatedAt);
  static Insertable<StudentProfilesData> custom({
    Expression<String>? id,
    Expression<String>? connectionId,
    Expression<String>? sourceProfileId,
    Expression<String>? academicYear,
    Expression<String>? alias,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (sourceProfileId != null) 'source_profile_id': sourceProfileId,
      if (academicYear != null) 'academic_year': academicYear,
      if (alias != null) 'alias': alias,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? connectionId,
    Value<String>? sourceProfileId,
    Value<String>? academicYear,
    Value<String>? alias,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudentProfilesCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      sourceProfileId: sourceProfileId ?? this.sourceProfileId,
      academicYear: academicYear ?? this.academicYear,
      alias: alias ?? this.alias,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<String>(connectionId.value);
    }
    if (sourceProfileId.present) {
      map['source_profile_id'] = Variable<String>(sourceProfileId.value);
    }
    if (academicYear.present) {
      map['academic_year'] = Variable<String>(academicYear.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfilesCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('sourceProfileId: $sourceProfileId, ')
          ..write('academicYear: $academicYear, ')
          ..write('alias: $alias, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Subjects extends Table with TableInfo<Subjects, SubjectsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Subjects(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES student_profiles (id)',
    ),
  );
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceSubjectId = GeneratedColumn<String>(
    'source_subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    academicYear,
    sourceSubjectId,
    name,
    colorValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, academicYear, name},
  ];
  @override
  SubjectsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      academicYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_year'],
      )!,
      sourceSubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_subject_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
    );
  }

  @override
  Subjects createAlias(String alias) {
    return Subjects(attachedDatabase, alias);
  }
}

class SubjectsData extends DataClass implements Insertable<SubjectsData> {
  final String id;
  final String profileId;
  final String academicYear;
  final String? sourceSubjectId;
  final String name;
  final int? colorValue;
  const SubjectsData({
    required this.id,
    required this.profileId,
    required this.academicYear,
    this.sourceSubjectId,
    required this.name,
    this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['academic_year'] = Variable<String>(academicYear);
    if (!nullToAbsent || sourceSubjectId != null) {
      map['source_subject_id'] = Variable<String>(sourceSubjectId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      academicYear: Value(academicYear),
      sourceSubjectId: sourceSubjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceSubjectId),
      name: Value(name),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
    );
  }

  factory SubjectsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectsData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      academicYear: serializer.fromJson<String>(json['academicYear']),
      sourceSubjectId: serializer.fromJson<String?>(json['sourceSubjectId']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'academicYear': serializer.toJson<String>(academicYear),
      'sourceSubjectId': serializer.toJson<String?>(sourceSubjectId),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int?>(colorValue),
    };
  }

  SubjectsData copyWith({
    String? id,
    String? profileId,
    String? academicYear,
    Value<String?> sourceSubjectId = const Value.absent(),
    String? name,
    Value<int?> colorValue = const Value.absent(),
  }) => SubjectsData(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    academicYear: academicYear ?? this.academicYear,
    sourceSubjectId: sourceSubjectId.present
        ? sourceSubjectId.value
        : this.sourceSubjectId,
    name: name ?? this.name,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
  );
  SubjectsData copyWithCompanion(SubjectsCompanion data) {
    return SubjectsData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      academicYear: data.academicYear.present
          ? data.academicYear.value
          : this.academicYear,
      sourceSubjectId: data.sourceSubjectId.present
          ? data.sourceSubjectId.value
          : this.sourceSubjectId,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('academicYear: $academicYear, ')
          ..write('sourceSubjectId: $sourceSubjectId, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    academicYear,
    sourceSubjectId,
    name,
    colorValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectsData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.academicYear == this.academicYear &&
          other.sourceSubjectId == this.sourceSubjectId &&
          other.name == this.name &&
          other.colorValue == this.colorValue);
}

class SubjectsCompanion extends UpdateCompanion<SubjectsData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> academicYear;
  final Value<String?> sourceSubjectId;
  final Value<String> name;
  final Value<int?> colorValue;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.academicYear = const Value.absent(),
    this.sourceSubjectId = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String profileId,
    required String academicYear,
    this.sourceSubjectId = const Value.absent(),
    required String name,
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       academicYear = Value(academicYear),
       name = Value(name);
  static Insertable<SubjectsData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? academicYear,
    Expression<String>? sourceSubjectId,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (academicYear != null) 'academic_year': academicYear,
      if (sourceSubjectId != null) 'source_subject_id': sourceSubjectId,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? academicYear,
    Value<String?>? sourceSubjectId,
    Value<String>? name,
    Value<int?>? colorValue,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      academicYear: academicYear ?? this.academicYear,
      sourceSubjectId: sourceSubjectId ?? this.sourceSubjectId,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (academicYear.present) {
      map['academic_year'] = Variable<String>(academicYear.value);
    }
    if (sourceSubjectId.present) {
      map['source_subject_id'] = Variable<String>(sourceSubjectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('academicYear: $academicYear, ')
          ..write('sourceSubjectId: $sourceSubjectId, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SourceRecords extends Table
    with TableInfo<SourceRecords, SourceRecordsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SourceRecords(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES student_profiles (id)',
    ),
  );
  late final GeneratedColumn<String> sourcePrimaryKey = GeneratedColumn<String>(
    'source_primary_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> revision = GeneratedColumn<String>(
    'revision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'active\''),
  );
  late final GeneratedColumn<String> recordDay = GeneratedColumn<String>(
    'record_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    sourcePrimaryKey,
    revision,
    state,
    recordDay,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_records';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, sourcePrimaryKey},
  ];
  @override
  SourceRecordsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRecordsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      sourcePrimaryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_primary_key'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      recordDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_day'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  SourceRecords createAlias(String alias) {
    return SourceRecords(attachedDatabase, alias);
  }
}

class SourceRecordsData extends DataClass
    implements Insertable<SourceRecordsData> {
  final String id;
  final String profileId;
  final String sourcePrimaryKey;
  final String? revision;
  final String state;
  final String? recordDay;
  final DateTime updatedAt;
  const SourceRecordsData({
    required this.id,
    required this.profileId,
    required this.sourcePrimaryKey,
    this.revision,
    required this.state,
    this.recordDay,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['source_primary_key'] = Variable<String>(sourcePrimaryKey);
    if (!nullToAbsent || revision != null) {
      map['revision'] = Variable<String>(revision);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || recordDay != null) {
      map['record_day'] = Variable<String>(recordDay);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SourceRecordsCompanion toCompanion(bool nullToAbsent) {
    return SourceRecordsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      sourcePrimaryKey: Value(sourcePrimaryKey),
      revision: revision == null && nullToAbsent
          ? const Value.absent()
          : Value(revision),
      state: Value(state),
      recordDay: recordDay == null && nullToAbsent
          ? const Value.absent()
          : Value(recordDay),
      updatedAt: Value(updatedAt),
    );
  }

  factory SourceRecordsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRecordsData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      sourcePrimaryKey: serializer.fromJson<String>(json['sourcePrimaryKey']),
      revision: serializer.fromJson<String?>(json['revision']),
      state: serializer.fromJson<String>(json['state']),
      recordDay: serializer.fromJson<String?>(json['recordDay']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'sourcePrimaryKey': serializer.toJson<String>(sourcePrimaryKey),
      'revision': serializer.toJson<String?>(revision),
      'state': serializer.toJson<String>(state),
      'recordDay': serializer.toJson<String?>(recordDay),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SourceRecordsData copyWith({
    String? id,
    String? profileId,
    String? sourcePrimaryKey,
    Value<String?> revision = const Value.absent(),
    String? state,
    Value<String?> recordDay = const Value.absent(),
    DateTime? updatedAt,
  }) => SourceRecordsData(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    sourcePrimaryKey: sourcePrimaryKey ?? this.sourcePrimaryKey,
    revision: revision.present ? revision.value : this.revision,
    state: state ?? this.state,
    recordDay: recordDay.present ? recordDay.value : this.recordDay,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SourceRecordsData copyWithCompanion(SourceRecordsCompanion data) {
    return SourceRecordsData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sourcePrimaryKey: data.sourcePrimaryKey.present
          ? data.sourcePrimaryKey.value
          : this.sourcePrimaryKey,
      revision: data.revision.present ? data.revision.value : this.revision,
      state: data.state.present ? data.state.value : this.state,
      recordDay: data.recordDay.present ? data.recordDay.value : this.recordDay,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceRecordsData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourcePrimaryKey: $sourcePrimaryKey, ')
          ..write('revision: $revision, ')
          ..write('state: $state, ')
          ..write('recordDay: $recordDay, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    sourcePrimaryKey,
    revision,
    state,
    recordDay,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceRecordsData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.sourcePrimaryKey == this.sourcePrimaryKey &&
          other.revision == this.revision &&
          other.state == this.state &&
          other.recordDay == this.recordDay &&
          other.updatedAt == this.updatedAt);
}

class SourceRecordsCompanion extends UpdateCompanion<SourceRecordsData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> sourcePrimaryKey;
  final Value<String?> revision;
  final Value<String> state;
  final Value<String?> recordDay;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SourceRecordsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.sourcePrimaryKey = const Value.absent(),
    this.revision = const Value.absent(),
    this.state = const Value.absent(),
    this.recordDay = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceRecordsCompanion.insert({
    required String id,
    required String profileId,
    required String sourcePrimaryKey,
    this.revision = const Value.absent(),
    this.state = const Value.absent(),
    this.recordDay = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       sourcePrimaryKey = Value(sourcePrimaryKey),
       updatedAt = Value(updatedAt);
  static Insertable<SourceRecordsData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? sourcePrimaryKey,
    Expression<String>? revision,
    Expression<String>? state,
    Expression<String>? recordDay,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (sourcePrimaryKey != null) 'source_primary_key': sourcePrimaryKey,
      if (revision != null) 'revision': revision,
      if (state != null) 'state': state,
      if (recordDay != null) 'record_day': recordDay,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? sourcePrimaryKey,
    Value<String?>? revision,
    Value<String>? state,
    Value<String?>? recordDay,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SourceRecordsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      sourcePrimaryKey: sourcePrimaryKey ?? this.sourcePrimaryKey,
      revision: revision ?? this.revision,
      state: state ?? this.state,
      recordDay: recordDay ?? this.recordDay,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (sourcePrimaryKey.present) {
      map['source_primary_key'] = Variable<String>(sourcePrimaryKey.value);
    }
    if (revision.present) {
      map['revision'] = Variable<String>(revision.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (recordDay.present) {
      map['record_day'] = Variable<String>(recordDay.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourcePrimaryKey: $sourcePrimaryKey, ')
          ..write('revision: $revision, ')
          ..write('state: $state, ')
          ..write('recordDay: $recordDay, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HomeworkItems extends Table
    with TableInfo<HomeworkItems, HomeworkItemsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HomeworkItems(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES student_profiles (id)',
    ),
  );
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_records (id)',
    ),
  );
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  late final GeneratedColumn<String> nestedIdentity = GeneratedColumn<String>(
    'nested_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceItemId = GeneratedColumn<String>(
    'source_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> identityConfidence =
      GeneratedColumn<String>(
        'identity_confidence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> personalNote = GeneratedColumn<String>(
    'personal_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> assignedOn = GeneratedColumn<String>(
    'assigned_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> contentRevision = GeneratedColumn<String>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceState = GeneratedColumn<String>(
    'source_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'active\''),
  );
  late final GeneratedColumn<bool> requiresIdentityReview =
      GeneratedColumn<bool>(
        'requires_identity_review',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_identity_review" IN (0, 1))',
        ),
        defaultValue: const CustomExpression('0'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    sourceRecordId,
    subjectId,
    nestedIdentity,
    sourceItemId,
    identityConfidence,
    origin,
    body,
    personalNote,
    assignedOn,
    contentRevision,
    firstSeenAt,
    updatedAt,
    sourceState,
    requiresIdentityReview,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'homework_items';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HomeworkItemsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeworkItemsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      ),
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      ),
      nestedIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nested_identity'],
      )!,
      sourceItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_item_id'],
      ),
      identityConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_confidence'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      personalNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_note'],
      ),
      assignedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_on'],
      ),
      contentRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_revision'],
      )!,
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sourceState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_state'],
      )!,
      requiresIdentityReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_identity_review'],
      )!,
    );
  }

  @override
  HomeworkItems createAlias(String alias) {
    return HomeworkItems(attachedDatabase, alias);
  }
}

class HomeworkItemsData extends DataClass
    implements Insertable<HomeworkItemsData> {
  final String id;
  final String profileId;
  final String? sourceRecordId;
  final String? subjectId;
  final String nestedIdentity;
  final String? sourceItemId;
  final String identityConfidence;
  final String origin;
  final String body;
  final String? personalNote;
  final String? assignedOn;
  final String contentRevision;
  final DateTime firstSeenAt;
  final DateTime updatedAt;
  final String sourceState;
  final bool requiresIdentityReview;
  const HomeworkItemsData({
    required this.id,
    required this.profileId,
    this.sourceRecordId,
    this.subjectId,
    required this.nestedIdentity,
    this.sourceItemId,
    required this.identityConfidence,
    required this.origin,
    required this.body,
    this.personalNote,
    this.assignedOn,
    required this.contentRevision,
    required this.firstSeenAt,
    required this.updatedAt,
    required this.sourceState,
    required this.requiresIdentityReview,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || sourceRecordId != null) {
      map['source_record_id'] = Variable<String>(sourceRecordId);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<String>(subjectId);
    }
    map['nested_identity'] = Variable<String>(nestedIdentity);
    if (!nullToAbsent || sourceItemId != null) {
      map['source_item_id'] = Variable<String>(sourceItemId);
    }
    map['identity_confidence'] = Variable<String>(identityConfidence);
    map['origin'] = Variable<String>(origin);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || personalNote != null) {
      map['personal_note'] = Variable<String>(personalNote);
    }
    if (!nullToAbsent || assignedOn != null) {
      map['assigned_on'] = Variable<String>(assignedOn);
    }
    map['content_revision'] = Variable<String>(contentRevision);
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['source_state'] = Variable<String>(sourceState);
    map['requires_identity_review'] = Variable<bool>(requiresIdentityReview);
    return map;
  }

  HomeworkItemsCompanion toCompanion(bool nullToAbsent) {
    return HomeworkItemsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      sourceRecordId: sourceRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecordId),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      nestedIdentity: Value(nestedIdentity),
      sourceItemId: sourceItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceItemId),
      identityConfidence: Value(identityConfidence),
      origin: Value(origin),
      body: Value(body),
      personalNote: personalNote == null && nullToAbsent
          ? const Value.absent()
          : Value(personalNote),
      assignedOn: assignedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedOn),
      contentRevision: Value(contentRevision),
      firstSeenAt: Value(firstSeenAt),
      updatedAt: Value(updatedAt),
      sourceState: Value(sourceState),
      requiresIdentityReview: Value(requiresIdentityReview),
    );
  }

  factory HomeworkItemsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeworkItemsData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      sourceRecordId: serializer.fromJson<String?>(json['sourceRecordId']),
      subjectId: serializer.fromJson<String?>(json['subjectId']),
      nestedIdentity: serializer.fromJson<String>(json['nestedIdentity']),
      sourceItemId: serializer.fromJson<String?>(json['sourceItemId']),
      identityConfidence: serializer.fromJson<String>(
        json['identityConfidence'],
      ),
      origin: serializer.fromJson<String>(json['origin']),
      body: serializer.fromJson<String>(json['body']),
      personalNote: serializer.fromJson<String?>(json['personalNote']),
      assignedOn: serializer.fromJson<String?>(json['assignedOn']),
      contentRevision: serializer.fromJson<String>(json['contentRevision']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sourceState: serializer.fromJson<String>(json['sourceState']),
      requiresIdentityReview: serializer.fromJson<bool>(
        json['requiresIdentityReview'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'sourceRecordId': serializer.toJson<String?>(sourceRecordId),
      'subjectId': serializer.toJson<String?>(subjectId),
      'nestedIdentity': serializer.toJson<String>(nestedIdentity),
      'sourceItemId': serializer.toJson<String?>(sourceItemId),
      'identityConfidence': serializer.toJson<String>(identityConfidence),
      'origin': serializer.toJson<String>(origin),
      'body': serializer.toJson<String>(body),
      'personalNote': serializer.toJson<String?>(personalNote),
      'assignedOn': serializer.toJson<String?>(assignedOn),
      'contentRevision': serializer.toJson<String>(contentRevision),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sourceState': serializer.toJson<String>(sourceState),
      'requiresIdentityReview': serializer.toJson<bool>(requiresIdentityReview),
    };
  }

  HomeworkItemsData copyWith({
    String? id,
    String? profileId,
    Value<String?> sourceRecordId = const Value.absent(),
    Value<String?> subjectId = const Value.absent(),
    String? nestedIdentity,
    Value<String?> sourceItemId = const Value.absent(),
    String? identityConfidence,
    String? origin,
    String? body,
    Value<String?> personalNote = const Value.absent(),
    Value<String?> assignedOn = const Value.absent(),
    String? contentRevision,
    DateTime? firstSeenAt,
    DateTime? updatedAt,
    String? sourceState,
    bool? requiresIdentityReview,
  }) => HomeworkItemsData(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    sourceRecordId: sourceRecordId.present
        ? sourceRecordId.value
        : this.sourceRecordId,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    nestedIdentity: nestedIdentity ?? this.nestedIdentity,
    sourceItemId: sourceItemId.present ? sourceItemId.value : this.sourceItemId,
    identityConfidence: identityConfidence ?? this.identityConfidence,
    origin: origin ?? this.origin,
    body: body ?? this.body,
    personalNote: personalNote.present ? personalNote.value : this.personalNote,
    assignedOn: assignedOn.present ? assignedOn.value : this.assignedOn,
    contentRevision: contentRevision ?? this.contentRevision,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sourceState: sourceState ?? this.sourceState,
    requiresIdentityReview:
        requiresIdentityReview ?? this.requiresIdentityReview,
  );
  HomeworkItemsData copyWithCompanion(HomeworkItemsCompanion data) {
    return HomeworkItemsData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      nestedIdentity: data.nestedIdentity.present
          ? data.nestedIdentity.value
          : this.nestedIdentity,
      sourceItemId: data.sourceItemId.present
          ? data.sourceItemId.value
          : this.sourceItemId,
      identityConfidence: data.identityConfidence.present
          ? data.identityConfidence.value
          : this.identityConfidence,
      origin: data.origin.present ? data.origin.value : this.origin,
      body: data.body.present ? data.body.value : this.body,
      personalNote: data.personalNote.present
          ? data.personalNote.value
          : this.personalNote,
      assignedOn: data.assignedOn.present
          ? data.assignedOn.value
          : this.assignedOn,
      contentRevision: data.contentRevision.present
          ? data.contentRevision.value
          : this.contentRevision,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sourceState: data.sourceState.present
          ? data.sourceState.value
          : this.sourceState,
      requiresIdentityReview: data.requiresIdentityReview.present
          ? data.requiresIdentityReview.value
          : this.requiresIdentityReview,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeworkItemsData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('subjectId: $subjectId, ')
          ..write('nestedIdentity: $nestedIdentity, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('identityConfidence: $identityConfidence, ')
          ..write('origin: $origin, ')
          ..write('body: $body, ')
          ..write('personalNote: $personalNote, ')
          ..write('assignedOn: $assignedOn, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceState: $sourceState, ')
          ..write('requiresIdentityReview: $requiresIdentityReview')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    sourceRecordId,
    subjectId,
    nestedIdentity,
    sourceItemId,
    identityConfidence,
    origin,
    body,
    personalNote,
    assignedOn,
    contentRevision,
    firstSeenAt,
    updatedAt,
    sourceState,
    requiresIdentityReview,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeworkItemsData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.sourceRecordId == this.sourceRecordId &&
          other.subjectId == this.subjectId &&
          other.nestedIdentity == this.nestedIdentity &&
          other.sourceItemId == this.sourceItemId &&
          other.identityConfidence == this.identityConfidence &&
          other.origin == this.origin &&
          other.body == this.body &&
          other.personalNote == this.personalNote &&
          other.assignedOn == this.assignedOn &&
          other.contentRevision == this.contentRevision &&
          other.firstSeenAt == this.firstSeenAt &&
          other.updatedAt == this.updatedAt &&
          other.sourceState == this.sourceState &&
          other.requiresIdentityReview == this.requiresIdentityReview);
}

class HomeworkItemsCompanion extends UpdateCompanion<HomeworkItemsData> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String?> sourceRecordId;
  final Value<String?> subjectId;
  final Value<String> nestedIdentity;
  final Value<String?> sourceItemId;
  final Value<String> identityConfidence;
  final Value<String> origin;
  final Value<String> body;
  final Value<String?> personalNote;
  final Value<String?> assignedOn;
  final Value<String> contentRevision;
  final Value<DateTime> firstSeenAt;
  final Value<DateTime> updatedAt;
  final Value<String> sourceState;
  final Value<bool> requiresIdentityReview;
  final Value<int> rowid;
  const HomeworkItemsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.nestedIdentity = const Value.absent(),
    this.sourceItemId = const Value.absent(),
    this.identityConfidence = const Value.absent(),
    this.origin = const Value.absent(),
    this.body = const Value.absent(),
    this.personalNote = const Value.absent(),
    this.assignedOn = const Value.absent(),
    this.contentRevision = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sourceState = const Value.absent(),
    this.requiresIdentityReview = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeworkItemsCompanion.insert({
    required String id,
    required String profileId,
    this.sourceRecordId = const Value.absent(),
    this.subjectId = const Value.absent(),
    required String nestedIdentity,
    this.sourceItemId = const Value.absent(),
    required String identityConfidence,
    required String origin,
    required String body,
    this.personalNote = const Value.absent(),
    this.assignedOn = const Value.absent(),
    required String contentRevision,
    required DateTime firstSeenAt,
    required DateTime updatedAt,
    this.sourceState = const Value.absent(),
    this.requiresIdentityReview = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       nestedIdentity = Value(nestedIdentity),
       identityConfidence = Value(identityConfidence),
       origin = Value(origin),
       body = Value(body),
       contentRevision = Value(contentRevision),
       firstSeenAt = Value(firstSeenAt),
       updatedAt = Value(updatedAt);
  static Insertable<HomeworkItemsData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? sourceRecordId,
    Expression<String>? subjectId,
    Expression<String>? nestedIdentity,
    Expression<String>? sourceItemId,
    Expression<String>? identityConfidence,
    Expression<String>? origin,
    Expression<String>? body,
    Expression<String>? personalNote,
    Expression<String>? assignedOn,
    Expression<String>? contentRevision,
    Expression<DateTime>? firstSeenAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? sourceState,
    Expression<bool>? requiresIdentityReview,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (subjectId != null) 'subject_id': subjectId,
      if (nestedIdentity != null) 'nested_identity': nestedIdentity,
      if (sourceItemId != null) 'source_item_id': sourceItemId,
      if (identityConfidence != null) 'identity_confidence': identityConfidence,
      if (origin != null) 'origin': origin,
      if (body != null) 'body': body,
      if (personalNote != null) 'personal_note': personalNote,
      if (assignedOn != null) 'assigned_on': assignedOn,
      if (contentRevision != null) 'content_revision': contentRevision,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sourceState != null) 'source_state': sourceState,
      if (requiresIdentityReview != null)
        'requires_identity_review': requiresIdentityReview,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeworkItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String?>? sourceRecordId,
    Value<String?>? subjectId,
    Value<String>? nestedIdentity,
    Value<String?>? sourceItemId,
    Value<String>? identityConfidence,
    Value<String>? origin,
    Value<String>? body,
    Value<String?>? personalNote,
    Value<String?>? assignedOn,
    Value<String>? contentRevision,
    Value<DateTime>? firstSeenAt,
    Value<DateTime>? updatedAt,
    Value<String>? sourceState,
    Value<bool>? requiresIdentityReview,
    Value<int>? rowid,
  }) {
    return HomeworkItemsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      subjectId: subjectId ?? this.subjectId,
      nestedIdentity: nestedIdentity ?? this.nestedIdentity,
      sourceItemId: sourceItemId ?? this.sourceItemId,
      identityConfidence: identityConfidence ?? this.identityConfidence,
      origin: origin ?? this.origin,
      body: body ?? this.body,
      personalNote: personalNote ?? this.personalNote,
      assignedOn: assignedOn ?? this.assignedOn,
      contentRevision: contentRevision ?? this.contentRevision,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceState: sourceState ?? this.sourceState,
      requiresIdentityReview:
          requiresIdentityReview ?? this.requiresIdentityReview,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (nestedIdentity.present) {
      map['nested_identity'] = Variable<String>(nestedIdentity.value);
    }
    if (sourceItemId.present) {
      map['source_item_id'] = Variable<String>(sourceItemId.value);
    }
    if (identityConfidence.present) {
      map['identity_confidence'] = Variable<String>(identityConfidence.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (personalNote.present) {
      map['personal_note'] = Variable<String>(personalNote.value);
    }
    if (assignedOn.present) {
      map['assigned_on'] = Variable<String>(assignedOn.value);
    }
    if (contentRevision.present) {
      map['content_revision'] = Variable<String>(contentRevision.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sourceState.present) {
      map['source_state'] = Variable<String>(sourceState.value);
    }
    if (requiresIdentityReview.present) {
      map['requires_identity_review'] = Variable<bool>(
        requiresIdentityReview.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeworkItemsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('subjectId: $subjectId, ')
          ..write('nestedIdentity: $nestedIdentity, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('identityConfidence: $identityConfidence, ')
          ..write('origin: $origin, ')
          ..write('body: $body, ')
          ..write('personalNote: $personalNote, ')
          ..write('assignedOn: $assignedOn, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceState: $sourceState, ')
          ..write('requiresIdentityReview: $requiresIdentityReview, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Deadlines extends Table with TableInfo<Deadlines, DeadlinesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Deadlines(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> homeworkId = GeneratedColumn<String>(
    'homework_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES homework_items (id)',
    ),
  );
  late final GeneratedColumn<String> sourceDueOn = GeneratedColumn<String>(
    'source_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> personalDueOn = GeneratedColumn<String>(
    'personal_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> sourceTime = GeneratedColumn<String>(
    'source_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> schoolTimeZone = GeneratedColumn<String>(
    'school_time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'Europe/Rome\''),
  );
  late final GeneratedColumn<String> precision = GeneratedColumn<String>(
    'precision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'date\''),
  );
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'argo\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeworkId,
    sourceDueOn,
    personalDueOn,
    sourceTime,
    schoolTimeZone,
    precision,
    provenance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deadlines';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeadlinesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeadlinesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      homeworkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homework_id'],
      )!,
      sourceDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_due_on'],
      ),
      personalDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_due_on'],
      ),
      sourceTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_time'],
      ),
      schoolTimeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_time_zone'],
      )!,
      precision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}precision'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
    );
  }

  @override
  Deadlines createAlias(String alias) {
    return Deadlines(attachedDatabase, alias);
  }
}

class DeadlinesData extends DataClass implements Insertable<DeadlinesData> {
  final String id;
  final String homeworkId;
  final String? sourceDueOn;
  final String? personalDueOn;
  final String? sourceTime;
  final String schoolTimeZone;
  final String precision;
  final String provenance;
  const DeadlinesData({
    required this.id,
    required this.homeworkId,
    this.sourceDueOn,
    this.personalDueOn,
    this.sourceTime,
    required this.schoolTimeZone,
    required this.precision,
    required this.provenance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['homework_id'] = Variable<String>(homeworkId);
    if (!nullToAbsent || sourceDueOn != null) {
      map['source_due_on'] = Variable<String>(sourceDueOn);
    }
    if (!nullToAbsent || personalDueOn != null) {
      map['personal_due_on'] = Variable<String>(personalDueOn);
    }
    if (!nullToAbsent || sourceTime != null) {
      map['source_time'] = Variable<String>(sourceTime);
    }
    map['school_time_zone'] = Variable<String>(schoolTimeZone);
    map['precision'] = Variable<String>(precision);
    map['provenance'] = Variable<String>(provenance);
    return map;
  }

  DeadlinesCompanion toCompanion(bool nullToAbsent) {
    return DeadlinesCompanion(
      id: Value(id),
      homeworkId: Value(homeworkId),
      sourceDueOn: sourceDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDueOn),
      personalDueOn: personalDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(personalDueOn),
      sourceTime: sourceTime == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTime),
      schoolTimeZone: Value(schoolTimeZone),
      precision: Value(precision),
      provenance: Value(provenance),
    );
  }

  factory DeadlinesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeadlinesData(
      id: serializer.fromJson<String>(json['id']),
      homeworkId: serializer.fromJson<String>(json['homeworkId']),
      sourceDueOn: serializer.fromJson<String?>(json['sourceDueOn']),
      personalDueOn: serializer.fromJson<String?>(json['personalDueOn']),
      sourceTime: serializer.fromJson<String?>(json['sourceTime']),
      schoolTimeZone: serializer.fromJson<String>(json['schoolTimeZone']),
      precision: serializer.fromJson<String>(json['precision']),
      provenance: serializer.fromJson<String>(json['provenance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'homeworkId': serializer.toJson<String>(homeworkId),
      'sourceDueOn': serializer.toJson<String?>(sourceDueOn),
      'personalDueOn': serializer.toJson<String?>(personalDueOn),
      'sourceTime': serializer.toJson<String?>(sourceTime),
      'schoolTimeZone': serializer.toJson<String>(schoolTimeZone),
      'precision': serializer.toJson<String>(precision),
      'provenance': serializer.toJson<String>(provenance),
    };
  }

  DeadlinesData copyWith({
    String? id,
    String? homeworkId,
    Value<String?> sourceDueOn = const Value.absent(),
    Value<String?> personalDueOn = const Value.absent(),
    Value<String?> sourceTime = const Value.absent(),
    String? schoolTimeZone,
    String? precision,
    String? provenance,
  }) => DeadlinesData(
    id: id ?? this.id,
    homeworkId: homeworkId ?? this.homeworkId,
    sourceDueOn: sourceDueOn.present ? sourceDueOn.value : this.sourceDueOn,
    personalDueOn: personalDueOn.present
        ? personalDueOn.value
        : this.personalDueOn,
    sourceTime: sourceTime.present ? sourceTime.value : this.sourceTime,
    schoolTimeZone: schoolTimeZone ?? this.schoolTimeZone,
    precision: precision ?? this.precision,
    provenance: provenance ?? this.provenance,
  );
  DeadlinesData copyWithCompanion(DeadlinesCompanion data) {
    return DeadlinesData(
      id: data.id.present ? data.id.value : this.id,
      homeworkId: data.homeworkId.present
          ? data.homeworkId.value
          : this.homeworkId,
      sourceDueOn: data.sourceDueOn.present
          ? data.sourceDueOn.value
          : this.sourceDueOn,
      personalDueOn: data.personalDueOn.present
          ? data.personalDueOn.value
          : this.personalDueOn,
      sourceTime: data.sourceTime.present
          ? data.sourceTime.value
          : this.sourceTime,
      schoolTimeZone: data.schoolTimeZone.present
          ? data.schoolTimeZone.value
          : this.schoolTimeZone,
      precision: data.precision.present ? data.precision.value : this.precision,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeadlinesData(')
          ..write('id: $id, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('sourceDueOn: $sourceDueOn, ')
          ..write('personalDueOn: $personalDueOn, ')
          ..write('sourceTime: $sourceTime, ')
          ..write('schoolTimeZone: $schoolTimeZone, ')
          ..write('precision: $precision, ')
          ..write('provenance: $provenance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    homeworkId,
    sourceDueOn,
    personalDueOn,
    sourceTime,
    schoolTimeZone,
    precision,
    provenance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeadlinesData &&
          other.id == this.id &&
          other.homeworkId == this.homeworkId &&
          other.sourceDueOn == this.sourceDueOn &&
          other.personalDueOn == this.personalDueOn &&
          other.sourceTime == this.sourceTime &&
          other.schoolTimeZone == this.schoolTimeZone &&
          other.precision == this.precision &&
          other.provenance == this.provenance);
}

class DeadlinesCompanion extends UpdateCompanion<DeadlinesData> {
  final Value<String> id;
  final Value<String> homeworkId;
  final Value<String?> sourceDueOn;
  final Value<String?> personalDueOn;
  final Value<String?> sourceTime;
  final Value<String> schoolTimeZone;
  final Value<String> precision;
  final Value<String> provenance;
  final Value<int> rowid;
  const DeadlinesCompanion({
    this.id = const Value.absent(),
    this.homeworkId = const Value.absent(),
    this.sourceDueOn = const Value.absent(),
    this.personalDueOn = const Value.absent(),
    this.sourceTime = const Value.absent(),
    this.schoolTimeZone = const Value.absent(),
    this.precision = const Value.absent(),
    this.provenance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeadlinesCompanion.insert({
    required String id,
    required String homeworkId,
    this.sourceDueOn = const Value.absent(),
    this.personalDueOn = const Value.absent(),
    this.sourceTime = const Value.absent(),
    this.schoolTimeZone = const Value.absent(),
    this.precision = const Value.absent(),
    this.provenance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       homeworkId = Value(homeworkId);
  static Insertable<DeadlinesData> custom({
    Expression<String>? id,
    Expression<String>? homeworkId,
    Expression<String>? sourceDueOn,
    Expression<String>? personalDueOn,
    Expression<String>? sourceTime,
    Expression<String>? schoolTimeZone,
    Expression<String>? precision,
    Expression<String>? provenance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeworkId != null) 'homework_id': homeworkId,
      if (sourceDueOn != null) 'source_due_on': sourceDueOn,
      if (personalDueOn != null) 'personal_due_on': personalDueOn,
      if (sourceTime != null) 'source_time': sourceTime,
      if (schoolTimeZone != null) 'school_time_zone': schoolTimeZone,
      if (precision != null) 'precision': precision,
      if (provenance != null) 'provenance': provenance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeadlinesCompanion copyWith({
    Value<String>? id,
    Value<String>? homeworkId,
    Value<String?>? sourceDueOn,
    Value<String?>? personalDueOn,
    Value<String?>? sourceTime,
    Value<String>? schoolTimeZone,
    Value<String>? precision,
    Value<String>? provenance,
    Value<int>? rowid,
  }) {
    return DeadlinesCompanion(
      id: id ?? this.id,
      homeworkId: homeworkId ?? this.homeworkId,
      sourceDueOn: sourceDueOn ?? this.sourceDueOn,
      personalDueOn: personalDueOn ?? this.personalDueOn,
      sourceTime: sourceTime ?? this.sourceTime,
      schoolTimeZone: schoolTimeZone ?? this.schoolTimeZone,
      precision: precision ?? this.precision,
      provenance: provenance ?? this.provenance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (homeworkId.present) {
      map['homework_id'] = Variable<String>(homeworkId.value);
    }
    if (sourceDueOn.present) {
      map['source_due_on'] = Variable<String>(sourceDueOn.value);
    }
    if (personalDueOn.present) {
      map['personal_due_on'] = Variable<String>(personalDueOn.value);
    }
    if (sourceTime.present) {
      map['source_time'] = Variable<String>(sourceTime.value);
    }
    if (schoolTimeZone.present) {
      map['school_time_zone'] = Variable<String>(schoolTimeZone.value);
    }
    if (precision.present) {
      map['precision'] = Variable<String>(precision.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeadlinesCompanion(')
          ..write('id: $id, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('sourceDueOn: $sourceDueOn, ')
          ..write('personalDueOn: $personalDueOn, ')
          ..write('sourceTime: $sourceTime, ')
          ..write('schoolTimeZone: $schoolTimeZone, ')
          ..write('precision: $precision, ')
          ..write('provenance: $provenance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Completions extends Table with TableInfo<Completions, CompletionsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Completions(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_users (id)',
    ),
  );
  late final GeneratedColumn<String> homeworkId = GeneratedColumn<String>(
    'homework_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES homework_items (id)',
    ),
  );
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> completedRevision =
      GeneratedColumn<String>(
        'completed_revision',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    homeworkId,
    isDone,
    doneAt,
    completedRevision,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions';
  @override
  Set<GeneratedColumn> get $primaryKey => {userId, homeworkId};
  @override
  CompletionsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletionsData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      homeworkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homework_id'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
      completedRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_revision'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  Completions createAlias(String alias) {
    return Completions(attachedDatabase, alias);
  }
}

class CompletionsData extends DataClass implements Insertable<CompletionsData> {
  final String userId;
  final String homeworkId;
  final bool isDone;
  final DateTime? doneAt;
  final String? completedRevision;
  final DateTime updatedAt;
  const CompletionsData({
    required this.userId,
    required this.homeworkId,
    required this.isDone,
    this.doneAt,
    this.completedRevision,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['homework_id'] = Variable<String>(homeworkId);
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    if (!nullToAbsent || completedRevision != null) {
      map['completed_revision'] = Variable<String>(completedRevision);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CompletionsCompanion toCompanion(bool nullToAbsent) {
    return CompletionsCompanion(
      userId: Value(userId),
      homeworkId: Value(homeworkId),
      isDone: Value(isDone),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      completedRevision: completedRevision == null && nullToAbsent
          ? const Value.absent()
          : Value(completedRevision),
      updatedAt: Value(updatedAt),
    );
  }

  factory CompletionsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletionsData(
      userId: serializer.fromJson<String>(json['userId']),
      homeworkId: serializer.fromJson<String>(json['homeworkId']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
      completedRevision: serializer.fromJson<String?>(
        json['completedRevision'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'homeworkId': serializer.toJson<String>(homeworkId),
      'isDone': serializer.toJson<bool>(isDone),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
      'completedRevision': serializer.toJson<String?>(completedRevision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CompletionsData copyWith({
    String? userId,
    String? homeworkId,
    bool? isDone,
    Value<DateTime?> doneAt = const Value.absent(),
    Value<String?> completedRevision = const Value.absent(),
    DateTime? updatedAt,
  }) => CompletionsData(
    userId: userId ?? this.userId,
    homeworkId: homeworkId ?? this.homeworkId,
    isDone: isDone ?? this.isDone,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    completedRevision: completedRevision.present
        ? completedRevision.value
        : this.completedRevision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CompletionsData copyWithCompanion(CompletionsCompanion data) {
    return CompletionsData(
      userId: data.userId.present ? data.userId.value : this.userId,
      homeworkId: data.homeworkId.present
          ? data.homeworkId.value
          : this.homeworkId,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      completedRevision: data.completedRevision.present
          ? data.completedRevision.value
          : this.completedRevision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsData(')
          ..write('userId: $userId, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('completedRevision: $completedRevision, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    homeworkId,
    isDone,
    doneAt,
    completedRevision,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletionsData &&
          other.userId == this.userId &&
          other.homeworkId == this.homeworkId &&
          other.isDone == this.isDone &&
          other.doneAt == this.doneAt &&
          other.completedRevision == this.completedRevision &&
          other.updatedAt == this.updatedAt);
}

class CompletionsCompanion extends UpdateCompanion<CompletionsData> {
  final Value<String> userId;
  final Value<String> homeworkId;
  final Value<bool> isDone;
  final Value<DateTime?> doneAt;
  final Value<String?> completedRevision;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CompletionsCompanion({
    this.userId = const Value.absent(),
    this.homeworkId = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.completedRevision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletionsCompanion.insert({
    required String userId,
    required String homeworkId,
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.completedRevision = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       homeworkId = Value(homeworkId),
       updatedAt = Value(updatedAt);
  static Insertable<CompletionsData> custom({
    Expression<String>? userId,
    Expression<String>? homeworkId,
    Expression<bool>? isDone,
    Expression<DateTime>? doneAt,
    Expression<String>? completedRevision,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (homeworkId != null) 'homework_id': homeworkId,
      if (isDone != null) 'is_done': isDone,
      if (doneAt != null) 'done_at': doneAt,
      if (completedRevision != null) 'completed_revision': completedRevision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletionsCompanion copyWith({
    Value<String>? userId,
    Value<String>? homeworkId,
    Value<bool>? isDone,
    Value<DateTime?>? doneAt,
    Value<String?>? completedRevision,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CompletionsCompanion(
      userId: userId ?? this.userId,
      homeworkId: homeworkId ?? this.homeworkId,
      isDone: isDone ?? this.isDone,
      doneAt: doneAt ?? this.doneAt,
      completedRevision: completedRevision ?? this.completedRevision,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (homeworkId.present) {
      map['homework_id'] = Variable<String>(homeworkId.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (completedRevision.present) {
      map['completed_revision'] = Variable<String>(completedRevision.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsCompanion(')
          ..write('userId: $userId, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('completedRevision: $completedRevision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Reminders extends Table with TableInfo<Reminders, RemindersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Reminders(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_users (id)',
    ),
  );
  late final GeneratedColumn<String> homeworkId = GeneratedColumn<String>(
    'homework_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES homework_items (id)',
    ),
  );
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'scheduled\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    homeworkId,
    remindAt,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      homeworkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homework_id'],
      )!,
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  Reminders createAlias(String alias) {
    return Reminders(attachedDatabase, alias);
  }
}

class RemindersData extends DataClass implements Insertable<RemindersData> {
  final String id;
  final String userId;
  final String homeworkId;
  final DateTime remindAt;
  final String state;
  const RemindersData({
    required this.id,
    required this.userId,
    required this.homeworkId,
    required this.remindAt,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['homework_id'] = Variable<String>(homeworkId);
    map['remind_at'] = Variable<DateTime>(remindAt);
    map['state'] = Variable<String>(state);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      userId: Value(userId),
      homeworkId: Value(homeworkId),
      remindAt: Value(remindAt),
      state: Value(state),
    );
  }

  factory RemindersData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      homeworkId: serializer.fromJson<String>(json['homeworkId']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      state: serializer.fromJson<String>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'homeworkId': serializer.toJson<String>(homeworkId),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'state': serializer.toJson<String>(state),
    };
  }

  RemindersData copyWith({
    String? id,
    String? userId,
    String? homeworkId,
    DateTime? remindAt,
    String? state,
  }) => RemindersData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    homeworkId: homeworkId ?? this.homeworkId,
    remindAt: remindAt ?? this.remindAt,
    state: state ?? this.state,
  );
  RemindersData copyWithCompanion(RemindersCompanion data) {
    return RemindersData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      homeworkId: data.homeworkId.present
          ? data.homeworkId.value
          : this.homeworkId,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('remindAt: $remindAt, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, homeworkId, remindAt, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.homeworkId == this.homeworkId &&
          other.remindAt == this.remindAt &&
          other.state == this.state);
}

class RemindersCompanion extends UpdateCompanion<RemindersData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> homeworkId;
  final Value<DateTime> remindAt;
  final Value<String> state;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.homeworkId = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String userId,
    required String homeworkId,
    required DateTime remindAt,
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       homeworkId = Value(homeworkId),
       remindAt = Value(remindAt);
  static Insertable<RemindersData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? homeworkId,
    Expression<DateTime>? remindAt,
    Expression<String>? state,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (homeworkId != null) 'homework_id': homeworkId,
      if (remindAt != null) 'remind_at': remindAt,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? homeworkId,
    Value<DateTime>? remindAt,
    Value<String>? state,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      homeworkId: homeworkId ?? this.homeworkId,
      remindAt: remindAt ?? this.remindAt,
      state: state ?? this.state,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (homeworkId.present) {
      map['homework_id'] = Variable<String>(homeworkId.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('remindAt: $remindAt, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SyncStates extends Table with TableInfo<SyncStates, SyncStatesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncStates(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES student_profiles (id)',
    ),
  );
  late final GeneratedColumn<String> adapterVersion = GeneratedColumn<String>(
    'adapter_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>(
        'last_success_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<DateTime> coverageStart =
      GeneratedColumn<DateTime>(
        'coverage_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    adapterVersion,
    cursor,
    lastAttemptAt,
    lastSuccessAt,
    coverageStart,
    errorCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_states';
  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  SyncStatesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStatesData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      adapterVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adapter_version'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      lastSuccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_success_at'],
      ),
      coverageStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}coverage_start'],
      ),
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
    );
  }

  @override
  SyncStates createAlias(String alias) {
    return SyncStates(attachedDatabase, alias);
  }
}

class SyncStatesData extends DataClass implements Insertable<SyncStatesData> {
  final String profileId;
  final String adapterVersion;
  final String? cursor;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? coverageStart;
  final String? errorCode;
  const SyncStatesData({
    required this.profileId,
    required this.adapterVersion,
    this.cursor,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.coverageStart,
    this.errorCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['adapter_version'] = Variable<String>(adapterVersion);
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt);
    }
    if (!nullToAbsent || coverageStart != null) {
      map['coverage_start'] = Variable<DateTime>(coverageStart);
    }
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    return map;
  }

  SyncStatesCompanion toCompanion(bool nullToAbsent) {
    return SyncStatesCompanion(
      profileId: Value(profileId),
      adapterVersion: Value(adapterVersion),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      coverageStart: coverageStart == null && nullToAbsent
          ? const Value.absent()
          : Value(coverageStart),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
    );
  }

  factory SyncStatesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStatesData(
      profileId: serializer.fromJson<String>(json['profileId']),
      adapterVersion: serializer.fromJson<String>(json['adapterVersion']),
      cursor: serializer.fromJson<String?>(json['cursor']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      lastSuccessAt: serializer.fromJson<DateTime?>(json['lastSuccessAt']),
      coverageStart: serializer.fromJson<DateTime?>(json['coverageStart']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'adapterVersion': serializer.toJson<String>(adapterVersion),
      'cursor': serializer.toJson<String?>(cursor),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'lastSuccessAt': serializer.toJson<DateTime?>(lastSuccessAt),
      'coverageStart': serializer.toJson<DateTime?>(coverageStart),
      'errorCode': serializer.toJson<String?>(errorCode),
    };
  }

  SyncStatesData copyWith({
    String? profileId,
    String? adapterVersion,
    Value<String?> cursor = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<DateTime?> lastSuccessAt = const Value.absent(),
    Value<DateTime?> coverageStart = const Value.absent(),
    Value<String?> errorCode = const Value.absent(),
  }) => SyncStatesData(
    profileId: profileId ?? this.profileId,
    adapterVersion: adapterVersion ?? this.adapterVersion,
    cursor: cursor.present ? cursor.value : this.cursor,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    lastSuccessAt: lastSuccessAt.present
        ? lastSuccessAt.value
        : this.lastSuccessAt,
    coverageStart: coverageStart.present
        ? coverageStart.value
        : this.coverageStart,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
  );
  SyncStatesData copyWithCompanion(SyncStatesCompanion data) {
    return SyncStatesData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      adapterVersion: data.adapterVersion.present
          ? data.adapterVersion.value
          : this.adapterVersion,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      coverageStart: data.coverageStart.present
          ? data.coverageStart.value
          : this.coverageStart,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesData(')
          ..write('profileId: $profileId, ')
          ..write('adapterVersion: $adapterVersion, ')
          ..write('cursor: $cursor, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('coverageStart: $coverageStart, ')
          ..write('errorCode: $errorCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    adapterVersion,
    cursor,
    lastAttemptAt,
    lastSuccessAt,
    coverageStart,
    errorCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStatesData &&
          other.profileId == this.profileId &&
          other.adapterVersion == this.adapterVersion &&
          other.cursor == this.cursor &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.coverageStart == this.coverageStart &&
          other.errorCode == this.errorCode);
}

class SyncStatesCompanion extends UpdateCompanion<SyncStatesData> {
  final Value<String> profileId;
  final Value<String> adapterVersion;
  final Value<String?> cursor;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime?> lastSuccessAt;
  final Value<DateTime?> coverageStart;
  final Value<String?> errorCode;
  final Value<int> rowid;
  const SyncStatesCompanion({
    this.profileId = const Value.absent(),
    this.adapterVersion = const Value.absent(),
    this.cursor = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.coverageStart = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStatesCompanion.insert({
    required String profileId,
    required String adapterVersion,
    this.cursor = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.coverageStart = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       adapterVersion = Value(adapterVersion);
  static Insertable<SyncStatesData> custom({
    Expression<String>? profileId,
    Expression<String>? adapterVersion,
    Expression<String>? cursor,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? lastSuccessAt,
    Expression<DateTime>? coverageStart,
    Expression<String>? errorCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (adapterVersion != null) 'adapter_version': adapterVersion,
      if (cursor != null) 'cursor': cursor,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (coverageStart != null) 'coverage_start': coverageStart,
      if (errorCode != null) 'error_code': errorCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStatesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? adapterVersion,
    Value<String?>? cursor,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime?>? lastSuccessAt,
    Value<DateTime?>? coverageStart,
    Value<String?>? errorCode,
    Value<int>? rowid,
  }) {
    return SyncStatesCompanion(
      profileId: profileId ?? this.profileId,
      adapterVersion: adapterVersion ?? this.adapterVersion,
      cursor: cursor ?? this.cursor,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      coverageStart: coverageStart ?? this.coverageStart,
      errorCode: errorCode ?? this.errorCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (adapterVersion.present) {
      map['adapter_version'] = Variable<String>(adapterVersion.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt.value);
    }
    if (coverageStart.present) {
      map['coverage_start'] = Variable<DateTime>(coverageStart.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('adapterVersion: $adapterVersion, ')
          ..write('cursor: $cursor, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('coverageStart: $coverageStart, ')
          ..write('errorCode: $errorCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HomeworkIdentityMappings extends Table
    with TableInfo<HomeworkIdentityMappings, HomeworkIdentityMappingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HomeworkIdentityMappings(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES student_profiles (id)',
    ),
  );
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> nestedIdentity = GeneratedColumn<String>(
    'nested_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> homeworkId = GeneratedColumn<String>(
    'homework_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> contentRevision = GeneratedColumn<String>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    sourceRecordId,
    nestedIdentity,
    homeworkId,
    contentRevision,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'homework_identity_mappings';
  @override
  Set<GeneratedColumn> get $primaryKey => {
    profileId,
    sourceRecordId,
    nestedIdentity,
  };
  @override
  HomeworkIdentityMappingsData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeworkIdentityMappingsData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      )!,
      nestedIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nested_identity'],
      )!,
      homeworkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homework_id'],
      )!,
      contentRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_revision'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  HomeworkIdentityMappings createAlias(String alias) {
    return HomeworkIdentityMappings(attachedDatabase, alias);
  }
}

class HomeworkIdentityMappingsData extends DataClass
    implements Insertable<HomeworkIdentityMappingsData> {
  final String profileId;
  final String sourceRecordId;
  final String nestedIdentity;
  final String homeworkId;
  final String contentRevision;
  final DateTime updatedAt;
  const HomeworkIdentityMappingsData({
    required this.profileId,
    required this.sourceRecordId,
    required this.nestedIdentity,
    required this.homeworkId,
    required this.contentRevision,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['source_record_id'] = Variable<String>(sourceRecordId);
    map['nested_identity'] = Variable<String>(nestedIdentity);
    map['homework_id'] = Variable<String>(homeworkId);
    map['content_revision'] = Variable<String>(contentRevision);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HomeworkIdentityMappingsCompanion toCompanion(bool nullToAbsent) {
    return HomeworkIdentityMappingsCompanion(
      profileId: Value(profileId),
      sourceRecordId: Value(sourceRecordId),
      nestedIdentity: Value(nestedIdentity),
      homeworkId: Value(homeworkId),
      contentRevision: Value(contentRevision),
      updatedAt: Value(updatedAt),
    );
  }

  factory HomeworkIdentityMappingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeworkIdentityMappingsData(
      profileId: serializer.fromJson<String>(json['profileId']),
      sourceRecordId: serializer.fromJson<String>(json['sourceRecordId']),
      nestedIdentity: serializer.fromJson<String>(json['nestedIdentity']),
      homeworkId: serializer.fromJson<String>(json['homeworkId']),
      contentRevision: serializer.fromJson<String>(json['contentRevision']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'sourceRecordId': serializer.toJson<String>(sourceRecordId),
      'nestedIdentity': serializer.toJson<String>(nestedIdentity),
      'homeworkId': serializer.toJson<String>(homeworkId),
      'contentRevision': serializer.toJson<String>(contentRevision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HomeworkIdentityMappingsData copyWith({
    String? profileId,
    String? sourceRecordId,
    String? nestedIdentity,
    String? homeworkId,
    String? contentRevision,
    DateTime? updatedAt,
  }) => HomeworkIdentityMappingsData(
    profileId: profileId ?? this.profileId,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    nestedIdentity: nestedIdentity ?? this.nestedIdentity,
    homeworkId: homeworkId ?? this.homeworkId,
    contentRevision: contentRevision ?? this.contentRevision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HomeworkIdentityMappingsData copyWithCompanion(
    HomeworkIdentityMappingsCompanion data,
  ) {
    return HomeworkIdentityMappingsData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      nestedIdentity: data.nestedIdentity.present
          ? data.nestedIdentity.value
          : this.nestedIdentity,
      homeworkId: data.homeworkId.present
          ? data.homeworkId.value
          : this.homeworkId,
      contentRevision: data.contentRevision.present
          ? data.contentRevision.value
          : this.contentRevision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeworkIdentityMappingsData(')
          ..write('profileId: $profileId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('nestedIdentity: $nestedIdentity, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    sourceRecordId,
    nestedIdentity,
    homeworkId,
    contentRevision,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeworkIdentityMappingsData &&
          other.profileId == this.profileId &&
          other.sourceRecordId == this.sourceRecordId &&
          other.nestedIdentity == this.nestedIdentity &&
          other.homeworkId == this.homeworkId &&
          other.contentRevision == this.contentRevision &&
          other.updatedAt == this.updatedAt);
}

class HomeworkIdentityMappingsCompanion
    extends UpdateCompanion<HomeworkIdentityMappingsData> {
  final Value<String> profileId;
  final Value<String> sourceRecordId;
  final Value<String> nestedIdentity;
  final Value<String> homeworkId;
  final Value<String> contentRevision;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HomeworkIdentityMappingsCompanion({
    this.profileId = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.nestedIdentity = const Value.absent(),
    this.homeworkId = const Value.absent(),
    this.contentRevision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeworkIdentityMappingsCompanion.insert({
    required String profileId,
    required String sourceRecordId,
    required String nestedIdentity,
    required String homeworkId,
    required String contentRevision,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       sourceRecordId = Value(sourceRecordId),
       nestedIdentity = Value(nestedIdentity),
       homeworkId = Value(homeworkId),
       contentRevision = Value(contentRevision),
       updatedAt = Value(updatedAt);
  static Insertable<HomeworkIdentityMappingsData> custom({
    Expression<String>? profileId,
    Expression<String>? sourceRecordId,
    Expression<String>? nestedIdentity,
    Expression<String>? homeworkId,
    Expression<String>? contentRevision,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (nestedIdentity != null) 'nested_identity': nestedIdentity,
      if (homeworkId != null) 'homework_id': homeworkId,
      if (contentRevision != null) 'content_revision': contentRevision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeworkIdentityMappingsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? sourceRecordId,
    Value<String>? nestedIdentity,
    Value<String>? homeworkId,
    Value<String>? contentRevision,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HomeworkIdentityMappingsCompanion(
      profileId: profileId ?? this.profileId,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      nestedIdentity: nestedIdentity ?? this.nestedIdentity,
      homeworkId: homeworkId ?? this.homeworkId,
      contentRevision: contentRevision ?? this.contentRevision,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (nestedIdentity.present) {
      map['nested_identity'] = Variable<String>(nestedIdentity.value);
    }
    if (homeworkId.present) {
      map['homework_id'] = Variable<String>(homeworkId.value);
    }
    if (contentRevision.present) {
      map['content_revision'] = Variable<String>(contentRevision.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeworkIdentityMappingsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('nestedIdentity: $nestedIdentity, ')
          ..write('homeworkId: $homeworkId, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final LocalUsers localUsers = LocalUsers(this);
  late final ArgoConnections argoConnections = ArgoConnections(this);
  late final StudentProfiles studentProfiles = StudentProfiles(this);
  late final Subjects subjects = Subjects(this);
  late final SourceRecords sourceRecords = SourceRecords(this);
  late final HomeworkItems homeworkItems = HomeworkItems(this);
  late final Deadlines deadlines = Deadlines(this);
  late final Completions completions = Completions(this);
  late final Reminders reminders = Reminders(this);
  late final SyncStates syncStates = SyncStates(this);
  late final HomeworkIdentityMappings homeworkIdentityMappings =
      HomeworkIdentityMappings(this);
  late final Index profilesByConnectionYear = Index(
    'profiles_by_connection_year',
    'CREATE INDEX profiles_by_connection_year ON student_profiles (connection_id, academic_year)',
  );
  late final Index subjectsByProfileYear = Index(
    'subjects_by_profile_year',
    'CREATE INDEX subjects_by_profile_year ON subjects (profile_id, academic_year)',
  );
  late final Index sourceRecordsByProfileDay = Index(
    'source_records_by_profile_day',
    'CREATE INDEX source_records_by_profile_day ON source_records (profile_id, record_day)',
  );
  late final Index homeworkByProfileState = Index(
    'homework_by_profile_state',
    'CREATE INDEX homework_by_profile_state ON homework_items (profile_id, source_state)',
  );
  late final Index homeworkByProfileSubject = Index(
    'homework_by_profile_subject',
    'CREATE INDEX homework_by_profile_subject ON homework_items (profile_id, subject_id)',
  );
  late final Index deadlinesBySourceDue = Index(
    'deadlines_by_source_due',
    'CREATE INDEX deadlines_by_source_due ON deadlines (source_due_on)',
  );
  late final Index deadlinesByPersonalDue = Index(
    'deadlines_by_personal_due',
    'CREATE INDEX deadlines_by_personal_due ON deadlines (personal_due_on)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localUsers,
    argoConnections,
    studentProfiles,
    subjects,
    sourceRecords,
    homeworkItems,
    deadlines,
    completions,
    reminders,
    syncStates,
    homeworkIdentityMappings,
    profilesByConnectionYear,
    subjectsByProfileYear,
    sourceRecordsByProfileDay,
    homeworkByProfileState,
    homeworkByProfileSubject,
    deadlinesBySourceDue,
    deadlinesByPersonalDue,
  ];
  @override
  int get schemaVersion => 2;
}
