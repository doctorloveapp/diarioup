// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('it'),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Europe/Rome'),
  );
  static const VerificationMeta _preferencesJsonMeta = const VerificationMeta(
    'preferencesJson',
  );
  @override
  late final GeneratedColumn<String> preferencesJson = GeneratedColumn<String>(
    'preferences_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _privacyNoticeVersionMeta =
      const VerificationMeta('privacyNoticeVersion');
  @override
  late final GeneratedColumn<String> privacyNoticeVersion =
      GeneratedColumn<String>(
        'privacy_notice_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ageBandMeta = const VerificationMeta(
    'ageBand',
  );
  @override
  late final GeneratedColumn<String> ageBand = GeneratedColumn<String>(
    'age_band',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    }
    if (data.containsKey('preferences_json')) {
      context.handle(
        _preferencesJsonMeta,
        preferencesJson.isAcceptableOrUnknown(
          data['preferences_json']!,
          _preferencesJsonMeta,
        ),
      );
    }
    if (data.containsKey('privacy_notice_version')) {
      context.handle(
        _privacyNoticeVersionMeta,
        privacyNoticeVersion.isAcceptableOrUnknown(
          data['privacy_notice_version']!,
          _privacyNoticeVersionMeta,
        ),
      );
    }
    if (data.containsKey('age_band')) {
      context.handle(
        _ageBandMeta,
        ageBand.isAcceptableOrUnknown(data['age_band']!, _ageBandMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
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
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String locale;
  final String theme;
  final String timeZone;
  final String preferencesJson;
  final String? privacyNoticeVersion;
  final String? ageBand;
  final DateTime createdAt;
  const LocalUser({
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

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
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

  LocalUser copyWith({
    String? id,
    String? locale,
    String? theme,
    String? timeZone,
    String? preferencesJson,
    Value<String?> privacyNoticeVersion = const Value.absent(),
    Value<String?> ageBand = const Value.absent(),
    DateTime? createdAt,
  }) => LocalUser(
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
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
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
    return (StringBuffer('LocalUser(')
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
      (other is LocalUser &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.theme == this.theme &&
          other.timeZone == this.timeZone &&
          other.preferencesJson == this.preferencesJson &&
          other.privacyNoticeVersion == this.privacyNoticeVersion &&
          other.ageBand == this.ageBand &&
          other.createdAt == this.createdAt);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
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
  static Insertable<LocalUser> custom({
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

class $ArgoConnectionsTable extends ArgoConnections
    with TableInfo<$ArgoConnectionsTable, ArgoConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArgoConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
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
  static const VerificationMeta _schoolMinistryCodeMeta =
      const VerificationMeta('schoolMinistryCode');
  @override
  late final GeneratedColumn<String> schoolMinistryCode =
      GeneratedColumn<String>(
        'school_ministry_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('family'),
  );
  static const VerificationMeta _secretReferenceMeta = const VerificationMeta(
    'secretReference',
  );
  @override
  late final GeneratedColumn<String> secretReference = GeneratedColumn<String>(
    'secret_reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionStateMeta = const VerificationMeta(
    'sessionState',
  );
  @override
  late final GeneratedColumn<String> sessionState = GeneratedColumn<String>(
    'session_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<ArgoConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('school_ministry_code')) {
      context.handle(
        _schoolMinistryCodeMeta,
        schoolMinistryCode.isAcceptableOrUnknown(
          data['school_ministry_code']!,
          _schoolMinistryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schoolMinistryCodeMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('secret_reference')) {
      context.handle(
        _secretReferenceMeta,
        secretReference.isAcceptableOrUnknown(
          data['secret_reference']!,
          _secretReferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secretReferenceMeta);
    }
    if (data.containsKey('session_state')) {
      context.handle(
        _sessionStateMeta,
        sessionState.isAcceptableOrUnknown(
          data['session_state']!,
          _sessionStateMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, schoolMinistryCode},
  ];
  @override
  ArgoConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArgoConnection(
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
  $ArgoConnectionsTable createAlias(String alias) {
    return $ArgoConnectionsTable(attachedDatabase, alias);
  }
}

class ArgoConnection extends DataClass implements Insertable<ArgoConnection> {
  final String id;
  final String userId;
  final String schoolMinistryCode;
  final String role;
  final String secretReference;
  final String sessionState;
  final DateTime updatedAt;
  const ArgoConnection({
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

  factory ArgoConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArgoConnection(
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

  ArgoConnection copyWith({
    String? id,
    String? userId,
    String? schoolMinistryCode,
    String? role,
    String? secretReference,
    String? sessionState,
    DateTime? updatedAt,
  }) => ArgoConnection(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    schoolMinistryCode: schoolMinistryCode ?? this.schoolMinistryCode,
    role: role ?? this.role,
    secretReference: secretReference ?? this.secretReference,
    sessionState: sessionState ?? this.sessionState,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ArgoConnection copyWithCompanion(ArgoConnectionsCompanion data) {
    return ArgoConnection(
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
    return (StringBuffer('ArgoConnection(')
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
      (other is ArgoConnection &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.schoolMinistryCode == this.schoolMinistryCode &&
          other.role == this.role &&
          other.secretReference == this.secretReference &&
          other.sessionState == this.sessionState &&
          other.updatedAt == this.updatedAt);
}

class ArgoConnectionsCompanion extends UpdateCompanion<ArgoConnection> {
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
  static Insertable<ArgoConnection> custom({
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

class $StudentProfilesTable extends StudentProfiles
    with TableInfo<$StudentProfilesTable, StudentProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectionIdMeta = const VerificationMeta(
    'connectionId',
  );
  @override
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
  static const VerificationMeta _sourceProfileIdMeta = const VerificationMeta(
    'sourceProfileId',
  );
  @override
  late final GeneratedColumn<String> sourceProfileId = GeneratedColumn<String>(
    'source_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _academicYearMeta = const VerificationMeta(
    'academicYear',
  );
  @override
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<StudentProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('connection_id')) {
      context.handle(
        _connectionIdMeta,
        connectionId.isAcceptableOrUnknown(
          data['connection_id']!,
          _connectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('source_profile_id')) {
      context.handle(
        _sourceProfileIdMeta,
        sourceProfileId.isAcceptableOrUnknown(
          data['source_profile_id']!,
          _sourceProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceProfileIdMeta);
    }
    if (data.containsKey('academic_year')) {
      context.handle(
        _academicYearMeta,
        academicYear.isAcceptableOrUnknown(
          data['academic_year']!,
          _academicYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {connectionId, sourceProfileId},
  ];
  @override
  StudentProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfile(
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
  $StudentProfilesTable createAlias(String alias) {
    return $StudentProfilesTable(attachedDatabase, alias);
  }
}

class StudentProfile extends DataClass implements Insertable<StudentProfile> {
  final String id;
  final String connectionId;
  final String sourceProfileId;
  final String academicYear;
  final String alias;
  final DateTime updatedAt;
  const StudentProfile({
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

  factory StudentProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfile(
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

  StudentProfile copyWith({
    String? id,
    String? connectionId,
    String? sourceProfileId,
    String? academicYear,
    String? alias,
    DateTime? updatedAt,
  }) => StudentProfile(
    id: id ?? this.id,
    connectionId: connectionId ?? this.connectionId,
    sourceProfileId: sourceProfileId ?? this.sourceProfileId,
    academicYear: academicYear ?? this.academicYear,
    alias: alias ?? this.alias,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudentProfile copyWithCompanion(StudentProfilesCompanion data) {
    return StudentProfile(
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
    return (StringBuffer('StudentProfile(')
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
      (other is StudentProfile &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.sourceProfileId == this.sourceProfileId &&
          other.academicYear == this.academicYear &&
          other.alias == this.alias &&
          other.updatedAt == this.updatedAt);
}

class StudentProfilesCompanion extends UpdateCompanion<StudentProfile> {
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
  static Insertable<StudentProfile> custom({
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

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _academicYearMeta = const VerificationMeta(
    'academicYear',
  );
  @override
  late final GeneratedColumn<String> academicYear = GeneratedColumn<String>(
    'academic_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceSubjectIdMeta = const VerificationMeta(
    'sourceSubjectId',
  );
  @override
  late final GeneratedColumn<String> sourceSubjectId = GeneratedColumn<String>(
    'source_subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('academic_year')) {
      context.handle(
        _academicYearMeta,
        academicYear.isAcceptableOrUnknown(
          data['academic_year']!,
          _academicYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicYearMeta);
    }
    if (data.containsKey('source_subject_id')) {
      context.handle(
        _sourceSubjectIdMeta,
        sourceSubjectId.isAcceptableOrUnknown(
          data['source_subject_id']!,
          _sourceSubjectIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, academicYear, name},
  ];
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
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
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String profileId;
  final String academicYear;
  final String? sourceSubjectId;
  final String name;
  final int? colorValue;
  const Subject({
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

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
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

  Subject copyWith({
    String? id,
    String? profileId,
    String? academicYear,
    Value<String?> sourceSubjectId = const Value.absent(),
    String? name,
    Value<int?> colorValue = const Value.absent(),
  }) => Subject(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    academicYear: academicYear ?? this.academicYear,
    sourceSubjectId: sourceSubjectId.present
        ? sourceSubjectId.value
        : this.sourceSubjectId,
    name: name ?? this.name,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
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
    return (StringBuffer('Subject(')
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
      (other is Subject &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.academicYear == this.academicYear &&
          other.sourceSubjectId == this.sourceSubjectId &&
          other.name == this.name &&
          other.colorValue == this.colorValue);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
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
  static Insertable<Subject> custom({
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

class $SourceRecordsTable extends SourceRecords
    with TableInfo<$SourceRecordsTable, SourceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _sourcePrimaryKeyMeta = const VerificationMeta(
    'sourcePrimaryKey',
  );
  @override
  late final GeneratedColumn<String> sourcePrimaryKey = GeneratedColumn<String>(
    'source_primary_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<String> revision = GeneratedColumn<String>(
    'revision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _recordDayMeta = const VerificationMeta(
    'recordDay',
  );
  @override
  late final GeneratedColumn<String> recordDay = GeneratedColumn<String>(
    'record_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<SourceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('source_primary_key')) {
      context.handle(
        _sourcePrimaryKeyMeta,
        sourcePrimaryKey.isAcceptableOrUnknown(
          data['source_primary_key']!,
          _sourcePrimaryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourcePrimaryKeyMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('record_day')) {
      context.handle(
        _recordDayMeta,
        recordDay.isAcceptableOrUnknown(data['record_day']!, _recordDayMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, sourcePrimaryKey},
  ];
  @override
  SourceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRecord(
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
  $SourceRecordsTable createAlias(String alias) {
    return $SourceRecordsTable(attachedDatabase, alias);
  }
}

class SourceRecord extends DataClass implements Insertable<SourceRecord> {
  final String id;
  final String profileId;
  final String sourcePrimaryKey;
  final String? revision;
  final String state;
  final String? recordDay;
  final DateTime updatedAt;
  const SourceRecord({
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

  factory SourceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRecord(
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

  SourceRecord copyWith({
    String? id,
    String? profileId,
    String? sourcePrimaryKey,
    Value<String?> revision = const Value.absent(),
    String? state,
    Value<String?> recordDay = const Value.absent(),
    DateTime? updatedAt,
  }) => SourceRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    sourcePrimaryKey: sourcePrimaryKey ?? this.sourcePrimaryKey,
    revision: revision.present ? revision.value : this.revision,
    state: state ?? this.state,
    recordDay: recordDay.present ? recordDay.value : this.recordDay,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SourceRecord copyWithCompanion(SourceRecordsCompanion data) {
    return SourceRecord(
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
    return (StringBuffer('SourceRecord(')
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
      (other is SourceRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.sourcePrimaryKey == this.sourcePrimaryKey &&
          other.revision == this.revision &&
          other.state == this.state &&
          other.recordDay == this.recordDay &&
          other.updatedAt == this.updatedAt);
}

class SourceRecordsCompanion extends UpdateCompanion<SourceRecord> {
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
  static Insertable<SourceRecord> custom({
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

class $HomeworkItemsTable extends HomeworkItems
    with TableInfo<$HomeworkItemsTable, HomeworkItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeworkItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
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
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
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
  static const VerificationMeta _nestedIdentityMeta = const VerificationMeta(
    'nestedIdentity',
  );
  @override
  late final GeneratedColumn<String> nestedIdentity = GeneratedColumn<String>(
    'nested_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceItemIdMeta = const VerificationMeta(
    'sourceItemId',
  );
  @override
  late final GeneratedColumn<String> sourceItemId = GeneratedColumn<String>(
    'source_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identityConfidenceMeta =
      const VerificationMeta('identityConfidence');
  @override
  late final GeneratedColumn<String> identityConfidence =
      GeneratedColumn<String>(
        'identity_confidence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalNoteMeta = const VerificationMeta(
    'personalNote',
  );
  @override
  late final GeneratedColumn<String> personalNote = GeneratedColumn<String>(
    'personal_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedOnMeta = const VerificationMeta(
    'assignedOn',
  );
  @override
  late final GeneratedColumn<String> assignedOn = GeneratedColumn<String>(
    'assigned_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentRevisionMeta = const VerificationMeta(
    'contentRevision',
  );
  @override
  late final GeneratedColumn<String> contentRevision = GeneratedColumn<String>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStateMeta = const VerificationMeta(
    'sourceState',
  );
  @override
  late final GeneratedColumn<String> sourceState = GeneratedColumn<String>(
    'source_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _requiresIdentityReviewMeta =
      const VerificationMeta('requiresIdentityReview');
  @override
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
        defaultValue: const Constant(false),
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
  VerificationContext validateIntegrity(
    Insertable<HomeworkItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('nested_identity')) {
      context.handle(
        _nestedIdentityMeta,
        nestedIdentity.isAcceptableOrUnknown(
          data['nested_identity']!,
          _nestedIdentityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nestedIdentityMeta);
    }
    if (data.containsKey('source_item_id')) {
      context.handle(
        _sourceItemIdMeta,
        sourceItemId.isAcceptableOrUnknown(
          data['source_item_id']!,
          _sourceItemIdMeta,
        ),
      );
    }
    if (data.containsKey('identity_confidence')) {
      context.handle(
        _identityConfidenceMeta,
        identityConfidence.isAcceptableOrUnknown(
          data['identity_confidence']!,
          _identityConfidenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityConfidenceMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('personal_note')) {
      context.handle(
        _personalNoteMeta,
        personalNote.isAcceptableOrUnknown(
          data['personal_note']!,
          _personalNoteMeta,
        ),
      );
    }
    if (data.containsKey('assigned_on')) {
      context.handle(
        _assignedOnMeta,
        assignedOn.isAcceptableOrUnknown(data['assigned_on']!, _assignedOnMeta),
      );
    }
    if (data.containsKey('content_revision')) {
      context.handle(
        _contentRevisionMeta,
        contentRevision.isAcceptableOrUnknown(
          data['content_revision']!,
          _contentRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentRevisionMeta);
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSeenAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('source_state')) {
      context.handle(
        _sourceStateMeta,
        sourceState.isAcceptableOrUnknown(
          data['source_state']!,
          _sourceStateMeta,
        ),
      );
    }
    if (data.containsKey('requires_identity_review')) {
      context.handle(
        _requiresIdentityReviewMeta,
        requiresIdentityReview.isAcceptableOrUnknown(
          data['requires_identity_review']!,
          _requiresIdentityReviewMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HomeworkItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeworkItem(
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
  $HomeworkItemsTable createAlias(String alias) {
    return $HomeworkItemsTable(attachedDatabase, alias);
  }
}

class HomeworkItem extends DataClass implements Insertable<HomeworkItem> {
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
  const HomeworkItem({
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

  factory HomeworkItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeworkItem(
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

  HomeworkItem copyWith({
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
  }) => HomeworkItem(
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
  HomeworkItem copyWithCompanion(HomeworkItemsCompanion data) {
    return HomeworkItem(
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
    return (StringBuffer('HomeworkItem(')
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
      (other is HomeworkItem &&
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

class HomeworkItemsCompanion extends UpdateCompanion<HomeworkItem> {
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
  static Insertable<HomeworkItem> custom({
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

class $DeadlinesTable extends Deadlines
    with TableInfo<$DeadlinesTable, Deadline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeadlinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeworkIdMeta = const VerificationMeta(
    'homeworkId',
  );
  @override
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
  static const VerificationMeta _sourceDueOnMeta = const VerificationMeta(
    'sourceDueOn',
  );
  @override
  late final GeneratedColumn<String> sourceDueOn = GeneratedColumn<String>(
    'source_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalDueOnMeta = const VerificationMeta(
    'personalDueOn',
  );
  @override
  late final GeneratedColumn<String> personalDueOn = GeneratedColumn<String>(
    'personal_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTimeMeta = const VerificationMeta(
    'sourceTime',
  );
  @override
  late final GeneratedColumn<String> sourceTime = GeneratedColumn<String>(
    'source_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schoolTimeZoneMeta = const VerificationMeta(
    'schoolTimeZone',
  );
  @override
  late final GeneratedColumn<String> schoolTimeZone = GeneratedColumn<String>(
    'school_time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Europe/Rome'),
  );
  static const VerificationMeta _precisionMeta = const VerificationMeta(
    'precision',
  );
  @override
  late final GeneratedColumn<String> precision = GeneratedColumn<String>(
    'precision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('date'),
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('argo'),
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
  VerificationContext validateIntegrity(
    Insertable<Deadline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('homework_id')) {
      context.handle(
        _homeworkIdMeta,
        homeworkId.isAcceptableOrUnknown(data['homework_id']!, _homeworkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeworkIdMeta);
    }
    if (data.containsKey('source_due_on')) {
      context.handle(
        _sourceDueOnMeta,
        sourceDueOn.isAcceptableOrUnknown(
          data['source_due_on']!,
          _sourceDueOnMeta,
        ),
      );
    }
    if (data.containsKey('personal_due_on')) {
      context.handle(
        _personalDueOnMeta,
        personalDueOn.isAcceptableOrUnknown(
          data['personal_due_on']!,
          _personalDueOnMeta,
        ),
      );
    }
    if (data.containsKey('source_time')) {
      context.handle(
        _sourceTimeMeta,
        sourceTime.isAcceptableOrUnknown(data['source_time']!, _sourceTimeMeta),
      );
    }
    if (data.containsKey('school_time_zone')) {
      context.handle(
        _schoolTimeZoneMeta,
        schoolTimeZone.isAcceptableOrUnknown(
          data['school_time_zone']!,
          _schoolTimeZoneMeta,
        ),
      );
    }
    if (data.containsKey('precision')) {
      context.handle(
        _precisionMeta,
        precision.isAcceptableOrUnknown(data['precision']!, _precisionMeta),
      );
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deadline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deadline(
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
  $DeadlinesTable createAlias(String alias) {
    return $DeadlinesTable(attachedDatabase, alias);
  }
}

class Deadline extends DataClass implements Insertable<Deadline> {
  final String id;
  final String homeworkId;
  final String? sourceDueOn;
  final String? personalDueOn;
  final String? sourceTime;
  final String schoolTimeZone;
  final String precision;
  final String provenance;
  const Deadline({
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

  factory Deadline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deadline(
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

  Deadline copyWith({
    String? id,
    String? homeworkId,
    Value<String?> sourceDueOn = const Value.absent(),
    Value<String?> personalDueOn = const Value.absent(),
    Value<String?> sourceTime = const Value.absent(),
    String? schoolTimeZone,
    String? precision,
    String? provenance,
  }) => Deadline(
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
  Deadline copyWithCompanion(DeadlinesCompanion data) {
    return Deadline(
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
    return (StringBuffer('Deadline(')
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
      (other is Deadline &&
          other.id == this.id &&
          other.homeworkId == this.homeworkId &&
          other.sourceDueOn == this.sourceDueOn &&
          other.personalDueOn == this.personalDueOn &&
          other.sourceTime == this.sourceTime &&
          other.schoolTimeZone == this.schoolTimeZone &&
          other.precision == this.precision &&
          other.provenance == this.provenance);
}

class DeadlinesCompanion extends UpdateCompanion<Deadline> {
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
  static Insertable<Deadline> custom({
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

class $CompletionsTable extends Completions
    with TableInfo<$CompletionsTable, Completion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
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
  static const VerificationMeta _homeworkIdMeta = const VerificationMeta(
    'homeworkId',
  );
  @override
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
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedRevisionMeta = const VerificationMeta(
    'completedRevision',
  );
  @override
  late final GeneratedColumn<String> completedRevision =
      GeneratedColumn<String>(
        'completed_revision',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<Completion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('homework_id')) {
      context.handle(
        _homeworkIdMeta,
        homeworkId.isAcceptableOrUnknown(data['homework_id']!, _homeworkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeworkIdMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    if (data.containsKey('completed_revision')) {
      context.handle(
        _completedRevisionMeta,
        completedRevision.isAcceptableOrUnknown(
          data['completed_revision']!,
          _completedRevisionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, homeworkId};
  @override
  Completion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Completion(
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
  $CompletionsTable createAlias(String alias) {
    return $CompletionsTable(attachedDatabase, alias);
  }
}

class Completion extends DataClass implements Insertable<Completion> {
  final String userId;
  final String homeworkId;
  final bool isDone;
  final DateTime? doneAt;
  final String? completedRevision;
  final DateTime updatedAt;
  const Completion({
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

  factory Completion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Completion(
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

  Completion copyWith({
    String? userId,
    String? homeworkId,
    bool? isDone,
    Value<DateTime?> doneAt = const Value.absent(),
    Value<String?> completedRevision = const Value.absent(),
    DateTime? updatedAt,
  }) => Completion(
    userId: userId ?? this.userId,
    homeworkId: homeworkId ?? this.homeworkId,
    isDone: isDone ?? this.isDone,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    completedRevision: completedRevision.present
        ? completedRevision.value
        : this.completedRevision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Completion copyWithCompanion(CompletionsCompanion data) {
    return Completion(
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
    return (StringBuffer('Completion(')
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
      (other is Completion &&
          other.userId == this.userId &&
          other.homeworkId == this.homeworkId &&
          other.isDone == this.isDone &&
          other.doneAt == this.doneAt &&
          other.completedRevision == this.completedRevision &&
          other.updatedAt == this.updatedAt);
}

class CompletionsCompanion extends UpdateCompanion<Completion> {
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
  static Insertable<Completion> custom({
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

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
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
  static const VerificationMeta _homeworkIdMeta = const VerificationMeta(
    'homeworkId',
  );
  @override
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
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
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
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('homework_id')) {
      context.handle(
        _homeworkIdMeta,
        homeworkId.isAcceptableOrUnknown(data['homework_id']!, _homeworkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeworkIdMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
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
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String userId;
  final String homeworkId;
  final DateTime remindAt;
  final String state;
  const Reminder({
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

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
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

  Reminder copyWith({
    String? id,
    String? userId,
    String? homeworkId,
    DateTime? remindAt,
    String? state,
  }) => Reminder(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    homeworkId: homeworkId ?? this.homeworkId,
    remindAt: remindAt ?? this.remindAt,
    state: state ?? this.state,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
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
    return (StringBuffer('Reminder(')
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
      (other is Reminder &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.homeworkId == this.homeworkId &&
          other.remindAt == this.remindAt &&
          other.state == this.state);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
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
  static Insertable<Reminder> custom({
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

class $SyncStatesTable extends SyncStates
    with TableInfo<$SyncStatesTable, SyncState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _adapterVersionMeta = const VerificationMeta(
    'adapterVersion',
  );
  @override
  late final GeneratedColumn<String> adapterVersion = GeneratedColumn<String>(
    'adapter_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSuccessAtMeta = const VerificationMeta(
    'lastSuccessAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>(
        'last_success_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _coverageStartMeta = const VerificationMeta(
    'coverageStart',
  );
  @override
  late final GeneratedColumn<DateTime> coverageStart =
      GeneratedColumn<DateTime>(
        'coverage_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<SyncState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('adapter_version')) {
      context.handle(
        _adapterVersionMeta,
        adapterVersion.isAcceptableOrUnknown(
          data['adapter_version']!,
          _adapterVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adapterVersionMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
        _lastSuccessAtMeta,
        lastSuccessAt.isAcceptableOrUnknown(
          data['last_success_at']!,
          _lastSuccessAtMeta,
        ),
      );
    }
    if (data.containsKey('coverage_start')) {
      context.handle(
        _coverageStartMeta,
        coverageStart.isAcceptableOrUnknown(
          data['coverage_start']!,
          _coverageStartMeta,
        ),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  SyncState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncState(
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
  $SyncStatesTable createAlias(String alias) {
    return $SyncStatesTable(attachedDatabase, alias);
  }
}

class SyncState extends DataClass implements Insertable<SyncState> {
  final String profileId;
  final String adapterVersion;
  final String? cursor;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? coverageStart;
  final String? errorCode;
  const SyncState({
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

  factory SyncState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncState(
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

  SyncState copyWith({
    String? profileId,
    String? adapterVersion,
    Value<String?> cursor = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<DateTime?> lastSuccessAt = const Value.absent(),
    Value<DateTime?> coverageStart = const Value.absent(),
    Value<String?> errorCode = const Value.absent(),
  }) => SyncState(
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
  SyncState copyWithCompanion(SyncStatesCompanion data) {
    return SyncState(
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
    return (StringBuffer('SyncState(')
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
      (other is SyncState &&
          other.profileId == this.profileId &&
          other.adapterVersion == this.adapterVersion &&
          other.cursor == this.cursor &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.coverageStart == this.coverageStart &&
          other.errorCode == this.errorCode);
}

class SyncStatesCompanion extends UpdateCompanion<SyncState> {
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
  static Insertable<SyncState> custom({
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

class $HomeworkIdentityMappingsTable extends HomeworkIdentityMappings
    with TableInfo<$HomeworkIdentityMappingsTable, HomeworkIdentityMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeworkIdentityMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nestedIdentityMeta = const VerificationMeta(
    'nestedIdentity',
  );
  @override
  late final GeneratedColumn<String> nestedIdentity = GeneratedColumn<String>(
    'nested_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeworkIdMeta = const VerificationMeta(
    'homeworkId',
  );
  @override
  late final GeneratedColumn<String> homeworkId = GeneratedColumn<String>(
    'homework_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentRevisionMeta = const VerificationMeta(
    'contentRevision',
  );
  @override
  late final GeneratedColumn<String> contentRevision = GeneratedColumn<String>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
  VerificationContext validateIntegrity(
    Insertable<HomeworkIdentityMapping> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRecordIdMeta);
    }
    if (data.containsKey('nested_identity')) {
      context.handle(
        _nestedIdentityMeta,
        nestedIdentity.isAcceptableOrUnknown(
          data['nested_identity']!,
          _nestedIdentityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nestedIdentityMeta);
    }
    if (data.containsKey('homework_id')) {
      context.handle(
        _homeworkIdMeta,
        homeworkId.isAcceptableOrUnknown(data['homework_id']!, _homeworkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeworkIdMeta);
    }
    if (data.containsKey('content_revision')) {
      context.handle(
        _contentRevisionMeta,
        contentRevision.isAcceptableOrUnknown(
          data['content_revision']!,
          _contentRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentRevisionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    profileId,
    sourceRecordId,
    nestedIdentity,
  };
  @override
  HomeworkIdentityMapping map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeworkIdentityMapping(
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
  $HomeworkIdentityMappingsTable createAlias(String alias) {
    return $HomeworkIdentityMappingsTable(attachedDatabase, alias);
  }
}

class HomeworkIdentityMapping extends DataClass
    implements Insertable<HomeworkIdentityMapping> {
  final String profileId;
  final String sourceRecordId;
  final String nestedIdentity;
  final String homeworkId;
  final String contentRevision;
  final DateTime updatedAt;
  const HomeworkIdentityMapping({
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

  factory HomeworkIdentityMapping.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeworkIdentityMapping(
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

  HomeworkIdentityMapping copyWith({
    String? profileId,
    String? sourceRecordId,
    String? nestedIdentity,
    String? homeworkId,
    String? contentRevision,
    DateTime? updatedAt,
  }) => HomeworkIdentityMapping(
    profileId: profileId ?? this.profileId,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    nestedIdentity: nestedIdentity ?? this.nestedIdentity,
    homeworkId: homeworkId ?? this.homeworkId,
    contentRevision: contentRevision ?? this.contentRevision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HomeworkIdentityMapping copyWithCompanion(
    HomeworkIdentityMappingsCompanion data,
  ) {
    return HomeworkIdentityMapping(
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
    return (StringBuffer('HomeworkIdentityMapping(')
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
      (other is HomeworkIdentityMapping &&
          other.profileId == this.profileId &&
          other.sourceRecordId == this.sourceRecordId &&
          other.nestedIdentity == this.nestedIdentity &&
          other.homeworkId == this.homeworkId &&
          other.contentRevision == this.contentRevision &&
          other.updatedAt == this.updatedAt);
}

class HomeworkIdentityMappingsCompanion
    extends UpdateCompanion<HomeworkIdentityMapping> {
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
  static Insertable<HomeworkIdentityMapping> custom({
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

class $DiagnosticEntriesTable extends DiagnosticEntries
    with TableInfo<$DiagnosticEntriesTable, DiagnosticEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosticEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, occurredAt, area, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnostic_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagnosticEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagnosticEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagnosticEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
    );
  }

  @override
  $DiagnosticEntriesTable createAlias(String alias) {
    return $DiagnosticEntriesTable(attachedDatabase, alias);
  }
}

class DiagnosticEntry extends DataClass implements Insertable<DiagnosticEntry> {
  final String id;
  final DateTime occurredAt;
  final String area;
  final String code;
  const DiagnosticEntry({
    required this.id,
    required this.occurredAt,
    required this.area,
    required this.code,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['area'] = Variable<String>(area);
    map['code'] = Variable<String>(code);
    return map;
  }

  DiagnosticEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiagnosticEntriesCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      area: Value(area),
      code: Value(code),
    );
  }

  factory DiagnosticEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagnosticEntry(
      id: serializer.fromJson<String>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      area: serializer.fromJson<String>(json['area']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'area': serializer.toJson<String>(area),
      'code': serializer.toJson<String>(code),
    };
  }

  DiagnosticEntry copyWith({
    String? id,
    DateTime? occurredAt,
    String? area,
    String? code,
  }) => DiagnosticEntry(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    area: area ?? this.area,
    code: code ?? this.code,
  );
  DiagnosticEntry copyWithCompanion(DiagnosticEntriesCompanion data) {
    return DiagnosticEntry(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      area: data.area.present ? data.area.value : this.area,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticEntry(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('area: $area, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, occurredAt, area, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagnosticEntry &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.area == this.area &&
          other.code == this.code);
}

class DiagnosticEntriesCompanion extends UpdateCompanion<DiagnosticEntry> {
  final Value<String> id;
  final Value<DateTime> occurredAt;
  final Value<String> area;
  final Value<String> code;
  final Value<int> rowid;
  const DiagnosticEntriesCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.area = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiagnosticEntriesCompanion.insert({
    required String id,
    required DateTime occurredAt,
    required String area,
    required String code,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAt = Value(occurredAt),
       area = Value(area),
       code = Value(code);
  static Insertable<DiagnosticEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? occurredAt,
    Expression<String>? area,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (area != null) 'area': area,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiagnosticEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? occurredAt,
    Value<String>? area,
    Value<String>? code,
    Value<int>? rowid,
  }) {
    return DiagnosticEntriesCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      area: area ?? this.area,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticEntriesCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('area: $area, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchoolTimetableEntriesTable extends SchoolTimetableEntries
    with TableInfo<$SchoolTimetableEntriesTable, SchoolTimetableEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolTimetableEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
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
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<int> period = GeneratedColumn<int>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _professorNameMeta = const VerificationMeta(
    'professorName',
  );
  @override
  late final GeneratedColumn<String> professorName = GeneratedColumn<String>(
    'professor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectColorValueMeta = const VerificationMeta(
    'subjectColorValue',
  );
  @override
  late final GeneratedColumn<int> subjectColorValue = GeneratedColumn<int>(
    'subject_color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
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
    weekday,
    period,
    professorName,
    subjectName,
    subjectColorValue,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_timetable_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolTimetableEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('professor_name')) {
      context.handle(
        _professorNameMeta,
        professorName.isAcceptableOrUnknown(
          data['professor_name']!,
          _professorNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_professorNameMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    }
    if (data.containsKey('subject_color_value')) {
      context.handle(
        _subjectColorValueMeta,
        subjectColorValue.isAcceptableOrUnknown(
          data['subject_color_value']!,
          _subjectColorValueMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolTimetableEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolTimetableEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period'],
      )!,
      professorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}professor_name'],
      )!,
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      ),
      subjectColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_color_value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SchoolTimetableEntriesTable createAlias(String alias) {
    return $SchoolTimetableEntriesTable(attachedDatabase, alias);
  }
}

class SchoolTimetableEntry extends DataClass
    implements Insertable<SchoolTimetableEntry> {
  final String id;
  final String profileId;
  final int weekday;
  final int period;
  final String professorName;
  final String? subjectName;
  final int? subjectColorValue;
  final DateTime updatedAt;
  const SchoolTimetableEntry({
    required this.id,
    required this.profileId,
    required this.weekday,
    required this.period,
    required this.professorName,
    this.subjectName,
    this.subjectColorValue,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['weekday'] = Variable<int>(weekday);
    map['period'] = Variable<int>(period);
    map['professor_name'] = Variable<String>(professorName);
    if (!nullToAbsent || subjectName != null) {
      map['subject_name'] = Variable<String>(subjectName);
    }
    if (!nullToAbsent || subjectColorValue != null) {
      map['subject_color_value'] = Variable<int>(subjectColorValue);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SchoolTimetableEntriesCompanion toCompanion(bool nullToAbsent) {
    return SchoolTimetableEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      weekday: Value(weekday),
      period: Value(period),
      professorName: Value(professorName),
      subjectName: subjectName == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectName),
      subjectColorValue: subjectColorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectColorValue),
      updatedAt: Value(updatedAt),
    );
  }

  factory SchoolTimetableEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolTimetableEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      period: serializer.fromJson<int>(json['period']),
      professorName: serializer.fromJson<String>(json['professorName']),
      subjectName: serializer.fromJson<String?>(json['subjectName']),
      subjectColorValue: serializer.fromJson<int?>(json['subjectColorValue']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'weekday': serializer.toJson<int>(weekday),
      'period': serializer.toJson<int>(period),
      'professorName': serializer.toJson<String>(professorName),
      'subjectName': serializer.toJson<String?>(subjectName),
      'subjectColorValue': serializer.toJson<int?>(subjectColorValue),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SchoolTimetableEntry copyWith({
    String? id,
    String? profileId,
    int? weekday,
    int? period,
    String? professorName,
    Value<String?> subjectName = const Value.absent(),
    Value<int?> subjectColorValue = const Value.absent(),
    DateTime? updatedAt,
  }) => SchoolTimetableEntry(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    weekday: weekday ?? this.weekday,
    period: period ?? this.period,
    professorName: professorName ?? this.professorName,
    subjectName: subjectName.present ? subjectName.value : this.subjectName,
    subjectColorValue: subjectColorValue.present
        ? subjectColorValue.value
        : this.subjectColorValue,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SchoolTimetableEntry copyWithCompanion(SchoolTimetableEntriesCompanion data) {
    return SchoolTimetableEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      period: data.period.present ? data.period.value : this.period,
      professorName: data.professorName.present
          ? data.professorName.value
          : this.professorName,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      subjectColorValue: data.subjectColorValue.present
          ? data.subjectColorValue.value
          : this.subjectColorValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolTimetableEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('weekday: $weekday, ')
          ..write('period: $period, ')
          ..write('professorName: $professorName, ')
          ..write('subjectName: $subjectName, ')
          ..write('subjectColorValue: $subjectColorValue, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    weekday,
    period,
    professorName,
    subjectName,
    subjectColorValue,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolTimetableEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.weekday == this.weekday &&
          other.period == this.period &&
          other.professorName == this.professorName &&
          other.subjectName == this.subjectName &&
          other.subjectColorValue == this.subjectColorValue &&
          other.updatedAt == this.updatedAt);
}

class SchoolTimetableEntriesCompanion
    extends UpdateCompanion<SchoolTimetableEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<int> weekday;
  final Value<int> period;
  final Value<String> professorName;
  final Value<String?> subjectName;
  final Value<int?> subjectColorValue;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SchoolTimetableEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.period = const Value.absent(),
    this.professorName = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.subjectColorValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolTimetableEntriesCompanion.insert({
    required String id,
    required String profileId,
    required int weekday,
    required int period,
    required String professorName,
    this.subjectName = const Value.absent(),
    this.subjectColorValue = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       weekday = Value(weekday),
       period = Value(period),
       professorName = Value(professorName),
       updatedAt = Value(updatedAt);
  static Insertable<SchoolTimetableEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? weekday,
    Expression<int>? period,
    Expression<String>? professorName,
    Expression<String>? subjectName,
    Expression<int>? subjectColorValue,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (weekday != null) 'weekday': weekday,
      if (period != null) 'period': period,
      if (professorName != null) 'professor_name': professorName,
      if (subjectName != null) 'subject_name': subjectName,
      if (subjectColorValue != null) 'subject_color_value': subjectColorValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolTimetableEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<int>? weekday,
    Value<int>? period,
    Value<String>? professorName,
    Value<String?>? subjectName,
    Value<int?>? subjectColorValue,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SchoolTimetableEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      weekday: weekday ?? this.weekday,
      period: period ?? this.period,
      professorName: professorName ?? this.professorName,
      subjectName: subjectName ?? this.subjectName,
      subjectColorValue: subjectColorValue ?? this.subjectColorValue,
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
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (period.present) {
      map['period'] = Variable<int>(period.value);
    }
    if (professorName.present) {
      map['professor_name'] = Variable<String>(professorName.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (subjectColorValue.present) {
      map['subject_color_value'] = Variable<int>(subjectColorValue.value);
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
    return (StringBuffer('SchoolTimetableEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('weekday: $weekday, ')
          ..write('period: $period, ')
          ..write('professorName: $professorName, ')
          ..write('subjectName: $subjectName, ')
          ..write('subjectColorValue: $subjectColorValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $ArgoConnectionsTable argoConnections = $ArgoConnectionsTable(
    this,
  );
  late final $StudentProfilesTable studentProfiles = $StudentProfilesTable(
    this,
  );
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $SourceRecordsTable sourceRecords = $SourceRecordsTable(this);
  late final $HomeworkItemsTable homeworkItems = $HomeworkItemsTable(this);
  late final $DeadlinesTable deadlines = $DeadlinesTable(this);
  late final $CompletionsTable completions = $CompletionsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $SyncStatesTable syncStates = $SyncStatesTable(this);
  late final $HomeworkIdentityMappingsTable homeworkIdentityMappings =
      $HomeworkIdentityMappingsTable(this);
  late final $DiagnosticEntriesTable diagnosticEntries =
      $DiagnosticEntriesTable(this);
  late final $SchoolTimetableEntriesTable schoolTimetableEntries =
      $SchoolTimetableEntriesTable(this);
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
  late final Index timetableByProfileDayPeriod = Index(
    'timetable_by_profile_day_period',
    'CREATE UNIQUE INDEX timetable_by_profile_day_period ON school_timetable_entries (profile_id, weekday, period)',
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
    diagnosticEntries,
    schoolTimetableEntries,
    profilesByConnectionYear,
    subjectsByProfileYear,
    sourceRecordsByProfileDay,
    homeworkByProfileState,
    homeworkByProfileSubject,
    deadlinesBySourceDue,
    deadlinesByPersonalDue,
    timetableByProfileDayPeriod,
  ];
}

typedef $$LocalUsersTableCreateCompanionBuilder =
    LocalUsersCompanion Function({
      required String id,
      Value<String> locale,
      Value<String> theme,
      Value<String> timeZone,
      Value<String> preferencesJson,
      Value<String?> privacyNoticeVersion,
      Value<String?> ageBand,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalUsersTableUpdateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<String> id,
      Value<String> locale,
      Value<String> theme,
      Value<String> timeZone,
      Value<String> preferencesJson,
      Value<String?> privacyNoticeVersion,
      Value<String?> ageBand,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LocalUsersTableReferences
    extends BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser> {
  $$LocalUsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ArgoConnectionsTable, List<ArgoConnection>>
  _argoConnectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.argoConnections,
    aliasName: $_aliasNameGenerator(
      db.localUsers.id,
      db.argoConnections.userId,
    ),
  );

  $$ArgoConnectionsTableProcessedTableManager get argoConnectionsRefs {
    final manager = $$ArgoConnectionsTableTableManager(
      $_db,
      $_db.argoConnections,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _argoConnectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompletionsTable, List<Completion>>
  _completionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.completions,
    aliasName: $_aliasNameGenerator(db.localUsers.id, db.completions.userId),
  );

  $$CompletionsTableProcessedTableManager get completionsRefs {
    final manager = $$CompletionsTableTableManager(
      $_db,
      $_db.completions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_completionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: $_aliasNameGenerator(db.localUsers.id, db.reminders.userId),
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privacyNoticeVersion => $composableBuilder(
    column: $table.privacyNoticeVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> argoConnectionsRefs(
    Expression<bool> Function($$ArgoConnectionsTableFilterComposer f) f,
  ) {
    final $$ArgoConnectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.argoConnections,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArgoConnectionsTableFilterComposer(
            $db: $db,
            $table: $db.argoConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> completionsRefs(
    Expression<bool> Function($$CompletionsTableFilterComposer f) f,
  ) {
    final $$CompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableFilterComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privacyNoticeVersion => $composableBuilder(
    column: $table.privacyNoticeVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get privacyNoticeVersion => $composableBuilder(
    column: $table.privacyNoticeVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ageBand =>
      $composableBuilder(column: $table.ageBand, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> argoConnectionsRefs<T extends Object>(
    Expression<T> Function($$ArgoConnectionsTableAnnotationComposer a) f,
  ) {
    final $$ArgoConnectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.argoConnections,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArgoConnectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.argoConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> completionsRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUser,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (LocalUser, $$LocalUsersTableReferences),
          LocalUser,
          PrefetchHooks Function({
            bool argoConnectionsRefs,
            bool completionsRefs,
            bool remindersRefs,
          })
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String> preferencesJson = const Value.absent(),
                Value<String?> privacyNoticeVersion = const Value.absent(),
                Value<String?> ageBand = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion(
                id: id,
                locale: locale,
                theme: theme,
                timeZone: timeZone,
                preferencesJson: preferencesJson,
                privacyNoticeVersion: privacyNoticeVersion,
                ageBand: ageBand,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> locale = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String> preferencesJson = const Value.absent(),
                Value<String?> privacyNoticeVersion = const Value.absent(),
                Value<String?> ageBand = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                id: id,
                locale: locale,
                theme: theme,
                timeZone: timeZone,
                preferencesJson: preferencesJson,
                privacyNoticeVersion: privacyNoticeVersion,
                ageBand: ageBand,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalUsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                argoConnectionsRefs = false,
                completionsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (argoConnectionsRefs) db.argoConnections,
                    if (completionsRefs) db.completions,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (argoConnectionsRefs)
                        await $_getPrefetchedData<
                          LocalUser,
                          $LocalUsersTable,
                          ArgoConnection
                        >(
                          currentTable: table,
                          referencedTable: $$LocalUsersTableReferences
                              ._argoConnectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).argoConnectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (completionsRefs)
                        await $_getPrefetchedData<
                          LocalUser,
                          $LocalUsersTable,
                          Completion
                        >(
                          currentTable: table,
                          referencedTable: $$LocalUsersTableReferences
                              ._completionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).completionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          LocalUser,
                          $LocalUsersTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$LocalUsersTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalUsersTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUser,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (LocalUser, $$LocalUsersTableReferences),
      LocalUser,
      PrefetchHooks Function({
        bool argoConnectionsRefs,
        bool completionsRefs,
        bool remindersRefs,
      })
    >;
typedef $$ArgoConnectionsTableCreateCompanionBuilder =
    ArgoConnectionsCompanion Function({
      required String id,
      required String userId,
      required String schoolMinistryCode,
      Value<String> role,
      required String secretReference,
      Value<String> sessionState,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ArgoConnectionsTableUpdateCompanionBuilder =
    ArgoConnectionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> schoolMinistryCode,
      Value<String> role,
      Value<String> secretReference,
      Value<String> sessionState,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ArgoConnectionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ArgoConnectionsTable, ArgoConnection> {
  $$ArgoConnectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalUsersTable _userIdTable(_$AppDatabase db) =>
      db.localUsers.createAlias(
        $_aliasNameGenerator(db.argoConnections.userId, db.localUsers.id),
      );

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager(
      $_db,
      $_db.localUsers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StudentProfilesTable, List<StudentProfile>>
  _studentProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studentProfiles,
    aliasName: $_aliasNameGenerator(
      db.argoConnections.id,
      db.studentProfiles.connectionId,
    ),
  );

  $$StudentProfilesTableProcessedTableManager get studentProfilesRefs {
    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.connectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studentProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArgoConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ArgoConnectionsTable> {
  $$ArgoConnectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolMinistryCode => $composableBuilder(
    column: $table.schoolMinistryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretReference => $composableBuilder(
    column: $table.secretReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionState => $composableBuilder(
    column: $table.sessionState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableFilterComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> studentProfilesRefs(
    Expression<bool> Function($$StudentProfilesTableFilterComposer f) f,
  ) {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.connectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArgoConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArgoConnectionsTable> {
  $$ArgoConnectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolMinistryCode => $composableBuilder(
    column: $table.schoolMinistryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretReference => $composableBuilder(
    column: $table.secretReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionState => $composableBuilder(
    column: $table.sessionState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableOrderingComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArgoConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArgoConnectionsTable> {
  $$ArgoConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schoolMinistryCode => $composableBuilder(
    column: $table.schoolMinistryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get secretReference => $composableBuilder(
    column: $table.secretReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionState => $composableBuilder(
    column: $table.sessionState,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> studentProfilesRefs<T extends Object>(
    Expression<T> Function($$StudentProfilesTableAnnotationComposer a) f,
  ) {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.connectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArgoConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArgoConnectionsTable,
          ArgoConnection,
          $$ArgoConnectionsTableFilterComposer,
          $$ArgoConnectionsTableOrderingComposer,
          $$ArgoConnectionsTableAnnotationComposer,
          $$ArgoConnectionsTableCreateCompanionBuilder,
          $$ArgoConnectionsTableUpdateCompanionBuilder,
          (ArgoConnection, $$ArgoConnectionsTableReferences),
          ArgoConnection,
          PrefetchHooks Function({bool userId, bool studentProfilesRefs})
        > {
  $$ArgoConnectionsTableTableManager(
    _$AppDatabase db,
    $ArgoConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArgoConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArgoConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArgoConnectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> schoolMinistryCode = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> secretReference = const Value.absent(),
                Value<String> sessionState = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArgoConnectionsCompanion(
                id: id,
                userId: userId,
                schoolMinistryCode: schoolMinistryCode,
                role: role,
                secretReference: secretReference,
                sessionState: sessionState,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String schoolMinistryCode,
                Value<String> role = const Value.absent(),
                required String secretReference,
                Value<String> sessionState = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ArgoConnectionsCompanion.insert(
                id: id,
                userId: userId,
                schoolMinistryCode: schoolMinistryCode,
                role: role,
                secretReference: secretReference,
                sessionState: sessionState,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArgoConnectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userId = false, studentProfilesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studentProfilesRefs) db.studentProfiles,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable:
                                        $$ArgoConnectionsTableReferences
                                            ._userIdTable(db),
                                    referencedColumn:
                                        $$ArgoConnectionsTableReferences
                                            ._userIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studentProfilesRefs)
                        await $_getPrefetchedData<
                          ArgoConnection,
                          $ArgoConnectionsTable,
                          StudentProfile
                        >(
                          currentTable: table,
                          referencedTable: $$ArgoConnectionsTableReferences
                              ._studentProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArgoConnectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).studentProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.connectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ArgoConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArgoConnectionsTable,
      ArgoConnection,
      $$ArgoConnectionsTableFilterComposer,
      $$ArgoConnectionsTableOrderingComposer,
      $$ArgoConnectionsTableAnnotationComposer,
      $$ArgoConnectionsTableCreateCompanionBuilder,
      $$ArgoConnectionsTableUpdateCompanionBuilder,
      (ArgoConnection, $$ArgoConnectionsTableReferences),
      ArgoConnection,
      PrefetchHooks Function({bool userId, bool studentProfilesRefs})
    >;
typedef $$StudentProfilesTableCreateCompanionBuilder =
    StudentProfilesCompanion Function({
      required String id,
      required String connectionId,
      required String sourceProfileId,
      required String academicYear,
      required String alias,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StudentProfilesTableUpdateCompanionBuilder =
    StudentProfilesCompanion Function({
      Value<String> id,
      Value<String> connectionId,
      Value<String> sourceProfileId,
      Value<String> academicYear,
      Value<String> alias,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StudentProfilesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StudentProfilesTable, StudentProfile> {
  $$StudentProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ArgoConnectionsTable _connectionIdTable(_$AppDatabase db) =>
      db.argoConnections.createAlias(
        $_aliasNameGenerator(
          db.studentProfiles.connectionId,
          db.argoConnections.id,
        ),
      );

  $$ArgoConnectionsTableProcessedTableManager get connectionId {
    final $_column = $_itemColumn<String>('connection_id')!;

    final manager = $$ArgoConnectionsTableTableManager(
      $_db,
      $_db.argoConnections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_connectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubjectsTable, List<Subject>> _subjectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.subjects,
    aliasName: $_aliasNameGenerator(
      db.studentProfiles.id,
      db.subjects.profileId,
    ),
  );

  $$SubjectsTableProcessedTableManager get subjectsRefs {
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subjectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceRecordsTable, List<SourceRecord>>
  _sourceRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceRecords,
    aliasName: $_aliasNameGenerator(
      db.studentProfiles.id,
      db.sourceRecords.profileId,
    ),
  );

  $$SourceRecordsTableProcessedTableManager get sourceRecordsRefs {
    final manager = $$SourceRecordsTableTableManager(
      $_db,
      $_db.sourceRecords,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HomeworkItemsTable, List<HomeworkItem>>
  _homeworkItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.homeworkItems,
    aliasName: $_aliasNameGenerator(
      db.studentProfiles.id,
      db.homeworkItems.profileId,
    ),
  );

  $$HomeworkItemsTableProcessedTableManager get homeworkItemsRefs {
    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_homeworkItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncStatesTable, List<SyncState>>
  _syncStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncStates,
    aliasName: $_aliasNameGenerator(
      db.studentProfiles.id,
      db.syncStates.profileId,
    ),
  );

  $$SyncStatesTableProcessedTableManager get syncStatesRefs {
    final manager = $$SyncStatesTableTableManager(
      $_db,
      $_db.syncStates,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $HomeworkIdentityMappingsTable,
    List<HomeworkIdentityMapping>
  >
  _homeworkIdentityMappingsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.homeworkIdentityMappings,
        aliasName: $_aliasNameGenerator(
          db.studentProfiles.id,
          db.homeworkIdentityMappings.profileId,
        ),
      );

  $$HomeworkIdentityMappingsTableProcessedTableManager
  get homeworkIdentityMappingsRefs {
    final manager = $$HomeworkIdentityMappingsTableTableManager(
      $_db,
      $_db.homeworkIdentityMappings,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _homeworkIdentityMappingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SchoolTimetableEntriesTable,
    List<SchoolTimetableEntry>
  >
  _schoolTimetableEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.schoolTimetableEntries,
        aliasName: $_aliasNameGenerator(
          db.studentProfiles.id,
          db.schoolTimetableEntries.profileId,
        ),
      );

  $$SchoolTimetableEntriesTableProcessedTableManager
  get schoolTimetableEntriesRefs {
    final manager = $$SchoolTimetableEntriesTableTableManager(
      $_db,
      $_db.schoolTimetableEntries,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _schoolTimetableEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceProfileId => $composableBuilder(
    column: $table.sourceProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ArgoConnectionsTableFilterComposer get connectionId {
    final $$ArgoConnectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.connectionId,
      referencedTable: $db.argoConnections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArgoConnectionsTableFilterComposer(
            $db: $db,
            $table: $db.argoConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subjectsRefs(
    Expression<bool> Function($$SubjectsTableFilterComposer f) f,
  ) {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceRecordsRefs(
    Expression<bool> Function($$SourceRecordsTableFilterComposer f) f,
  ) {
    final $$SourceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> homeworkItemsRefs(
    Expression<bool> Function($$HomeworkItemsTableFilterComposer f) f,
  ) {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncStatesRefs(
    Expression<bool> Function($$SyncStatesTableFilterComposer f) f,
  ) {
    final $$SyncStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncStates,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncStatesTableFilterComposer(
            $db: $db,
            $table: $db.syncStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> homeworkIdentityMappingsRefs(
    Expression<bool> Function($$HomeworkIdentityMappingsTableFilterComposer f)
    f,
  ) {
    final $$HomeworkIdentityMappingsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homeworkIdentityMappings,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomeworkIdentityMappingsTableFilterComposer(
                $db: $db,
                $table: $db.homeworkIdentityMappings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> schoolTimetableEntriesRefs(
    Expression<bool> Function($$SchoolTimetableEntriesTableFilterComposer f) f,
  ) {
    final $$SchoolTimetableEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.schoolTimetableEntries,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SchoolTimetableEntriesTableFilterComposer(
                $db: $db,
                $table: $db.schoolTimetableEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StudentProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceProfileId => $composableBuilder(
    column: $table.sourceProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ArgoConnectionsTableOrderingComposer get connectionId {
    final $$ArgoConnectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.connectionId,
      referencedTable: $db.argoConnections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArgoConnectionsTableOrderingComposer(
            $db: $db,
            $table: $db.argoConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceProfileId => $composableBuilder(
    column: $table.sourceProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ArgoConnectionsTableAnnotationComposer get connectionId {
    final $$ArgoConnectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.connectionId,
      referencedTable: $db.argoConnections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArgoConnectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.argoConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subjectsRefs<T extends Object>(
    Expression<T> Function($$SubjectsTableAnnotationComposer a) f,
  ) {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceRecordsRefs<T extends Object>(
    Expression<T> Function($$SourceRecordsTableAnnotationComposer a) f,
  ) {
    final $$SourceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> homeworkItemsRefs<T extends Object>(
    Expression<T> Function($$HomeworkItemsTableAnnotationComposer a) f,
  ) {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncStatesRefs<T extends Object>(
    Expression<T> Function($$SyncStatesTableAnnotationComposer a) f,
  ) {
    final $$SyncStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncStates,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.syncStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> homeworkIdentityMappingsRefs<T extends Object>(
    Expression<T> Function($$HomeworkIdentityMappingsTableAnnotationComposer a)
    f,
  ) {
    final $$HomeworkIdentityMappingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homeworkIdentityMappings,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomeworkIdentityMappingsTableAnnotationComposer(
                $db: $db,
                $table: $db.homeworkIdentityMappings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> schoolTimetableEntriesRefs<T extends Object>(
    Expression<T> Function($$SchoolTimetableEntriesTableAnnotationComposer a) f,
  ) {
    final $$SchoolTimetableEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.schoolTimetableEntries,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SchoolTimetableEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.schoolTimetableEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StudentProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentProfilesTable,
          StudentProfile,
          $$StudentProfilesTableFilterComposer,
          $$StudentProfilesTableOrderingComposer,
          $$StudentProfilesTableAnnotationComposer,
          $$StudentProfilesTableCreateCompanionBuilder,
          $$StudentProfilesTableUpdateCompanionBuilder,
          (StudentProfile, $$StudentProfilesTableReferences),
          StudentProfile,
          PrefetchHooks Function({
            bool connectionId,
            bool subjectsRefs,
            bool sourceRecordsRefs,
            bool homeworkItemsRefs,
            bool syncStatesRefs,
            bool homeworkIdentityMappingsRefs,
            bool schoolTimetableEntriesRefs,
          })
        > {
  $$StudentProfilesTableTableManager(
    _$AppDatabase db,
    $StudentProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> connectionId = const Value.absent(),
                Value<String> sourceProfileId = const Value.absent(),
                Value<String> academicYear = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion(
                id: id,
                connectionId: connectionId,
                sourceProfileId: sourceProfileId,
                academicYear: academicYear,
                alias: alias,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String connectionId,
                required String sourceProfileId,
                required String academicYear,
                required String alias,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion.insert(
                id: id,
                connectionId: connectionId,
                sourceProfileId: sourceProfileId,
                academicYear: academicYear,
                alias: alias,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                connectionId = false,
                subjectsRefs = false,
                sourceRecordsRefs = false,
                homeworkItemsRefs = false,
                syncStatesRefs = false,
                homeworkIdentityMappingsRefs = false,
                schoolTimetableEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subjectsRefs) db.subjects,
                    if (sourceRecordsRefs) db.sourceRecords,
                    if (homeworkItemsRefs) db.homeworkItems,
                    if (syncStatesRefs) db.syncStates,
                    if (homeworkIdentityMappingsRefs)
                      db.homeworkIdentityMappings,
                    if (schoolTimetableEntriesRefs) db.schoolTimetableEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (connectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.connectionId,
                                    referencedTable:
                                        $$StudentProfilesTableReferences
                                            ._connectionIdTable(db),
                                    referencedColumn:
                                        $$StudentProfilesTableReferences
                                            ._connectionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subjectsRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          Subject
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._subjectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).subjectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceRecordsRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          SourceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._sourceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (homeworkItemsRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          HomeworkItem
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._homeworkItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).homeworkItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (syncStatesRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          SyncState
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._syncStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).syncStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (homeworkIdentityMappingsRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          HomeworkIdentityMapping
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._homeworkIdentityMappingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).homeworkIdentityMappingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (schoolTimetableEntriesRefs)
                        await $_getPrefetchedData<
                          StudentProfile,
                          $StudentProfilesTable,
                          SchoolTimetableEntry
                        >(
                          currentTable: table,
                          referencedTable: $$StudentProfilesTableReferences
                              ._schoolTimetableEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).schoolTimetableEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentProfilesTable,
      StudentProfile,
      $$StudentProfilesTableFilterComposer,
      $$StudentProfilesTableOrderingComposer,
      $$StudentProfilesTableAnnotationComposer,
      $$StudentProfilesTableCreateCompanionBuilder,
      $$StudentProfilesTableUpdateCompanionBuilder,
      (StudentProfile, $$StudentProfilesTableReferences),
      StudentProfile,
      PrefetchHooks Function({
        bool connectionId,
        bool subjectsRefs,
        bool sourceRecordsRefs,
        bool homeworkItemsRefs,
        bool syncStatesRefs,
        bool homeworkIdentityMappingsRefs,
        bool schoolTimetableEntriesRefs,
      })
    >;
typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      required String id,
      required String profileId,
      required String academicYear,
      Value<String?> sourceSubjectId,
      required String name,
      Value<int?> colorValue,
      Value<int> rowid,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> academicYear,
      Value<String?> sourceSubjectId,
      Value<String> name,
      Value<int?> colorValue,
      Value<int> rowid,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(db.subjects.profileId, db.studentProfiles.id),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HomeworkItemsTable, List<HomeworkItem>>
  _homeworkItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.homeworkItems,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.homeworkItems.subjectId),
  );

  $$HomeworkItemsTableProcessedTableManager get homeworkItemsRefs {
    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_homeworkItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceSubjectId => $composableBuilder(
    column: $table.sourceSubjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> homeworkItemsRefs(
    Expression<bool> Function($$HomeworkItemsTableFilterComposer f) f,
  ) {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceSubjectId => $composableBuilder(
    column: $table.sourceSubjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get academicYear => $composableBuilder(
    column: $table.academicYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceSubjectId => $composableBuilder(
    column: $table.sourceSubjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> homeworkItemsRefs<T extends Object>(
    Expression<T> Function($$HomeworkItemsTableAnnotationComposer a) f,
  ) {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({bool profileId, bool homeworkItemsRefs})
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> academicYear = const Value.absent(),
                Value<String?> sourceSubjectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                profileId: profileId,
                academicYear: academicYear,
                sourceSubjectId: sourceSubjectId,
                name: name,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String academicYear,
                Value<String?> sourceSubjectId = const Value.absent(),
                required String name,
                Value<int?> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                profileId: profileId,
                academicYear: academicYear,
                sourceSubjectId: sourceSubjectId,
                name: name,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, homeworkItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (homeworkItemsRefs) db.homeworkItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable: $$SubjectsTableReferences
                                        ._profileIdTable(db),
                                    referencedColumn: $$SubjectsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (homeworkItemsRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          HomeworkItem
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._homeworkItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).homeworkItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({bool profileId, bool homeworkItemsRefs})
    >;
typedef $$SourceRecordsTableCreateCompanionBuilder =
    SourceRecordsCompanion Function({
      required String id,
      required String profileId,
      required String sourcePrimaryKey,
      Value<String?> revision,
      Value<String> state,
      Value<String?> recordDay,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SourceRecordsTableUpdateCompanionBuilder =
    SourceRecordsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> sourcePrimaryKey,
      Value<String?> revision,
      Value<String> state,
      Value<String?> recordDay,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SourceRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $SourceRecordsTable, SourceRecord> {
  $$SourceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(db.sourceRecords.profileId, db.studentProfiles.id),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HomeworkItemsTable, List<HomeworkItem>>
  _homeworkItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.homeworkItems,
    aliasName: $_aliasNameGenerator(
      db.sourceRecords.id,
      db.homeworkItems.sourceRecordId,
    ),
  );

  $$HomeworkItemsTableProcessedTableManager get homeworkItemsRefs {
    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.sourceRecordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_homeworkItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePrimaryKey => $composableBuilder(
    column: $table.sourcePrimaryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordDay => $composableBuilder(
    column: $table.recordDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> homeworkItemsRefs(
    Expression<bool> Function($$HomeworkItemsTableFilterComposer f) f,
  ) {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.sourceRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePrimaryKey => $composableBuilder(
    column: $table.sourcePrimaryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordDay => $composableBuilder(
    column: $table.recordDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourcePrimaryKey => $composableBuilder(
    column: $table.sourcePrimaryKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get recordDay =>
      $composableBuilder(column: $table.recordDay, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> homeworkItemsRefs<T extends Object>(
    Expression<T> Function($$HomeworkItemsTableAnnotationComposer a) f,
  ) {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.sourceRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceRecordsTable,
          SourceRecord,
          $$SourceRecordsTableFilterComposer,
          $$SourceRecordsTableOrderingComposer,
          $$SourceRecordsTableAnnotationComposer,
          $$SourceRecordsTableCreateCompanionBuilder,
          $$SourceRecordsTableUpdateCompanionBuilder,
          (SourceRecord, $$SourceRecordsTableReferences),
          SourceRecord,
          PrefetchHooks Function({bool profileId, bool homeworkItemsRefs})
        > {
  $$SourceRecordsTableTableManager(_$AppDatabase db, $SourceRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> sourcePrimaryKey = const Value.absent(),
                Value<String?> revision = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> recordDay = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceRecordsCompanion(
                id: id,
                profileId: profileId,
                sourcePrimaryKey: sourcePrimaryKey,
                revision: revision,
                state: state,
                recordDay: recordDay,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String sourcePrimaryKey,
                Value<String?> revision = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> recordDay = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SourceRecordsCompanion.insert(
                id: id,
                profileId: profileId,
                sourcePrimaryKey: sourcePrimaryKey,
                revision: revision,
                state: state,
                recordDay: recordDay,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, homeworkItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (homeworkItemsRefs) db.homeworkItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable:
                                        $$SourceRecordsTableReferences
                                            ._profileIdTable(db),
                                    referencedColumn:
                                        $$SourceRecordsTableReferences
                                            ._profileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (homeworkItemsRefs)
                        await $_getPrefetchedData<
                          SourceRecord,
                          $SourceRecordsTable,
                          HomeworkItem
                        >(
                          currentTable: table,
                          referencedTable: $$SourceRecordsTableReferences
                              ._homeworkItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).homeworkItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceRecordsTable,
      SourceRecord,
      $$SourceRecordsTableFilterComposer,
      $$SourceRecordsTableOrderingComposer,
      $$SourceRecordsTableAnnotationComposer,
      $$SourceRecordsTableCreateCompanionBuilder,
      $$SourceRecordsTableUpdateCompanionBuilder,
      (SourceRecord, $$SourceRecordsTableReferences),
      SourceRecord,
      PrefetchHooks Function({bool profileId, bool homeworkItemsRefs})
    >;
typedef $$HomeworkItemsTableCreateCompanionBuilder =
    HomeworkItemsCompanion Function({
      required String id,
      required String profileId,
      Value<String?> sourceRecordId,
      Value<String?> subjectId,
      required String nestedIdentity,
      Value<String?> sourceItemId,
      required String identityConfidence,
      required String origin,
      required String body,
      Value<String?> personalNote,
      Value<String?> assignedOn,
      required String contentRevision,
      required DateTime firstSeenAt,
      required DateTime updatedAt,
      Value<String> sourceState,
      Value<bool> requiresIdentityReview,
      Value<int> rowid,
    });
typedef $$HomeworkItemsTableUpdateCompanionBuilder =
    HomeworkItemsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String?> sourceRecordId,
      Value<String?> subjectId,
      Value<String> nestedIdentity,
      Value<String?> sourceItemId,
      Value<String> identityConfidence,
      Value<String> origin,
      Value<String> body,
      Value<String?> personalNote,
      Value<String?> assignedOn,
      Value<String> contentRevision,
      Value<DateTime> firstSeenAt,
      Value<DateTime> updatedAt,
      Value<String> sourceState,
      Value<bool> requiresIdentityReview,
      Value<int> rowid,
    });

final class $$HomeworkItemsTableReferences
    extends BaseReferences<_$AppDatabase, $HomeworkItemsTable, HomeworkItem> {
  $$HomeworkItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(db.homeworkItems.profileId, db.studentProfiles.id),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SourceRecordsTable _sourceRecordIdTable(_$AppDatabase db) =>
      db.sourceRecords.createAlias(
        $_aliasNameGenerator(
          db.homeworkItems.sourceRecordId,
          db.sourceRecords.id,
        ),
      );

  $$SourceRecordsTableProcessedTableManager? get sourceRecordId {
    final $_column = $_itemColumn<String>('source_record_id');
    if ($_column == null) return null;
    final manager = $$SourceRecordsTableTableManager(
      $_db,
      $_db.sourceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.homeworkItems.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager? get subjectId {
    final $_column = $_itemColumn<String>('subject_id');
    if ($_column == null) return null;
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DeadlinesTable, List<Deadline>>
  _deadlinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deadlines,
    aliasName: $_aliasNameGenerator(
      db.homeworkItems.id,
      db.deadlines.homeworkId,
    ),
  );

  $$DeadlinesTableProcessedTableManager get deadlinesRefs {
    final manager = $$DeadlinesTableTableManager(
      $_db,
      $_db.deadlines,
    ).filter((f) => f.homeworkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deadlinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompletionsTable, List<Completion>>
  _completionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.completions,
    aliasName: $_aliasNameGenerator(
      db.homeworkItems.id,
      db.completions.homeworkId,
    ),
  );

  $$CompletionsTableProcessedTableManager get completionsRefs {
    final manager = $$CompletionsTableTableManager(
      $_db,
      $_db.completions,
    ).filter((f) => f.homeworkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_completionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: $_aliasNameGenerator(
      db.homeworkItems.id,
      db.reminders.homeworkId,
    ),
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.homeworkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HomeworkItemsTableFilterComposer
    extends Composer<_$AppDatabase, $HomeworkItemsTable> {
  $$HomeworkItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityConfidence => $composableBuilder(
    column: $table.identityConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalNote => $composableBuilder(
    column: $table.personalNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceState => $composableBuilder(
    column: $table.sourceState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresIdentityReview => $composableBuilder(
    column: $table.requiresIdentityReview,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableFilterComposer get sourceRecordId {
    final $$SourceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> deadlinesRefs(
    Expression<bool> Function($$DeadlinesTableFilterComposer f) f,
  ) {
    final $$DeadlinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableFilterComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> completionsRefs(
    Expression<bool> Function($$CompletionsTableFilterComposer f) f,
  ) {
    final $$CompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableFilterComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomeworkItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $HomeworkItemsTable> {
  $$HomeworkItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityConfidence => $composableBuilder(
    column: $table.identityConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalNote => $composableBuilder(
    column: $table.personalNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceState => $composableBuilder(
    column: $table.sourceState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresIdentityReview => $composableBuilder(
    column: $table.requiresIdentityReview,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableOrderingComposer get sourceRecordId {
    final $$SourceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeworkItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomeworkItemsTable> {
  $$HomeworkItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identityConfidence => $composableBuilder(
    column: $table.identityConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get personalNote => $composableBuilder(
    column: $table.personalNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get sourceState => $composableBuilder(
    column: $table.sourceState,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresIdentityReview => $composableBuilder(
    column: $table.requiresIdentityReview,
    builder: (column) => column,
  );

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableAnnotationComposer get sourceRecordId {
    final $$SourceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> deadlinesRefs<T extends Object>(
    Expression<T> Function($$DeadlinesTableAnnotationComposer a) f,
  ) {
    final $$DeadlinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableAnnotationComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> completionsRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.homeworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomeworkItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomeworkItemsTable,
          HomeworkItem,
          $$HomeworkItemsTableFilterComposer,
          $$HomeworkItemsTableOrderingComposer,
          $$HomeworkItemsTableAnnotationComposer,
          $$HomeworkItemsTableCreateCompanionBuilder,
          $$HomeworkItemsTableUpdateCompanionBuilder,
          (HomeworkItem, $$HomeworkItemsTableReferences),
          HomeworkItem,
          PrefetchHooks Function({
            bool profileId,
            bool sourceRecordId,
            bool subjectId,
            bool deadlinesRefs,
            bool completionsRefs,
            bool remindersRefs,
          })
        > {
  $$HomeworkItemsTableTableManager(_$AppDatabase db, $HomeworkItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeworkItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeworkItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeworkItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String?> sourceRecordId = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String> nestedIdentity = const Value.absent(),
                Value<String?> sourceItemId = const Value.absent(),
                Value<String> identityConfidence = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> personalNote = const Value.absent(),
                Value<String?> assignedOn = const Value.absent(),
                Value<String> contentRevision = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> sourceState = const Value.absent(),
                Value<bool> requiresIdentityReview = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeworkItemsCompanion(
                id: id,
                profileId: profileId,
                sourceRecordId: sourceRecordId,
                subjectId: subjectId,
                nestedIdentity: nestedIdentity,
                sourceItemId: sourceItemId,
                identityConfidence: identityConfidence,
                origin: origin,
                body: body,
                personalNote: personalNote,
                assignedOn: assignedOn,
                contentRevision: contentRevision,
                firstSeenAt: firstSeenAt,
                updatedAt: updatedAt,
                sourceState: sourceState,
                requiresIdentityReview: requiresIdentityReview,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                Value<String?> sourceRecordId = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                required String nestedIdentity,
                Value<String?> sourceItemId = const Value.absent(),
                required String identityConfidence,
                required String origin,
                required String body,
                Value<String?> personalNote = const Value.absent(),
                Value<String?> assignedOn = const Value.absent(),
                required String contentRevision,
                required DateTime firstSeenAt,
                required DateTime updatedAt,
                Value<String> sourceState = const Value.absent(),
                Value<bool> requiresIdentityReview = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeworkItemsCompanion.insert(
                id: id,
                profileId: profileId,
                sourceRecordId: sourceRecordId,
                subjectId: subjectId,
                nestedIdentity: nestedIdentity,
                sourceItemId: sourceItemId,
                identityConfidence: identityConfidence,
                origin: origin,
                body: body,
                personalNote: personalNote,
                assignedOn: assignedOn,
                contentRevision: contentRevision,
                firstSeenAt: firstSeenAt,
                updatedAt: updatedAt,
                sourceState: sourceState,
                requiresIdentityReview: requiresIdentityReview,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomeworkItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                sourceRecordId = false,
                subjectId = false,
                deadlinesRefs = false,
                completionsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (deadlinesRefs) db.deadlines,
                    if (completionsRefs) db.completions,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable:
                                        $$HomeworkItemsTableReferences
                                            ._profileIdTable(db),
                                    referencedColumn:
                                        $$HomeworkItemsTableReferences
                                            ._profileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceRecordId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceRecordId,
                                    referencedTable:
                                        $$HomeworkItemsTableReferences
                                            ._sourceRecordIdTable(db),
                                    referencedColumn:
                                        $$HomeworkItemsTableReferences
                                            ._sourceRecordIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$HomeworkItemsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$HomeworkItemsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (deadlinesRefs)
                        await $_getPrefetchedData<
                          HomeworkItem,
                          $HomeworkItemsTable,
                          Deadline
                        >(
                          currentTable: table,
                          referencedTable: $$HomeworkItemsTableReferences
                              ._deadlinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HomeworkItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).deadlinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeworkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (completionsRefs)
                        await $_getPrefetchedData<
                          HomeworkItem,
                          $HomeworkItemsTable,
                          Completion
                        >(
                          currentTable: table,
                          referencedTable: $$HomeworkItemsTableReferences
                              ._completionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HomeworkItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).completionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeworkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          HomeworkItem,
                          $HomeworkItemsTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$HomeworkItemsTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HomeworkItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeworkId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HomeworkItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomeworkItemsTable,
      HomeworkItem,
      $$HomeworkItemsTableFilterComposer,
      $$HomeworkItemsTableOrderingComposer,
      $$HomeworkItemsTableAnnotationComposer,
      $$HomeworkItemsTableCreateCompanionBuilder,
      $$HomeworkItemsTableUpdateCompanionBuilder,
      (HomeworkItem, $$HomeworkItemsTableReferences),
      HomeworkItem,
      PrefetchHooks Function({
        bool profileId,
        bool sourceRecordId,
        bool subjectId,
        bool deadlinesRefs,
        bool completionsRefs,
        bool remindersRefs,
      })
    >;
typedef $$DeadlinesTableCreateCompanionBuilder =
    DeadlinesCompanion Function({
      required String id,
      required String homeworkId,
      Value<String?> sourceDueOn,
      Value<String?> personalDueOn,
      Value<String?> sourceTime,
      Value<String> schoolTimeZone,
      Value<String> precision,
      Value<String> provenance,
      Value<int> rowid,
    });
typedef $$DeadlinesTableUpdateCompanionBuilder =
    DeadlinesCompanion Function({
      Value<String> id,
      Value<String> homeworkId,
      Value<String?> sourceDueOn,
      Value<String?> personalDueOn,
      Value<String?> sourceTime,
      Value<String> schoolTimeZone,
      Value<String> precision,
      Value<String> provenance,
      Value<int> rowid,
    });

final class $$DeadlinesTableReferences
    extends BaseReferences<_$AppDatabase, $DeadlinesTable, Deadline> {
  $$DeadlinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HomeworkItemsTable _homeworkIdTable(_$AppDatabase db) =>
      db.homeworkItems.createAlias(
        $_aliasNameGenerator(db.deadlines.homeworkId, db.homeworkItems.id),
      );

  $$HomeworkItemsTableProcessedTableManager get homeworkId {
    final $_column = $_itemColumn<String>('homework_id')!;

    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeworkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeadlinesTableFilterComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceDueOn => $composableBuilder(
    column: $table.sourceDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalDueOn => $composableBuilder(
    column: $table.personalDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTime => $composableBuilder(
    column: $table.sourceTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolTimeZone => $composableBuilder(
    column: $table.schoolTimeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get precision => $composableBuilder(
    column: $table.precision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  $$HomeworkItemsTableFilterComposer get homeworkId {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceDueOn => $composableBuilder(
    column: $table.sourceDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalDueOn => $composableBuilder(
    column: $table.personalDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTime => $composableBuilder(
    column: $table.sourceTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolTimeZone => $composableBuilder(
    column: $table.schoolTimeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get precision => $composableBuilder(
    column: $table.precision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  $$HomeworkItemsTableOrderingComposer get homeworkId {
    final $$HomeworkItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableOrderingComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceDueOn => $composableBuilder(
    column: $table.sourceDueOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalDueOn => $composableBuilder(
    column: $table.personalDueOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceTime => $composableBuilder(
    column: $table.sourceTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schoolTimeZone => $composableBuilder(
    column: $table.schoolTimeZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get precision =>
      $composableBuilder(column: $table.precision, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  $$HomeworkItemsTableAnnotationComposer get homeworkId {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeadlinesTable,
          Deadline,
          $$DeadlinesTableFilterComposer,
          $$DeadlinesTableOrderingComposer,
          $$DeadlinesTableAnnotationComposer,
          $$DeadlinesTableCreateCompanionBuilder,
          $$DeadlinesTableUpdateCompanionBuilder,
          (Deadline, $$DeadlinesTableReferences),
          Deadline,
          PrefetchHooks Function({bool homeworkId})
        > {
  $$DeadlinesTableTableManager(_$AppDatabase db, $DeadlinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeadlinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeadlinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeadlinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> homeworkId = const Value.absent(),
                Value<String?> sourceDueOn = const Value.absent(),
                Value<String?> personalDueOn = const Value.absent(),
                Value<String?> sourceTime = const Value.absent(),
                Value<String> schoolTimeZone = const Value.absent(),
                Value<String> precision = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeadlinesCompanion(
                id: id,
                homeworkId: homeworkId,
                sourceDueOn: sourceDueOn,
                personalDueOn: personalDueOn,
                sourceTime: sourceTime,
                schoolTimeZone: schoolTimeZone,
                precision: precision,
                provenance: provenance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String homeworkId,
                Value<String?> sourceDueOn = const Value.absent(),
                Value<String?> personalDueOn = const Value.absent(),
                Value<String?> sourceTime = const Value.absent(),
                Value<String> schoolTimeZone = const Value.absent(),
                Value<String> precision = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeadlinesCompanion.insert(
                id: id,
                homeworkId: homeworkId,
                sourceDueOn: sourceDueOn,
                personalDueOn: personalDueOn,
                sourceTime: sourceTime,
                schoolTimeZone: schoolTimeZone,
                precision: precision,
                provenance: provenance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeadlinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeworkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (homeworkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.homeworkId,
                                referencedTable: $$DeadlinesTableReferences
                                    ._homeworkIdTable(db),
                                referencedColumn: $$DeadlinesTableReferences
                                    ._homeworkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeadlinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeadlinesTable,
      Deadline,
      $$DeadlinesTableFilterComposer,
      $$DeadlinesTableOrderingComposer,
      $$DeadlinesTableAnnotationComposer,
      $$DeadlinesTableCreateCompanionBuilder,
      $$DeadlinesTableUpdateCompanionBuilder,
      (Deadline, $$DeadlinesTableReferences),
      Deadline,
      PrefetchHooks Function({bool homeworkId})
    >;
typedef $$CompletionsTableCreateCompanionBuilder =
    CompletionsCompanion Function({
      required String userId,
      required String homeworkId,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      Value<String?> completedRevision,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CompletionsTableUpdateCompanionBuilder =
    CompletionsCompanion Function({
      Value<String> userId,
      Value<String> homeworkId,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      Value<String?> completedRevision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CompletionsTableReferences
    extends BaseReferences<_$AppDatabase, $CompletionsTable, Completion> {
  $$CompletionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalUsersTable _userIdTable(_$AppDatabase db) =>
      db.localUsers.createAlias(
        $_aliasNameGenerator(db.completions.userId, db.localUsers.id),
      );

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager(
      $_db,
      $_db.localUsers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HomeworkItemsTable _homeworkIdTable(_$AppDatabase db) =>
      db.homeworkItems.createAlias(
        $_aliasNameGenerator(db.completions.homeworkId, db.homeworkItems.id),
      );

  $$HomeworkItemsTableProcessedTableManager get homeworkId {
    final $_column = $_itemColumn<String>('homework_id')!;

    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeworkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedRevision => $composableBuilder(
    column: $table.completedRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableFilterComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableFilterComposer get homeworkId {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedRevision => $composableBuilder(
    column: $table.completedRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableOrderingComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableOrderingComposer get homeworkId {
    final $$HomeworkItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableOrderingComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<String> get completedRevision => $composableBuilder(
    column: $table.completedRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableAnnotationComposer get homeworkId {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletionsTable,
          Completion,
          $$CompletionsTableFilterComposer,
          $$CompletionsTableOrderingComposer,
          $$CompletionsTableAnnotationComposer,
          $$CompletionsTableCreateCompanionBuilder,
          $$CompletionsTableUpdateCompanionBuilder,
          (Completion, $$CompletionsTableReferences),
          Completion,
          PrefetchHooks Function({bool userId, bool homeworkId})
        > {
  $$CompletionsTableTableManager(_$AppDatabase db, $CompletionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> homeworkId = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> completedRevision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletionsCompanion(
                userId: userId,
                homeworkId: homeworkId,
                isDone: isDone,
                doneAt: doneAt,
                completedRevision: completedRevision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String homeworkId,
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> completedRevision = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CompletionsCompanion.insert(
                userId: userId,
                homeworkId: homeworkId,
                isDone: isDone,
                doneAt: doneAt,
                completedRevision: completedRevision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, homeworkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$CompletionsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$CompletionsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (homeworkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.homeworkId,
                                referencedTable: $$CompletionsTableReferences
                                    ._homeworkIdTable(db),
                                referencedColumn: $$CompletionsTableReferences
                                    ._homeworkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletionsTable,
      Completion,
      $$CompletionsTableFilterComposer,
      $$CompletionsTableOrderingComposer,
      $$CompletionsTableAnnotationComposer,
      $$CompletionsTableCreateCompanionBuilder,
      $$CompletionsTableUpdateCompanionBuilder,
      (Completion, $$CompletionsTableReferences),
      Completion,
      PrefetchHooks Function({bool userId, bool homeworkId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String userId,
      required String homeworkId,
      required DateTime remindAt,
      Value<String> state,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> homeworkId,
      Value<DateTime> remindAt,
      Value<String> state,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalUsersTable _userIdTable(_$AppDatabase db) => db.localUsers
      .createAlias($_aliasNameGenerator(db.reminders.userId, db.localUsers.id));

  $$LocalUsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$LocalUsersTableTableManager(
      $_db,
      $_db.localUsers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HomeworkItemsTable _homeworkIdTable(_$AppDatabase db) =>
      db.homeworkItems.createAlias(
        $_aliasNameGenerator(db.reminders.homeworkId, db.homeworkItems.id),
      );

  $$HomeworkItemsTableProcessedTableManager get homeworkId {
    final $_column = $_itemColumn<String>('homework_id')!;

    final manager = $$HomeworkItemsTableTableManager(
      $_db,
      $_db.homeworkItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeworkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalUsersTableFilterComposer get userId {
    final $$LocalUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableFilterComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableFilterComposer get homeworkId {
    final $$HomeworkItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableFilterComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalUsersTableOrderingComposer get userId {
    final $$LocalUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableOrderingComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableOrderingComposer get homeworkId {
    final $$HomeworkItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableOrderingComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  $$LocalUsersTableAnnotationComposer get userId {
    final $$LocalUsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.localUsers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalUsersTableAnnotationComposer(
            $db: $db,
            $table: $db.localUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HomeworkItemsTableAnnotationComposer get homeworkId {
    final $$HomeworkItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeworkId,
      referencedTable: $db.homeworkItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeworkItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeworkItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool userId, bool homeworkId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> homeworkId = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                userId: userId,
                homeworkId: homeworkId,
                remindAt: remindAt,
                state: state,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String homeworkId,
                required DateTime remindAt,
                Value<String> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                userId: userId,
                homeworkId: homeworkId,
                remindAt: remindAt,
                state: state,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, homeworkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$RemindersTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (homeworkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.homeworkId,
                                referencedTable: $$RemindersTableReferences
                                    ._homeworkIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._homeworkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool userId, bool homeworkId})
    >;
typedef $$SyncStatesTableCreateCompanionBuilder =
    SyncStatesCompanion Function({
      required String profileId,
      required String adapterVersion,
      Value<String?> cursor,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime?> lastSuccessAt,
      Value<DateTime?> coverageStart,
      Value<String?> errorCode,
      Value<int> rowid,
    });
typedef $$SyncStatesTableUpdateCompanionBuilder =
    SyncStatesCompanion Function({
      Value<String> profileId,
      Value<String> adapterVersion,
      Value<String?> cursor,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime?> lastSuccessAt,
      Value<DateTime?> coverageStart,
      Value<String?> errorCode,
      Value<int> rowid,
    });

final class $$SyncStatesTableReferences
    extends BaseReferences<_$AppDatabase, $SyncStatesTable, SyncState> {
  $$SyncStatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(db.syncStates.profileId, db.studentProfiles.id),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get adapterVersion => $composableBuilder(
    column: $table.adapterVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get coverageStart => $composableBuilder(
    column: $table.coverageStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get adapterVersion => $composableBuilder(
    column: $table.adapterVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get coverageStart => $composableBuilder(
    column: $table.coverageStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get adapterVersion => $composableBuilder(
    column: $table.adapterVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get coverageStart => $composableBuilder(
    column: $table.coverageStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStatesTable,
          SyncState,
          $$SyncStatesTableFilterComposer,
          $$SyncStatesTableOrderingComposer,
          $$SyncStatesTableAnnotationComposer,
          $$SyncStatesTableCreateCompanionBuilder,
          $$SyncStatesTableUpdateCompanionBuilder,
          (SyncState, $$SyncStatesTableReferences),
          SyncState,
          PrefetchHooks Function({bool profileId})
        > {
  $$SyncStatesTableTableManager(_$AppDatabase db, $SyncStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> adapterVersion = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                Value<DateTime?> coverageStart = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion(
                profileId: profileId,
                adapterVersion: adapterVersion,
                cursor: cursor,
                lastAttemptAt: lastAttemptAt,
                lastSuccessAt: lastSuccessAt,
                coverageStart: coverageStart,
                errorCode: errorCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String adapterVersion,
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                Value<DateTime?> coverageStart = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion.insert(
                profileId: profileId,
                adapterVersion: adapterVersion,
                cursor: cursor,
                lastAttemptAt: lastAttemptAt,
                lastSuccessAt: lastSuccessAt,
                coverageStart: coverageStart,
                errorCode: errorCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$SyncStatesTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$SyncStatesTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStatesTable,
      SyncState,
      $$SyncStatesTableFilterComposer,
      $$SyncStatesTableOrderingComposer,
      $$SyncStatesTableAnnotationComposer,
      $$SyncStatesTableCreateCompanionBuilder,
      $$SyncStatesTableUpdateCompanionBuilder,
      (SyncState, $$SyncStatesTableReferences),
      SyncState,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$HomeworkIdentityMappingsTableCreateCompanionBuilder =
    HomeworkIdentityMappingsCompanion Function({
      required String profileId,
      required String sourceRecordId,
      required String nestedIdentity,
      required String homeworkId,
      required String contentRevision,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HomeworkIdentityMappingsTableUpdateCompanionBuilder =
    HomeworkIdentityMappingsCompanion Function({
      Value<String> profileId,
      Value<String> sourceRecordId,
      Value<String> nestedIdentity,
      Value<String> homeworkId,
      Value<String> contentRevision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HomeworkIdentityMappingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HomeworkIdentityMappingsTable,
          HomeworkIdentityMapping
        > {
  $$HomeworkIdentityMappingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(
          db.homeworkIdentityMappings.profileId,
          db.studentProfiles.id,
        ),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HomeworkIdentityMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $HomeworkIdentityMappingsTable> {
  $$HomeworkIdentityMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeworkId => $composableBuilder(
    column: $table.homeworkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeworkIdentityMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HomeworkIdentityMappingsTable> {
  $$HomeworkIdentityMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeworkId => $composableBuilder(
    column: $table.homeworkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeworkIdentityMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomeworkIdentityMappingsTable> {
  $$HomeworkIdentityMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nestedIdentity => $composableBuilder(
    column: $table.nestedIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeworkId => $composableBuilder(
    column: $table.homeworkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomeworkIdentityMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomeworkIdentityMappingsTable,
          HomeworkIdentityMapping,
          $$HomeworkIdentityMappingsTableFilterComposer,
          $$HomeworkIdentityMappingsTableOrderingComposer,
          $$HomeworkIdentityMappingsTableAnnotationComposer,
          $$HomeworkIdentityMappingsTableCreateCompanionBuilder,
          $$HomeworkIdentityMappingsTableUpdateCompanionBuilder,
          (HomeworkIdentityMapping, $$HomeworkIdentityMappingsTableReferences),
          HomeworkIdentityMapping,
          PrefetchHooks Function({bool profileId})
        > {
  $$HomeworkIdentityMappingsTableTableManager(
    _$AppDatabase db,
    $HomeworkIdentityMappingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeworkIdentityMappingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$HomeworkIdentityMappingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HomeworkIdentityMappingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> sourceRecordId = const Value.absent(),
                Value<String> nestedIdentity = const Value.absent(),
                Value<String> homeworkId = const Value.absent(),
                Value<String> contentRevision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeworkIdentityMappingsCompanion(
                profileId: profileId,
                sourceRecordId: sourceRecordId,
                nestedIdentity: nestedIdentity,
                homeworkId: homeworkId,
                contentRevision: contentRevision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String sourceRecordId,
                required String nestedIdentity,
                required String homeworkId,
                required String contentRevision,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HomeworkIdentityMappingsCompanion.insert(
                profileId: profileId,
                sourceRecordId: sourceRecordId,
                nestedIdentity: nestedIdentity,
                homeworkId: homeworkId,
                contentRevision: contentRevision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomeworkIdentityMappingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$HomeworkIdentityMappingsTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$HomeworkIdentityMappingsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HomeworkIdentityMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomeworkIdentityMappingsTable,
      HomeworkIdentityMapping,
      $$HomeworkIdentityMappingsTableFilterComposer,
      $$HomeworkIdentityMappingsTableOrderingComposer,
      $$HomeworkIdentityMappingsTableAnnotationComposer,
      $$HomeworkIdentityMappingsTableCreateCompanionBuilder,
      $$HomeworkIdentityMappingsTableUpdateCompanionBuilder,
      (HomeworkIdentityMapping, $$HomeworkIdentityMappingsTableReferences),
      HomeworkIdentityMapping,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$DiagnosticEntriesTableCreateCompanionBuilder =
    DiagnosticEntriesCompanion Function({
      required String id,
      required DateTime occurredAt,
      required String area,
      required String code,
      Value<int> rowid,
    });
typedef $$DiagnosticEntriesTableUpdateCompanionBuilder =
    DiagnosticEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> occurredAt,
      Value<String> area,
      Value<String> code,
      Value<int> rowid,
    });

class $$DiagnosticEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosticEntriesTable> {
  $$DiagnosticEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiagnosticEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosticEntriesTable> {
  $$DiagnosticEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosticEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosticEntriesTable> {
  $$DiagnosticEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$DiagnosticEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosticEntriesTable,
          DiagnosticEntry,
          $$DiagnosticEntriesTableFilterComposer,
          $$DiagnosticEntriesTableOrderingComposer,
          $$DiagnosticEntriesTableAnnotationComposer,
          $$DiagnosticEntriesTableCreateCompanionBuilder,
          $$DiagnosticEntriesTableUpdateCompanionBuilder,
          (
            DiagnosticEntry,
            BaseReferences<
              _$AppDatabase,
              $DiagnosticEntriesTable,
              DiagnosticEntry
            >,
          ),
          DiagnosticEntry,
          PrefetchHooks Function()
        > {
  $$DiagnosticEntriesTableTableManager(
    _$AppDatabase db,
    $DiagnosticEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosticEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosticEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosticEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagnosticEntriesCompanion(
                id: id,
                occurredAt: occurredAt,
                area: area,
                code: code,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime occurredAt,
                required String area,
                required String code,
                Value<int> rowid = const Value.absent(),
              }) => DiagnosticEntriesCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                area: area,
                code: code,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiagnosticEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosticEntriesTable,
      DiagnosticEntry,
      $$DiagnosticEntriesTableFilterComposer,
      $$DiagnosticEntriesTableOrderingComposer,
      $$DiagnosticEntriesTableAnnotationComposer,
      $$DiagnosticEntriesTableCreateCompanionBuilder,
      $$DiagnosticEntriesTableUpdateCompanionBuilder,
      (
        DiagnosticEntry,
        BaseReferences<_$AppDatabase, $DiagnosticEntriesTable, DiagnosticEntry>,
      ),
      DiagnosticEntry,
      PrefetchHooks Function()
    >;
typedef $$SchoolTimetableEntriesTableCreateCompanionBuilder =
    SchoolTimetableEntriesCompanion Function({
      required String id,
      required String profileId,
      required int weekday,
      required int period,
      required String professorName,
      Value<String?> subjectName,
      Value<int?> subjectColorValue,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SchoolTimetableEntriesTableUpdateCompanionBuilder =
    SchoolTimetableEntriesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<int> weekday,
      Value<int> period,
      Value<String> professorName,
      Value<String?> subjectName,
      Value<int?> subjectColorValue,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SchoolTimetableEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SchoolTimetableEntriesTable,
          SchoolTimetableEntry
        > {
  $$SchoolTimetableEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.studentProfiles.createAlias(
        $_aliasNameGenerator(
          db.schoolTimetableEntries.profileId,
          db.studentProfiles.id,
        ),
      );

  $$StudentProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$StudentProfilesTableTableManager(
      $_db,
      $_db.studentProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SchoolTimetableEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolTimetableEntriesTable> {
  $$SchoolTimetableEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get professorName => $composableBuilder(
    column: $table.professorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectColorValue => $composableBuilder(
    column: $table.subjectColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentProfilesTableFilterComposer get profileId {
    final $$StudentProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableFilterComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchoolTimetableEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolTimetableEntriesTable> {
  $$SchoolTimetableEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get professorName => $composableBuilder(
    column: $table.professorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectColorValue => $composableBuilder(
    column: $table.subjectColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentProfilesTableOrderingComposer get profileId {
    final $$StudentProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchoolTimetableEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolTimetableEntriesTable> {
  $$SchoolTimetableEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get professorName => $composableBuilder(
    column: $table.professorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subjectColorValue => $composableBuilder(
    column: $table.subjectColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentProfilesTableAnnotationComposer get profileId {
    final $$StudentProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.studentProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.studentProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchoolTimetableEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolTimetableEntriesTable,
          SchoolTimetableEntry,
          $$SchoolTimetableEntriesTableFilterComposer,
          $$SchoolTimetableEntriesTableOrderingComposer,
          $$SchoolTimetableEntriesTableAnnotationComposer,
          $$SchoolTimetableEntriesTableCreateCompanionBuilder,
          $$SchoolTimetableEntriesTableUpdateCompanionBuilder,
          (SchoolTimetableEntry, $$SchoolTimetableEntriesTableReferences),
          SchoolTimetableEntry,
          PrefetchHooks Function({bool profileId})
        > {
  $$SchoolTimetableEntriesTableTableManager(
    _$AppDatabase db,
    $SchoolTimetableEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolTimetableEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SchoolTimetableEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SchoolTimetableEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> period = const Value.absent(),
                Value<String> professorName = const Value.absent(),
                Value<String?> subjectName = const Value.absent(),
                Value<int?> subjectColorValue = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolTimetableEntriesCompanion(
                id: id,
                profileId: profileId,
                weekday: weekday,
                period: period,
                professorName: professorName,
                subjectName: subjectName,
                subjectColorValue: subjectColorValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required int weekday,
                required int period,
                required String professorName,
                Value<String?> subjectName = const Value.absent(),
                Value<int?> subjectColorValue = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SchoolTimetableEntriesCompanion.insert(
                id: id,
                profileId: profileId,
                weekday: weekday,
                period: period,
                professorName: professorName,
                subjectName: subjectName,
                subjectColorValue: subjectColorValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchoolTimetableEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$SchoolTimetableEntriesTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$SchoolTimetableEntriesTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SchoolTimetableEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolTimetableEntriesTable,
      SchoolTimetableEntry,
      $$SchoolTimetableEntriesTableFilterComposer,
      $$SchoolTimetableEntriesTableOrderingComposer,
      $$SchoolTimetableEntriesTableAnnotationComposer,
      $$SchoolTimetableEntriesTableCreateCompanionBuilder,
      $$SchoolTimetableEntriesTableUpdateCompanionBuilder,
      (SchoolTimetableEntry, $$SchoolTimetableEntriesTableReferences),
      SchoolTimetableEntry,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$ArgoConnectionsTableTableManager get argoConnections =>
      $$ArgoConnectionsTableTableManager(_db, _db.argoConnections);
  $$StudentProfilesTableTableManager get studentProfiles =>
      $$StudentProfilesTableTableManager(_db, _db.studentProfiles);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$SourceRecordsTableTableManager get sourceRecords =>
      $$SourceRecordsTableTableManager(_db, _db.sourceRecords);
  $$HomeworkItemsTableTableManager get homeworkItems =>
      $$HomeworkItemsTableTableManager(_db, _db.homeworkItems);
  $$DeadlinesTableTableManager get deadlines =>
      $$DeadlinesTableTableManager(_db, _db.deadlines);
  $$CompletionsTableTableManager get completions =>
      $$CompletionsTableTableManager(_db, _db.completions);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$SyncStatesTableTableManager get syncStates =>
      $$SyncStatesTableTableManager(_db, _db.syncStates);
  $$HomeworkIdentityMappingsTableTableManager get homeworkIdentityMappings =>
      $$HomeworkIdentityMappingsTableTableManager(
        _db,
        _db.homeworkIdentityMappings,
      );
  $$DiagnosticEntriesTableTableManager get diagnosticEntries =>
      $$DiagnosticEntriesTableTableManager(_db, _db.diagnosticEntries);
  $$SchoolTimetableEntriesTableTableManager get schoolTimetableEntries =>
      $$SchoolTimetableEntriesTableTableManager(
        _db,
        _db.schoolTimetableEntries,
      );
}
