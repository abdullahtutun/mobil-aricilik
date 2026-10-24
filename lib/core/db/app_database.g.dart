// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OrganizationsTable extends Organizations
    with TableInfo<$OrganizationsTable, OrganizationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trRegistrationNoMeta = const VerificationMeta(
    'trRegistrationNo',
  );
  @override
  late final GeneratedColumn<String> trRegistrationNo = GeneratedColumn<String>(
    'tr_registration_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trAksNoMeta = const VerificationMeta(
    'trAksNo',
  );
  @override
  late final GeneratedColumn<String> trAksNo = GeneratedColumn<String>(
    'tr_aks_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HiveCountRange?, String>
  hiveCountRange =
      GeneratedColumn<String>(
        'hive_count_range',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HiveCountRange?>(
        $OrganizationsTable.$converterhiveCountRangen,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    name,
    countryCode,
    currency,
    trRegistrationNo,
    trAksNo,
    hiveCountRange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
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
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('tr_registration_no')) {
      context.handle(
        _trRegistrationNoMeta,
        trRegistrationNo.isAcceptableOrUnknown(
          data['tr_registration_no']!,
          _trRegistrationNoMeta,
        ),
      );
    }
    if (data.containsKey('tr_aks_no')) {
      context.handle(
        _trAksNoMeta,
        trAksNo.isAcceptableOrUnknown(data['tr_aks_no']!, _trAksNoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganizationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      trRegistrationNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tr_registration_no'],
      ),
      trAksNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tr_aks_no'],
      ),
      hiveCountRange: $OrganizationsTable.$converterhiveCountRangen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}hive_count_range'],
        ),
      ),
    );
  }

  @override
  $OrganizationsTable createAlias(String alias) {
    return $OrganizationsTable(attachedDatabase, alias);
  }

  static TypeConverter<HiveCountRange, String> $converterhiveCountRange =
      const ServerEnumConverter(HiveCountRange.values);
  static TypeConverter<HiveCountRange?, String?> $converterhiveCountRangen =
      NullAwareTypeConverter.wrap($converterhiveCountRange);
}

class OrganizationRow extends DataClass implements Insertable<OrganizationRow> {
  /// İstemcide üretilen UUIDv7.
  final String id;
  final DateTime createdAt;

  /// Son yazan kazanır; her yerel yazmada şimdiye çekilir.
  final DateTime updatedAt;

  /// Sunucu doldurur; yerelde oluşan kayıtta senkrona kadar boş.
  final String? createdBy;

  /// Yumuşak silme: dolu satır listelerde görünmez.
  final DateTime? deletedAt;

  /// Çekme imleci; sunucuya henüz ulaşmamış kayıtta boş.
  final int? serverSeq;
  final String name;

  /// ISO 3166-1 alpha-2, büyük harf.
  final String countryCode;

  /// ISO 4217.
  final String currency;

  /// Yalnız TR profilinde: işletme tescil no ve AKS no.
  final String? trRegistrationNo;
  final String? trAksNo;
  final HiveCountRange? hiveCountRange;
  const OrganizationRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.deletedAt,
    this.serverSeq,
    required this.name,
    required this.countryCode,
    required this.currency,
    this.trRegistrationNo,
    this.trAksNo,
    this.hiveCountRange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || serverSeq != null) {
      map['server_seq'] = Variable<int>(serverSeq);
    }
    map['name'] = Variable<String>(name);
    map['country_code'] = Variable<String>(countryCode);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || trRegistrationNo != null) {
      map['tr_registration_no'] = Variable<String>(trRegistrationNo);
    }
    if (!nullToAbsent || trAksNo != null) {
      map['tr_aks_no'] = Variable<String>(trAksNo);
    }
    if (!nullToAbsent || hiveCountRange != null) {
      map['hive_count_range'] = Variable<String>(
        $OrganizationsTable.$converterhiveCountRangen.toSql(hiveCountRange),
      );
    }
    return map;
  }

  OrganizationsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      serverSeq: serverSeq == null && nullToAbsent
          ? const Value.absent()
          : Value(serverSeq),
      name: Value(name),
      countryCode: Value(countryCode),
      currency: Value(currency),
      trRegistrationNo: trRegistrationNo == null && nullToAbsent
          ? const Value.absent()
          : Value(trRegistrationNo),
      trAksNo: trAksNo == null && nullToAbsent
          ? const Value.absent()
          : Value(trAksNo),
      hiveCountRange: hiveCountRange == null && nullToAbsent
          ? const Value.absent()
          : Value(hiveCountRange),
    );
  }

  factory OrganizationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizationRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      serverSeq: serializer.fromJson<int?>(json['serverSeq']),
      name: serializer.fromJson<String>(json['name']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      currency: serializer.fromJson<String>(json['currency']),
      trRegistrationNo: serializer.fromJson<String?>(json['trRegistrationNo']),
      trAksNo: serializer.fromJson<String?>(json['trAksNo']),
      hiveCountRange: serializer.fromJson<HiveCountRange?>(
        json['hiveCountRange'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'serverSeq': serializer.toJson<int?>(serverSeq),
      'name': serializer.toJson<String>(name),
      'countryCode': serializer.toJson<String>(countryCode),
      'currency': serializer.toJson<String>(currency),
      'trRegistrationNo': serializer.toJson<String?>(trRegistrationNo),
      'trAksNo': serializer.toJson<String?>(trAksNo),
      'hiveCountRange': serializer.toJson<HiveCountRange?>(hiveCountRange),
    };
  }

  OrganizationRow copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> createdBy = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<int?> serverSeq = const Value.absent(),
    String? name,
    String? countryCode,
    String? currency,
    Value<String?> trRegistrationNo = const Value.absent(),
    Value<String?> trAksNo = const Value.absent(),
    Value<HiveCountRange?> hiveCountRange = const Value.absent(),
  }) => OrganizationRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    serverSeq: serverSeq.present ? serverSeq.value : this.serverSeq,
    name: name ?? this.name,
    countryCode: countryCode ?? this.countryCode,
    currency: currency ?? this.currency,
    trRegistrationNo: trRegistrationNo.present
        ? trRegistrationNo.value
        : this.trRegistrationNo,
    trAksNo: trAksNo.present ? trAksNo.value : this.trAksNo,
    hiveCountRange: hiveCountRange.present
        ? hiveCountRange.value
        : this.hiveCountRange,
  );
  OrganizationRow copyWithCompanion(OrganizationsCompanion data) {
    return OrganizationRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
      name: data.name.present ? data.name.value : this.name,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      currency: data.currency.present ? data.currency.value : this.currency,
      trRegistrationNo: data.trRegistrationNo.present
          ? data.trRegistrationNo.value
          : this.trRegistrationNo,
      trAksNo: data.trAksNo.present ? data.trAksNo.value : this.trAksNo,
      hiveCountRange: data.hiveCountRange.present
          ? data.hiveCountRange.value
          : this.hiveCountRange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('name: $name, ')
          ..write('countryCode: $countryCode, ')
          ..write('currency: $currency, ')
          ..write('trRegistrationNo: $trRegistrationNo, ')
          ..write('trAksNo: $trAksNo, ')
          ..write('hiveCountRange: $hiveCountRange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    name,
    countryCode,
    currency,
    trRegistrationNo,
    trAksNo,
    hiveCountRange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizationRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.deletedAt == this.deletedAt &&
          other.serverSeq == this.serverSeq &&
          other.name == this.name &&
          other.countryCode == this.countryCode &&
          other.currency == this.currency &&
          other.trRegistrationNo == this.trRegistrationNo &&
          other.trAksNo == this.trAksNo &&
          other.hiveCountRange == this.hiveCountRange);
}

class OrganizationsCompanion extends UpdateCompanion<OrganizationRow> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> name;
  final Value<String> countryCode;
  final Value<String> currency;
  final Value<String?> trRegistrationNo;
  final Value<String?> trAksNo;
  final Value<HiveCountRange?> hiveCountRange;
  final Value<int> rowid;
  const OrganizationsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.name = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.currency = const Value.absent(),
    this.trRegistrationNo = const Value.absent(),
    this.trAksNo = const Value.absent(),
    this.hiveCountRange = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String name,
    required String countryCode,
    required String currency,
    this.trRegistrationNo = const Value.absent(),
    this.trAksNo = const Value.absent(),
    this.hiveCountRange = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       countryCode = Value(countryCode),
       currency = Value(currency);
  static Insertable<OrganizationRow> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? name,
    Expression<String>? countryCode,
    Expression<String>? currency,
    Expression<String>? trRegistrationNo,
    Expression<String>? trAksNo,
    Expression<String>? hiveCountRange,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (name != null) 'name': name,
      if (countryCode != null) 'country_code': countryCode,
      if (currency != null) 'currency': currency,
      if (trRegistrationNo != null) 'tr_registration_no': trRegistrationNo,
      if (trAksNo != null) 'tr_aks_no': trAksNo,
      if (hiveCountRange != null) 'hive_count_range': hiveCountRange,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? name,
    Value<String>? countryCode,
    Value<String>? currency,
    Value<String?>? trRegistrationNo,
    Value<String?>? trAksNo,
    Value<HiveCountRange?>? hiveCountRange,
    Value<int>? rowid,
  }) {
    return OrganizationsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      currency: currency ?? this.currency,
      trRegistrationNo: trRegistrationNo ?? this.trRegistrationNo,
      trAksNo: trAksNo ?? this.trAksNo,
      hiveCountRange: hiveCountRange ?? this.hiveCountRange,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (trRegistrationNo.present) {
      map['tr_registration_no'] = Variable<String>(trRegistrationNo.value);
    }
    if (trAksNo.present) {
      map['tr_aks_no'] = Variable<String>(trAksNo.value);
    }
    if (hiveCountRange.present) {
      map['hive_count_range'] = Variable<String>(
        $OrganizationsTable.$converterhiveCountRangen.toSql(
          hiveCountRange.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('name: $name, ')
          ..write('countryCode: $countryCode, ')
          ..write('currency: $currency, ')
          ..write('trRegistrationNo: $trRegistrationNo, ')
          ..write('trAksNo: $trAksNo, ')
          ..write('hiveCountRange: $hiveCountRange, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembershipsTable extends Memberships
    with TableInfo<$MembershipsTable, MembershipRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
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
  );
  @override
  late final GeneratedColumnWithTypeConverter<MembershipRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MembershipRole>($MembershipsTable.$converterrole);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    userId,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memberships';
  @override
  VerificationContext validateIntegrity(
    Insertable<MembershipRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MembershipRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MembershipRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: $MembershipsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
    );
  }

  @override
  $MembershipsTable createAlias(String alias) {
    return $MembershipsTable(attachedDatabase, alias);
  }

  static TypeConverter<MembershipRole, String> $converterrole =
      const ServerEnumConverter(MembershipRole.values);
}

class MembershipRow extends DataClass implements Insertable<MembershipRow> {
  /// İstemcide üretilen UUIDv7.
  final String id;
  final DateTime createdAt;

  /// Son yazan kazanır; her yerel yazmada şimdiye çekilir.
  final DateTime updatedAt;

  /// Sunucu doldurur; yerelde oluşan kayıtta senkrona kadar boş.
  final String? createdBy;

  /// Yumuşak silme: dolu satır listelerde görünmez.
  final DateTime? deletedAt;

  /// Çekme imleci; sunucuya henüz ulaşmamış kayıtta boş.
  final int? serverSeq;
  final String orgId;
  final String userId;
  final MembershipRole role;
  const MembershipRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.deletedAt,
    this.serverSeq,
    required this.orgId,
    required this.userId,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || serverSeq != null) {
      map['server_seq'] = Variable<int>(serverSeq);
    }
    map['org_id'] = Variable<String>(orgId);
    map['user_id'] = Variable<String>(userId);
    {
      map['role'] = Variable<String>(
        $MembershipsTable.$converterrole.toSql(role),
      );
    }
    return map;
  }

  MembershipsCompanion toCompanion(bool nullToAbsent) {
    return MembershipsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      serverSeq: serverSeq == null && nullToAbsent
          ? const Value.absent()
          : Value(serverSeq),
      orgId: Value(orgId),
      userId: Value(userId),
      role: Value(role),
    );
  }

  factory MembershipRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MembershipRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      serverSeq: serializer.fromJson<int?>(json['serverSeq']),
      orgId: serializer.fromJson<String>(json['orgId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<MembershipRole>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'serverSeq': serializer.toJson<int?>(serverSeq),
      'orgId': serializer.toJson<String>(orgId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<MembershipRole>(role),
    };
  }

  MembershipRow copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> createdBy = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<int?> serverSeq = const Value.absent(),
    String? orgId,
    String? userId,
    MembershipRole? role,
  }) => MembershipRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    serverSeq: serverSeq.present ? serverSeq.value : this.serverSeq,
    orgId: orgId ?? this.orgId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
  );
  MembershipRow copyWithCompanion(MembershipsCompanion data) {
    return MembershipRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MembershipRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('userId: $userId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    userId,
    role,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MembershipRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.deletedAt == this.deletedAt &&
          other.serverSeq == this.serverSeq &&
          other.orgId == this.orgId &&
          other.userId == this.userId &&
          other.role == this.role);
}

class MembershipsCompanion extends UpdateCompanion<MembershipRow> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> userId;
  final Value<MembershipRole> role;
  final Value<int> rowid;
  const MembershipsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembershipsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String userId,
    required MembershipRole role,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<MembershipRow> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembershipsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? userId,
    Value<MembershipRole>? role,
    Value<int>? rowid,
  }) {
    return MembershipsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $MembershipsTable.$converterrole.toSql(role.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembershipsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ApiariesTable extends Apiaries with TableInfo<$ApiariesTable, Apiary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMMeta = const VerificationMeta(
    'altitudeM',
  );
  @override
  late final GeneratedColumn<int> altitudeM = GeneratedColumn<int>(
    'altitude_m',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _landownerNameMeta = const VerificationMeta(
    'landownerName',
  );
  @override
  late final GeneratedColumn<String> landownerName = GeneratedColumn<String>(
    'landowner_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _landownerPhoneMeta = const VerificationMeta(
    'landownerPhone',
  );
  @override
  late final GeneratedColumn<String> landownerPhone = GeneratedColumn<String>(
    'landowner_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LandTenure?, String> landTenure =
      GeneratedColumn<String>(
        'land_tenure',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LandTenure?>($ApiariesTable.$converterlandTenuren);
  static const VerificationMeta _waterSourceMeta = const VerificationMeta(
    'waterSource',
  );
  @override
  late final GeneratedColumn<String> waterSource = GeneratedColumn<String>(
    'water_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleDistanceMMeta = const VerificationMeta(
    'vehicleDistanceM',
  );
  @override
  late final GeneratedColumn<int> vehicleDistanceM = GeneratedColumn<int>(
    'vehicle_distance_m',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roadNotesMeta = const VerificationMeta(
    'roadNotes',
  );
  @override
  late final GeneratedColumn<String> roadNotes = GeneratedColumn<String>(
    'road_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    name,
    latitude,
    longitude,
    altitudeM,
    landownerName,
    landownerPhone,
    landTenure,
    waterSource,
    vehicleDistanceM,
    roadNotes,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apiaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Apiary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('altitude_m')) {
      context.handle(
        _altitudeMMeta,
        altitudeM.isAcceptableOrUnknown(data['altitude_m']!, _altitudeMMeta),
      );
    }
    if (data.containsKey('landowner_name')) {
      context.handle(
        _landownerNameMeta,
        landownerName.isAcceptableOrUnknown(
          data['landowner_name']!,
          _landownerNameMeta,
        ),
      );
    }
    if (data.containsKey('landowner_phone')) {
      context.handle(
        _landownerPhoneMeta,
        landownerPhone.isAcceptableOrUnknown(
          data['landowner_phone']!,
          _landownerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('water_source')) {
      context.handle(
        _waterSourceMeta,
        waterSource.isAcceptableOrUnknown(
          data['water_source']!,
          _waterSourceMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_distance_m')) {
      context.handle(
        _vehicleDistanceMMeta,
        vehicleDistanceM.isAcceptableOrUnknown(
          data['vehicle_distance_m']!,
          _vehicleDistanceMMeta,
        ),
      );
    }
    if (data.containsKey('road_notes')) {
      context.handle(
        _roadNotesMeta,
        roadNotes.isAcceptableOrUnknown(data['road_notes']!, _roadNotesMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Apiary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Apiary(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      altitudeM: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}altitude_m'],
      ),
      landownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landowner_name'],
      ),
      landownerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landowner_phone'],
      ),
      landTenure: $ApiariesTable.$converterlandTenuren.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}land_tenure'],
        ),
      ),
      waterSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_source'],
      ),
      vehicleDistanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_distance_m'],
      ),
      roadNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}road_notes'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $ApiariesTable createAlias(String alias) {
    return $ApiariesTable(attachedDatabase, alias);
  }

  static TypeConverter<LandTenure, String> $converterlandTenure =
      const ServerEnumConverter(LandTenure.values);
  static TypeConverter<LandTenure?, String?> $converterlandTenuren =
      NullAwareTypeConverter.wrap($converterlandTenure);
}

class ApiariesCompanion extends UpdateCompanion<Apiary> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> name;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int?> altitudeM;
  final Value<String?> landownerName;
  final Value<String?> landownerPhone;
  final Value<LandTenure?> landTenure;
  final Value<String?> waterSource;
  final Value<int?> vehicleDistanceM;
  final Value<String?> roadNotes;
  final Value<String?> notes;
  final Value<int> rowid;
  const ApiariesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeM = const Value.absent(),
    this.landownerName = const Value.absent(),
    this.landownerPhone = const Value.absent(),
    this.landTenure = const Value.absent(),
    this.waterSource = const Value.absent(),
    this.vehicleDistanceM = const Value.absent(),
    this.roadNotes = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApiariesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String name,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeM = const Value.absent(),
    this.landownerName = const Value.absent(),
    this.landownerPhone = const Value.absent(),
    this.landTenure = const Value.absent(),
    this.waterSource = const Value.absent(),
    this.vehicleDistanceM = const Value.absent(),
    this.roadNotes = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       name = Value(name);
  static Insertable<Apiary> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? altitudeM,
    Expression<String>? landownerName,
    Expression<String>? landownerPhone,
    Expression<String>? landTenure,
    Expression<String>? waterSource,
    Expression<int>? vehicleDistanceM,
    Expression<String>? roadNotes,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitudeM != null) 'altitude_m': altitudeM,
      if (landownerName != null) 'landowner_name': landownerName,
      if (landownerPhone != null) 'landowner_phone': landownerPhone,
      if (landTenure != null) 'land_tenure': landTenure,
      if (waterSource != null) 'water_source': waterSource,
      if (vehicleDistanceM != null) 'vehicle_distance_m': vehicleDistanceM,
      if (roadNotes != null) 'road_notes': roadNotes,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApiariesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? name,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int?>? altitudeM,
    Value<String?>? landownerName,
    Value<String?>? landownerPhone,
    Value<LandTenure?>? landTenure,
    Value<String?>? waterSource,
    Value<int?>? vehicleDistanceM,
    Value<String?>? roadNotes,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ApiariesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeM: altitudeM ?? this.altitudeM,
      landownerName: landownerName ?? this.landownerName,
      landownerPhone: landownerPhone ?? this.landownerPhone,
      landTenure: landTenure ?? this.landTenure,
      waterSource: waterSource ?? this.waterSource,
      vehicleDistanceM: vehicleDistanceM ?? this.vehicleDistanceM,
      roadNotes: roadNotes ?? this.roadNotes,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitudeM.present) {
      map['altitude_m'] = Variable<int>(altitudeM.value);
    }
    if (landownerName.present) {
      map['landowner_name'] = Variable<String>(landownerName.value);
    }
    if (landownerPhone.present) {
      map['landowner_phone'] = Variable<String>(landownerPhone.value);
    }
    if (landTenure.present) {
      map['land_tenure'] = Variable<String>(
        $ApiariesTable.$converterlandTenuren.toSql(landTenure.value),
      );
    }
    if (waterSource.present) {
      map['water_source'] = Variable<String>(waterSource.value);
    }
    if (vehicleDistanceM.present) {
      map['vehicle_distance_m'] = Variable<int>(vehicleDistanceM.value);
    }
    if (roadNotes.present) {
      map['road_notes'] = Variable<String>(roadNotes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiariesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeM: $altitudeM, ')
          ..write('landownerName: $landownerName, ')
          ..write('landownerPhone: $landownerPhone, ')
          ..write('landTenure: $landTenure, ')
          ..write('waterSource: $waterSource, ')
          ..write('vehicleDistanceM: $vehicleDistanceM, ')
          ..write('roadNotes: $roadNotes, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ApiaryInsertable implements Insertable<Apiary> {
  Apiary _object;
  _$ApiaryInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ApiariesCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      name: Value(_object.name),
      latitude: Value(_object.latitude),
      longitude: Value(_object.longitude),
      altitudeM: Value(_object.altitudeM),
      landownerName: Value(_object.landownerName),
      landownerPhone: Value(_object.landownerPhone),
      landTenure: Value(_object.landTenure),
      waterSource: Value(_object.waterSource),
      vehicleDistanceM: Value(_object.vehicleDistanceM),
      roadNotes: Value(_object.roadNotes),
      notes: Value(_object.notes),
    ).toColumns(false);
  }
}

extension ApiaryToInsertable on Apiary {
  _$ApiaryInsertable toInsertable() {
    return _$ApiaryInsertable(this);
  }
}

class $QueensTable extends Queens with TableInfo<$QueensTable, Queen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueenMarkColor?, String>
  markColor = GeneratedColumn<String>(
    'mark_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<QueenMarkColor?>($QueensTable.$convertermarkColorn);
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breedLineMeta = const VerificationMeta(
    'breedLine',
  );
  @override
  late final GeneratedColumn<String> breedLine = GeneratedColumn<String>(
    'breed_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueenSource?, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<QueenSource?>($QueensTable.$convertersourcen);
  @override
  late final GeneratedColumnWithTypeConverter<QueenMatingStatus?, String>
  matingStatus = GeneratedColumn<String>(
    'mating_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<QueenMatingStatus?>($QueensTable.$convertermatingStatusn);
  static const VerificationMeta _wingClippedMeta = const VerificationMeta(
    'wingClipped',
  );
  @override
  late final GeneratedColumn<bool> wingClipped = GeneratedColumn<bool>(
    'wing_clipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("wing_clipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _motherQueenIdMeta = const VerificationMeta(
    'motherQueenId',
  );
  @override
  late final GeneratedColumn<String> motherQueenId = GeneratedColumn<String>(
    'mother_queen_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    year,
    markColor,
    breed,
    breedLine,
    source,
    matingStatus,
    wingClipped,
    motherQueenId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queens';
  @override
  VerificationContext validateIntegrity(
    Insertable<Queen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    }
    if (data.containsKey('breed_line')) {
      context.handle(
        _breedLineMeta,
        breedLine.isAcceptableOrUnknown(data['breed_line']!, _breedLineMeta),
      );
    }
    if (data.containsKey('wing_clipped')) {
      context.handle(
        _wingClippedMeta,
        wingClipped.isAcceptableOrUnknown(
          data['wing_clipped']!,
          _wingClippedMeta,
        ),
      );
    }
    if (data.containsKey('mother_queen_id')) {
      context.handle(
        _motherQueenIdMeta,
        motherQueenId.isAcceptableOrUnknown(
          data['mother_queen_id']!,
          _motherQueenIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Queen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Queen(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      markColor: $QueensTable.$convertermarkColorn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mark_color'],
        ),
      ),
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      ),
      breedLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed_line'],
      ),
      source: $QueensTable.$convertersourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        ),
      ),
      matingStatus: $QueensTable.$convertermatingStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mating_status'],
        ),
      ),
      wingClipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wing_clipped'],
      )!,
      motherQueenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mother_queen_id'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $QueensTable createAlias(String alias) {
    return $QueensTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QueenMarkColor, String, String>
  $convertermarkColor = const EnumNameConverter<QueenMarkColor>(
    QueenMarkColor.values,
  );
  static JsonTypeConverter2<QueenMarkColor?, String?, String?>
  $convertermarkColorn = JsonTypeConverter2.asNullable($convertermarkColor);
  static TypeConverter<QueenSource, String> $convertersource =
      const ServerEnumConverter(QueenSource.values);
  static TypeConverter<QueenSource?, String?> $convertersourcen =
      NullAwareTypeConverter.wrap($convertersource);
  static TypeConverter<QueenMatingStatus, String> $convertermatingStatus =
      const ServerEnumConverter(QueenMatingStatus.values);
  static TypeConverter<QueenMatingStatus?, String?> $convertermatingStatusn =
      NullAwareTypeConverter.wrap($convertermatingStatus);
}

class QueensCompanion extends UpdateCompanion<Queen> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<int?> year;
  final Value<QueenMarkColor?> markColor;
  final Value<String?> breed;
  final Value<String?> breedLine;
  final Value<QueenSource?> source;
  final Value<QueenMatingStatus?> matingStatus;
  final Value<bool> wingClipped;
  final Value<String?> motherQueenId;
  final Value<int> rowid;
  const QueensCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.year = const Value.absent(),
    this.markColor = const Value.absent(),
    this.breed = const Value.absent(),
    this.breedLine = const Value.absent(),
    this.source = const Value.absent(),
    this.matingStatus = const Value.absent(),
    this.wingClipped = const Value.absent(),
    this.motherQueenId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QueensCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    this.year = const Value.absent(),
    this.markColor = const Value.absent(),
    this.breed = const Value.absent(),
    this.breedLine = const Value.absent(),
    this.source = const Value.absent(),
    this.matingStatus = const Value.absent(),
    this.wingClipped = const Value.absent(),
    this.motherQueenId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId);
  static Insertable<Queen> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<int>? year,
    Expression<String>? markColor,
    Expression<String>? breed,
    Expression<String>? breedLine,
    Expression<String>? source,
    Expression<String>? matingStatus,
    Expression<bool>? wingClipped,
    Expression<String>? motherQueenId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (year != null) 'year': year,
      if (markColor != null) 'mark_color': markColor,
      if (breed != null) 'breed': breed,
      if (breedLine != null) 'breed_line': breedLine,
      if (source != null) 'source': source,
      if (matingStatus != null) 'mating_status': matingStatus,
      if (wingClipped != null) 'wing_clipped': wingClipped,
      if (motherQueenId != null) 'mother_queen_id': motherQueenId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QueensCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<int?>? year,
    Value<QueenMarkColor?>? markColor,
    Value<String?>? breed,
    Value<String?>? breedLine,
    Value<QueenSource?>? source,
    Value<QueenMatingStatus?>? matingStatus,
    Value<bool>? wingClipped,
    Value<String?>? motherQueenId,
    Value<int>? rowid,
  }) {
    return QueensCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      year: year ?? this.year,
      markColor: markColor ?? this.markColor,
      breed: breed ?? this.breed,
      breedLine: breedLine ?? this.breedLine,
      source: source ?? this.source,
      matingStatus: matingStatus ?? this.matingStatus,
      wingClipped: wingClipped ?? this.wingClipped,
      motherQueenId: motherQueenId ?? this.motherQueenId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (markColor.present) {
      map['mark_color'] = Variable<String>(
        $QueensTable.$convertermarkColorn.toSql(markColor.value),
      );
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (breedLine.present) {
      map['breed_line'] = Variable<String>(breedLine.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $QueensTable.$convertersourcen.toSql(source.value),
      );
    }
    if (matingStatus.present) {
      map['mating_status'] = Variable<String>(
        $QueensTable.$convertermatingStatusn.toSql(matingStatus.value),
      );
    }
    if (wingClipped.present) {
      map['wing_clipped'] = Variable<bool>(wingClipped.value);
    }
    if (motherQueenId.present) {
      map['mother_queen_id'] = Variable<String>(motherQueenId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueensCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('year: $year, ')
          ..write('markColor: $markColor, ')
          ..write('breed: $breed, ')
          ..write('breedLine: $breedLine, ')
          ..write('source: $source, ')
          ..write('matingStatus: $matingStatus, ')
          ..write('wingClipped: $wingClipped, ')
          ..write('motherQueenId: $motherQueenId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$QueenInsertable implements Insertable<Queen> {
  Queen _object;
  _$QueenInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return QueensCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      year: Value(_object.year),
      markColor: Value(_object.markColor),
      breed: Value(_object.breed),
      breedLine: Value(_object.breedLine),
      source: Value(_object.source),
      matingStatus: Value(_object.matingStatus),
      wingClipped: Value(_object.wingClipped),
      motherQueenId: Value(_object.motherQueenId),
    ).toColumns(false);
  }
}

extension QueenToInsertable on Queen {
  _$QueenInsertable toInsertable() {
    return _$QueenInsertable(this);
  }
}

class $HivesTable extends Hives with TableInfo<$HivesTable, Hive> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagCodeMeta = const VerificationMeta(
    'tagCode',
  );
  @override
  late final GeneratedColumn<String> tagCode = GeneratedColumn<String>(
    'tag_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HiveType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HiveType>($HivesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<HiveStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HiveStatus>($HivesTable.$converterstatus);
  static const VerificationMeta _apiaryIdMeta = const VerificationMeta(
    'apiaryId',
  );
  @override
  late final GeneratedColumn<String> apiaryId = GeneratedColumn<String>(
    'apiary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queenIdMeta = const VerificationMeta(
    'queenId',
  );
  @override
  late final GeneratedColumn<String> queenId = GeneratedColumn<String>(
    'queen_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _boxCountMeta = const VerificationMeta(
    'boxCount',
  );
  @override
  late final GeneratedColumn<int> boxCount = GeneratedColumn<int>(
    'box_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _frameCountMeta = const VerificationMeta(
    'frameCount',
  );
  @override
  late final GeneratedColumn<int> frameCount = GeneratedColumn<int>(
    'frame_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HiveSource?, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HiveSource?>($HivesTable.$convertersourcen);
  static const VerificationMeta _markingMeta = const VerificationMeta(
    'marking',
  );
  @override
  late final GeneratedColumn<String> marking = GeneratedColumn<String>(
    'marking',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    number,
    tagCode,
    type,
    status,
    apiaryId,
    queenId,
    boxCount,
    frameCount,
    source,
    marking,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hives';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hive> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('tag_code')) {
      context.handle(
        _tagCodeMeta,
        tagCode.isAcceptableOrUnknown(data['tag_code']!, _tagCodeMeta),
      );
    }
    if (data.containsKey('apiary_id')) {
      context.handle(
        _apiaryIdMeta,
        apiaryId.isAcceptableOrUnknown(data['apiary_id']!, _apiaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_apiaryIdMeta);
    }
    if (data.containsKey('queen_id')) {
      context.handle(
        _queenIdMeta,
        queenId.isAcceptableOrUnknown(data['queen_id']!, _queenIdMeta),
      );
    }
    if (data.containsKey('box_count')) {
      context.handle(
        _boxCountMeta,
        boxCount.isAcceptableOrUnknown(data['box_count']!, _boxCountMeta),
      );
    }
    if (data.containsKey('frame_count')) {
      context.handle(
        _frameCountMeta,
        frameCount.isAcceptableOrUnknown(data['frame_count']!, _frameCountMeta),
      );
    }
    if (data.containsKey('marking')) {
      context.handle(
        _markingMeta,
        marking.isAcceptableOrUnknown(data['marking']!, _markingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hive map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hive(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      type: $HivesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      apiaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apiary_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      status: $HivesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      tagCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_code'],
      ),
      queenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}queen_id'],
      ),
      boxCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}box_count'],
      )!,
      frameCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frame_count'],
      ),
      source: $HivesTable.$convertersourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        ),
      ),
      marking: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marking'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $HivesTable createAlias(String alias) {
    return $HivesTable(attachedDatabase, alias);
  }

  static TypeConverter<HiveType, String> $convertertype =
      const ServerEnumConverter(HiveType.values);
  static TypeConverter<HiveStatus, String> $converterstatus =
      const ServerEnumConverter(HiveStatus.values);
  static TypeConverter<HiveSource, String> $convertersource =
      const ServerEnumConverter(HiveSource.values);
  static TypeConverter<HiveSource?, String?> $convertersourcen =
      NullAwareTypeConverter.wrap($convertersource);
}

class HivesCompanion extends UpdateCompanion<Hive> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> number;
  final Value<String?> tagCode;
  final Value<HiveType> type;
  final Value<HiveStatus> status;
  final Value<String> apiaryId;
  final Value<String?> queenId;
  final Value<int> boxCount;
  final Value<int?> frameCount;
  final Value<HiveSource?> source;
  final Value<String?> marking;
  final Value<int> rowid;
  const HivesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.number = const Value.absent(),
    this.tagCode = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.apiaryId = const Value.absent(),
    this.queenId = const Value.absent(),
    this.boxCount = const Value.absent(),
    this.frameCount = const Value.absent(),
    this.source = const Value.absent(),
    this.marking = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HivesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String number,
    this.tagCode = const Value.absent(),
    required HiveType type,
    required HiveStatus status,
    required String apiaryId,
    this.queenId = const Value.absent(),
    this.boxCount = const Value.absent(),
    this.frameCount = const Value.absent(),
    this.source = const Value.absent(),
    this.marking = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       number = Value(number),
       type = Value(type),
       status = Value(status),
       apiaryId = Value(apiaryId);
  static Insertable<Hive> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? number,
    Expression<String>? tagCode,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? apiaryId,
    Expression<String>? queenId,
    Expression<int>? boxCount,
    Expression<int>? frameCount,
    Expression<String>? source,
    Expression<String>? marking,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (number != null) 'number': number,
      if (tagCode != null) 'tag_code': tagCode,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (apiaryId != null) 'apiary_id': apiaryId,
      if (queenId != null) 'queen_id': queenId,
      if (boxCount != null) 'box_count': boxCount,
      if (frameCount != null) 'frame_count': frameCount,
      if (source != null) 'source': source,
      if (marking != null) 'marking': marking,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HivesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? number,
    Value<String?>? tagCode,
    Value<HiveType>? type,
    Value<HiveStatus>? status,
    Value<String>? apiaryId,
    Value<String?>? queenId,
    Value<int>? boxCount,
    Value<int?>? frameCount,
    Value<HiveSource?>? source,
    Value<String?>? marking,
    Value<int>? rowid,
  }) {
    return HivesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      number: number ?? this.number,
      tagCode: tagCode ?? this.tagCode,
      type: type ?? this.type,
      status: status ?? this.status,
      apiaryId: apiaryId ?? this.apiaryId,
      queenId: queenId ?? this.queenId,
      boxCount: boxCount ?? this.boxCount,
      frameCount: frameCount ?? this.frameCount,
      source: source ?? this.source,
      marking: marking ?? this.marking,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (tagCode.present) {
      map['tag_code'] = Variable<String>(tagCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $HivesTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $HivesTable.$converterstatus.toSql(status.value),
      );
    }
    if (apiaryId.present) {
      map['apiary_id'] = Variable<String>(apiaryId.value);
    }
    if (queenId.present) {
      map['queen_id'] = Variable<String>(queenId.value);
    }
    if (boxCount.present) {
      map['box_count'] = Variable<int>(boxCount.value);
    }
    if (frameCount.present) {
      map['frame_count'] = Variable<int>(frameCount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $HivesTable.$convertersourcen.toSql(source.value),
      );
    }
    if (marking.present) {
      map['marking'] = Variable<String>(marking.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HivesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('number: $number, ')
          ..write('tagCode: $tagCode, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('apiaryId: $apiaryId, ')
          ..write('queenId: $queenId, ')
          ..write('boxCount: $boxCount, ')
          ..write('frameCount: $frameCount, ')
          ..write('source: $source, ')
          ..write('marking: $marking, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$HiveInsertable implements Insertable<Hive> {
  Hive _object;
  _$HiveInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return HivesCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      number: Value(_object.number),
      tagCode: Value(_object.tagCode),
      type: Value(_object.type),
      status: Value(_object.status),
      apiaryId: Value(_object.apiaryId),
      queenId: Value(_object.queenId),
      boxCount: Value(_object.boxCount),
      frameCount: Value(_object.frameCount),
      source: Value(_object.source),
      marking: Value(_object.marking),
    ).toColumns(false);
  }
}

extension HiveToInsertable on Hive {
  _$HiveInsertable toInsertable() {
    return _$HiveInsertable(this);
  }
}

class $HiveLocationHistoryTable extends HiveLocationHistory
    with TableInfo<$HiveLocationHistoryTable, HiveLocationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiveLocationHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiveIdMeta = const VerificationMeta('hiveId');
  @override
  late final GeneratedColumn<String> hiveId = GeneratedColumn<String>(
    'hive_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apiaryIdMeta = const VerificationMeta(
    'apiaryId',
  );
  @override
  late final GeneratedColumn<String> apiaryId = GeneratedColumn<String>(
    'apiary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movedAtMeta = const VerificationMeta(
    'movedAt',
  );
  @override
  late final GeneratedColumn<DateTime> movedAt = GeneratedColumn<DateTime>(
    'moved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    hiveId,
    apiaryId,
    movedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hive_location_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiveLocationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('hive_id')) {
      context.handle(
        _hiveIdMeta,
        hiveId.isAcceptableOrUnknown(data['hive_id']!, _hiveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hiveIdMeta);
    }
    if (data.containsKey('apiary_id')) {
      context.handle(
        _apiaryIdMeta,
        apiaryId.isAcceptableOrUnknown(data['apiary_id']!, _apiaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_apiaryIdMeta);
    }
    if (data.containsKey('moved_at')) {
      context.handle(
        _movedAtMeta,
        movedAt.isAcceptableOrUnknown(data['moved_at']!, _movedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_movedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiveLocationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiveLocationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      hiveId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hive_id'],
      )!,
      apiaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apiary_id'],
      )!,
      movedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}moved_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $HiveLocationHistoryTable createAlias(String alias) {
    return $HiveLocationHistoryTable(attachedDatabase, alias);
  }
}

class HiveLocationHistoryCompanion extends UpdateCompanion<HiveLocationEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> hiveId;
  final Value<String> apiaryId;
  final Value<DateTime> movedAt;
  final Value<int> rowid;
  const HiveLocationHistoryCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.hiveId = const Value.absent(),
    this.apiaryId = const Value.absent(),
    this.movedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HiveLocationHistoryCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required DateTime movedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       hiveId = Value(hiveId),
       apiaryId = Value(apiaryId),
       movedAt = Value(movedAt);
  static Insertable<HiveLocationEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? hiveId,
    Expression<String>? apiaryId,
    Expression<DateTime>? movedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (hiveId != null) 'hive_id': hiveId,
      if (apiaryId != null) 'apiary_id': apiaryId,
      if (movedAt != null) 'moved_at': movedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HiveLocationHistoryCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? hiveId,
    Value<String>? apiaryId,
    Value<DateTime>? movedAt,
    Value<int>? rowid,
  }) {
    return HiveLocationHistoryCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      hiveId: hiveId ?? this.hiveId,
      apiaryId: apiaryId ?? this.apiaryId,
      movedAt: movedAt ?? this.movedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (hiveId.present) {
      map['hive_id'] = Variable<String>(hiveId.value);
    }
    if (apiaryId.present) {
      map['apiary_id'] = Variable<String>(apiaryId.value);
    }
    if (movedAt.present) {
      map['moved_at'] = Variable<DateTime>(movedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiveLocationHistoryCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('hiveId: $hiveId, ')
          ..write('apiaryId: $apiaryId, ')
          ..write('movedAt: $movedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$HiveLocationEntryInsertable implements Insertable<HiveLocationEntry> {
  HiveLocationEntry _object;
  _$HiveLocationEntryInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return HiveLocationHistoryCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      hiveId: Value(_object.hiveId),
      apiaryId: Value(_object.apiaryId),
      movedAt: Value(_object.movedAt),
    ).toColumns(false);
  }
}

extension HiveLocationEntryToInsertable on HiveLocationEntry {
  _$HiveLocationEntryInsertable toInsertable() {
    return _$HiveLocationEntryInsertable(this);
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiveIdMeta = const VerificationMeta('hiveId');
  @override
  late final GeneratedColumn<String> hiveId = GeneratedColumn<String>(
    'hive_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apiaryIdMeta = const VerificationMeta(
    'apiaryId',
  );
  @override
  late final GeneratedColumn<String> apiaryId = GeneratedColumn<String>(
    'apiary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectedAtMeta = const VerificationMeta(
    'inspectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> inspectedAt = GeneratedColumn<DateTime>(
    'inspected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueenState?, String> queenState =
      GeneratedColumn<String>(
        'queen_state',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<QueenState?>($InspectionsTable.$converterqueenStaten);
  static const VerificationMeta _beeFramesMeta = const VerificationMeta(
    'beeFrames',
  );
  @override
  late final GeneratedColumn<int> beeFrames = GeneratedColumn<int>(
    'bee_frames',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _broodFramesMeta = const VerificationMeta(
    'broodFrames',
  );
  @override
  late final GeneratedColumn<int> broodFrames = GeneratedColumn<int>(
    'brood_frames',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _honeyFramesMeta = const VerificationMeta(
    'honeyFrames',
  );
  @override
  late final GeneratedColumn<int> honeyFrames = GeneratedColumn<int>(
    'honey_frames',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Temperament?, String>
  temperament = GeneratedColumn<String>(
    'temperament',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Temperament?>($InspectionsTable.$convertertemperamentn);
  static const VerificationMeta _swarmSignsMeta = const VerificationMeta(
    'swarmSigns',
  );
  @override
  late final GeneratedColumn<bool> swarmSigns = GeneratedColumn<bool>(
    'swarm_signs',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("swarm_signs" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QueenCells?, String> queenCells =
      GeneratedColumn<String>(
        'queen_cells',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<QueenCells?>($InspectionsTable.$converterqueenCellsn);
  static const VerificationMeta _diseaseSuspectedMeta = const VerificationMeta(
    'diseaseSuspected',
  );
  @override
  late final GeneratedColumn<bool> diseaseSuspected = GeneratedColumn<bool>(
    'disease_suspected',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("disease_suspected" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, Object?>>($InspectionsTable.$converterdata);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    hiveId,
    apiaryId,
    inspectedAt,
    queenState,
    beeFrames,
    broodFrames,
    honeyFrames,
    temperament,
    swarmSigns,
    queenCells,
    diseaseSuspected,
    data,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('hive_id')) {
      context.handle(
        _hiveIdMeta,
        hiveId.isAcceptableOrUnknown(data['hive_id']!, _hiveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hiveIdMeta);
    }
    if (data.containsKey('apiary_id')) {
      context.handle(
        _apiaryIdMeta,
        apiaryId.isAcceptableOrUnknown(data['apiary_id']!, _apiaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_apiaryIdMeta);
    }
    if (data.containsKey('inspected_at')) {
      context.handle(
        _inspectedAtMeta,
        inspectedAt.isAcceptableOrUnknown(
          data['inspected_at']!,
          _inspectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectedAtMeta);
    }
    if (data.containsKey('bee_frames')) {
      context.handle(
        _beeFramesMeta,
        beeFrames.isAcceptableOrUnknown(data['bee_frames']!, _beeFramesMeta),
      );
    }
    if (data.containsKey('brood_frames')) {
      context.handle(
        _broodFramesMeta,
        broodFrames.isAcceptableOrUnknown(
          data['brood_frames']!,
          _broodFramesMeta,
        ),
      );
    }
    if (data.containsKey('honey_frames')) {
      context.handle(
        _honeyFramesMeta,
        honeyFrames.isAcceptableOrUnknown(
          data['honey_frames']!,
          _honeyFramesMeta,
        ),
      );
    }
    if (data.containsKey('swarm_signs')) {
      context.handle(
        _swarmSignsMeta,
        swarmSigns.isAcceptableOrUnknown(data['swarm_signs']!, _swarmSignsMeta),
      );
    }
    if (data.containsKey('disease_suspected')) {
      context.handle(
        _diseaseSuspectedMeta,
        diseaseSuspected.isAcceptableOrUnknown(
          data['disease_suspected']!,
          _diseaseSuspectedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      hiveId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hive_id'],
      )!,
      apiaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apiary_id'],
      )!,
      inspectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inspected_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      queenState: $InspectionsTable.$converterqueenStaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}queen_state'],
        ),
      ),
      beeFrames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bee_frames'],
      ),
      broodFrames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brood_frames'],
      ),
      honeyFrames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}honey_frames'],
      ),
      temperament: $InspectionsTable.$convertertemperamentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}temperament'],
        ),
      ),
      swarmSigns: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}swarm_signs'],
      ),
      queenCells: $InspectionsTable.$converterqueenCellsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}queen_cells'],
        ),
      ),
      diseaseSuspected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}disease_suspected'],
      ),
      data: $InspectionsTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }

  static TypeConverter<QueenState, String> $converterqueenState =
      const ServerEnumConverter(QueenState.values);
  static TypeConverter<QueenState?, String?> $converterqueenStaten =
      NullAwareTypeConverter.wrap($converterqueenState);
  static TypeConverter<Temperament, String> $convertertemperament =
      const ServerEnumConverter(Temperament.values);
  static TypeConverter<Temperament?, String?> $convertertemperamentn =
      NullAwareTypeConverter.wrap($convertertemperament);
  static TypeConverter<QueenCells, String> $converterqueenCells =
      const ServerEnumConverter(QueenCells.values);
  static TypeConverter<QueenCells?, String?> $converterqueenCellsn =
      NullAwareTypeConverter.wrap($converterqueenCells);
  static TypeConverter<Map<String, Object?>, String> $converterdata =
      const JsonMapConverter();
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> hiveId;
  final Value<String> apiaryId;
  final Value<DateTime> inspectedAt;
  final Value<QueenState?> queenState;
  final Value<int?> beeFrames;
  final Value<int?> broodFrames;
  final Value<int?> honeyFrames;
  final Value<Temperament?> temperament;
  final Value<bool?> swarmSigns;
  final Value<QueenCells?> queenCells;
  final Value<bool?> diseaseSuspected;
  final Value<Map<String, Object?>> data;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.hiveId = const Value.absent(),
    this.apiaryId = const Value.absent(),
    this.inspectedAt = const Value.absent(),
    this.queenState = const Value.absent(),
    this.beeFrames = const Value.absent(),
    this.broodFrames = const Value.absent(),
    this.honeyFrames = const Value.absent(),
    this.temperament = const Value.absent(),
    this.swarmSigns = const Value.absent(),
    this.queenCells = const Value.absent(),
    this.diseaseSuspected = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required DateTime inspectedAt,
    this.queenState = const Value.absent(),
    this.beeFrames = const Value.absent(),
    this.broodFrames = const Value.absent(),
    this.honeyFrames = const Value.absent(),
    this.temperament = const Value.absent(),
    this.swarmSigns = const Value.absent(),
    this.queenCells = const Value.absent(),
    this.diseaseSuspected = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       hiveId = Value(hiveId),
       apiaryId = Value(apiaryId),
       inspectedAt = Value(inspectedAt);
  static Insertable<Inspection> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? hiveId,
    Expression<String>? apiaryId,
    Expression<DateTime>? inspectedAt,
    Expression<String>? queenState,
    Expression<int>? beeFrames,
    Expression<int>? broodFrames,
    Expression<int>? honeyFrames,
    Expression<String>? temperament,
    Expression<bool>? swarmSigns,
    Expression<String>? queenCells,
    Expression<bool>? diseaseSuspected,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (hiveId != null) 'hive_id': hiveId,
      if (apiaryId != null) 'apiary_id': apiaryId,
      if (inspectedAt != null) 'inspected_at': inspectedAt,
      if (queenState != null) 'queen_state': queenState,
      if (beeFrames != null) 'bee_frames': beeFrames,
      if (broodFrames != null) 'brood_frames': broodFrames,
      if (honeyFrames != null) 'honey_frames': honeyFrames,
      if (temperament != null) 'temperament': temperament,
      if (swarmSigns != null) 'swarm_signs': swarmSigns,
      if (queenCells != null) 'queen_cells': queenCells,
      if (diseaseSuspected != null) 'disease_suspected': diseaseSuspected,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? hiveId,
    Value<String>? apiaryId,
    Value<DateTime>? inspectedAt,
    Value<QueenState?>? queenState,
    Value<int?>? beeFrames,
    Value<int?>? broodFrames,
    Value<int?>? honeyFrames,
    Value<Temperament?>? temperament,
    Value<bool?>? swarmSigns,
    Value<QueenCells?>? queenCells,
    Value<bool?>? diseaseSuspected,
    Value<Map<String, Object?>>? data,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      hiveId: hiveId ?? this.hiveId,
      apiaryId: apiaryId ?? this.apiaryId,
      inspectedAt: inspectedAt ?? this.inspectedAt,
      queenState: queenState ?? this.queenState,
      beeFrames: beeFrames ?? this.beeFrames,
      broodFrames: broodFrames ?? this.broodFrames,
      honeyFrames: honeyFrames ?? this.honeyFrames,
      temperament: temperament ?? this.temperament,
      swarmSigns: swarmSigns ?? this.swarmSigns,
      queenCells: queenCells ?? this.queenCells,
      diseaseSuspected: diseaseSuspected ?? this.diseaseSuspected,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (hiveId.present) {
      map['hive_id'] = Variable<String>(hiveId.value);
    }
    if (apiaryId.present) {
      map['apiary_id'] = Variable<String>(apiaryId.value);
    }
    if (inspectedAt.present) {
      map['inspected_at'] = Variable<DateTime>(inspectedAt.value);
    }
    if (queenState.present) {
      map['queen_state'] = Variable<String>(
        $InspectionsTable.$converterqueenStaten.toSql(queenState.value),
      );
    }
    if (beeFrames.present) {
      map['bee_frames'] = Variable<int>(beeFrames.value);
    }
    if (broodFrames.present) {
      map['brood_frames'] = Variable<int>(broodFrames.value);
    }
    if (honeyFrames.present) {
      map['honey_frames'] = Variable<int>(honeyFrames.value);
    }
    if (temperament.present) {
      map['temperament'] = Variable<String>(
        $InspectionsTable.$convertertemperamentn.toSql(temperament.value),
      );
    }
    if (swarmSigns.present) {
      map['swarm_signs'] = Variable<bool>(swarmSigns.value);
    }
    if (queenCells.present) {
      map['queen_cells'] = Variable<String>(
        $InspectionsTable.$converterqueenCellsn.toSql(queenCells.value),
      );
    }
    if (diseaseSuspected.present) {
      map['disease_suspected'] = Variable<bool>(diseaseSuspected.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(
        $InspectionsTable.$converterdata.toSql(data.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('hiveId: $hiveId, ')
          ..write('apiaryId: $apiaryId, ')
          ..write('inspectedAt: $inspectedAt, ')
          ..write('queenState: $queenState, ')
          ..write('beeFrames: $beeFrames, ')
          ..write('broodFrames: $broodFrames, ')
          ..write('honeyFrames: $honeyFrames, ')
          ..write('temperament: $temperament, ')
          ..write('swarmSigns: $swarmSigns, ')
          ..write('queenCells: $queenCells, ')
          ..write('diseaseSuspected: $diseaseSuspected, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$InspectionInsertable implements Insertable<Inspection> {
  Inspection _object;
  _$InspectionInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      hiveId: Value(_object.hiveId),
      apiaryId: Value(_object.apiaryId),
      inspectedAt: Value(_object.inspectedAt),
      queenState: Value(_object.queenState),
      beeFrames: Value(_object.beeFrames),
      broodFrames: Value(_object.broodFrames),
      honeyFrames: Value(_object.honeyFrames),
      temperament: Value(_object.temperament),
      swarmSigns: Value(_object.swarmSigns),
      queenCells: Value(_object.queenCells),
      diseaseSuspected: Value(_object.diseaseSuspected),
      data: Value(_object.data),
    ).toColumns(false);
  }
}

extension InspectionToInsertable on Inspection {
  _$InspectionInsertable toInsertable() {
    return _$InspectionInsertable(this);
  }
}

class $InspectionDraftsTable extends InspectionDrafts
    with TableInfo<$InspectionDraftsTable, InspectionDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hiveIdMeta = const VerificationMeta('hiveId');
  @override
  late final GeneratedColumn<String> hiveId = GeneratedColumn<String>(
    'hive_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InspectionDraft, String> draft =
      GeneratedColumn<String>(
        'draft',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionDraft>($InspectionDraftsTable.$converterdraft);
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
  List<GeneratedColumn> get $columns => [hiveId, orgId, draft, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hive_id')) {
      context.handle(
        _hiveIdMeta,
        hiveId.isAcceptableOrUnknown(data['hive_id']!, _hiveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hiveIdMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {hiveId};
  @override
  InspectionDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionDraftRow(
      hiveId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hive_id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      draft: $InspectionDraftsTable.$converterdraft.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}draft'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InspectionDraftsTable createAlias(String alias) {
    return $InspectionDraftsTable(attachedDatabase, alias);
  }

  static TypeConverter<InspectionDraft, String> $converterdraft =
      const InspectionDraftConverter();
}

class InspectionDraftRow extends DataClass
    implements Insertable<InspectionDraftRow> {
  final String hiveId;
  final String orgId;
  final InspectionDraft draft;
  final DateTime updatedAt;
  const InspectionDraftRow({
    required this.hiveId,
    required this.orgId,
    required this.draft,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hive_id'] = Variable<String>(hiveId);
    map['org_id'] = Variable<String>(orgId);
    {
      map['draft'] = Variable<String>(
        $InspectionDraftsTable.$converterdraft.toSql(draft),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InspectionDraftsCompanion toCompanion(bool nullToAbsent) {
    return InspectionDraftsCompanion(
      hiveId: Value(hiveId),
      orgId: Value(orgId),
      draft: Value(draft),
      updatedAt: Value(updatedAt),
    );
  }

  factory InspectionDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionDraftRow(
      hiveId: serializer.fromJson<String>(json['hiveId']),
      orgId: serializer.fromJson<String>(json['orgId']),
      draft: serializer.fromJson<InspectionDraft>(json['draft']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hiveId': serializer.toJson<String>(hiveId),
      'orgId': serializer.toJson<String>(orgId),
      'draft': serializer.toJson<InspectionDraft>(draft),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InspectionDraftRow copyWith({
    String? hiveId,
    String? orgId,
    InspectionDraft? draft,
    DateTime? updatedAt,
  }) => InspectionDraftRow(
    hiveId: hiveId ?? this.hiveId,
    orgId: orgId ?? this.orgId,
    draft: draft ?? this.draft,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InspectionDraftRow copyWithCompanion(InspectionDraftsCompanion data) {
    return InspectionDraftRow(
      hiveId: data.hiveId.present ? data.hiveId.value : this.hiveId,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      draft: data.draft.present ? data.draft.value : this.draft,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionDraftRow(')
          ..write('hiveId: $hiveId, ')
          ..write('orgId: $orgId, ')
          ..write('draft: $draft, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(hiveId, orgId, draft, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionDraftRow &&
          other.hiveId == this.hiveId &&
          other.orgId == this.orgId &&
          other.draft == this.draft &&
          other.updatedAt == this.updatedAt);
}

class InspectionDraftsCompanion extends UpdateCompanion<InspectionDraftRow> {
  final Value<String> hiveId;
  final Value<String> orgId;
  final Value<InspectionDraft> draft;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InspectionDraftsCompanion({
    this.hiveId = const Value.absent(),
    this.orgId = const Value.absent(),
    this.draft = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionDraftsCompanion.insert({
    required String hiveId,
    required String orgId,
    required InspectionDraft draft,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : hiveId = Value(hiveId),
       orgId = Value(orgId),
       draft = Value(draft),
       updatedAt = Value(updatedAt);
  static Insertable<InspectionDraftRow> custom({
    Expression<String>? hiveId,
    Expression<String>? orgId,
    Expression<String>? draft,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hiveId != null) 'hive_id': hiveId,
      if (orgId != null) 'org_id': orgId,
      if (draft != null) 'draft': draft,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionDraftsCompanion copyWith({
    Value<String>? hiveId,
    Value<String>? orgId,
    Value<InspectionDraft>? draft,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InspectionDraftsCompanion(
      hiveId: hiveId ?? this.hiveId,
      orgId: orgId ?? this.orgId,
      draft: draft ?? this.draft,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hiveId.present) {
      map['hive_id'] = Variable<String>(hiveId.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (draft.present) {
      map['draft'] = Variable<String>(
        $InspectionDraftsTable.$converterdraft.toSql(draft.value),
      );
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
    return (StringBuffer('InspectionDraftsCompanion(')
          ..write('hiveId: $hiveId, ')
          ..write('orgId: $orgId, ')
          ..write('draft: $draft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionRemindersTable extends InspectionReminders
    with TableInfo<$InspectionRemindersTable, InspectionReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiveIdMeta = const VerificationMeta('hiveId');
  @override
  late final GeneratedColumn<String> hiveId = GeneratedColumn<String>(
    'hive_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
    'days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    inspectionId,
    orgId,
    hiveId,
    days,
    remindAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('hive_id')) {
      context.handle(
        _hiveIdMeta,
        hiveId.isAcceptableOrUnknown(data['hive_id']!, _hiveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hiveIdMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
        _daysMeta,
        days.isAcceptableOrUnknown(data['days']!, _daysMeta),
      );
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {inspectionId};
  @override
  InspectionReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionReminder(
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      hiveId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hive_id'],
      )!,
      days: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days'],
      )!,
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InspectionRemindersTable createAlias(String alias) {
    return $InspectionRemindersTable(attachedDatabase, alias);
  }
}

class InspectionReminder extends DataClass
    implements Insertable<InspectionReminder> {
  final String inspectionId;
  final String orgId;
  final String hiveId;
  final int days;
  final DateTime remindAt;
  final DateTime createdAt;
  const InspectionReminder({
    required this.inspectionId,
    required this.orgId,
    required this.hiveId,
    required this.days,
    required this.remindAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['inspection_id'] = Variable<String>(inspectionId);
    map['org_id'] = Variable<String>(orgId);
    map['hive_id'] = Variable<String>(hiveId);
    map['days'] = Variable<int>(days);
    map['remind_at'] = Variable<DateTime>(remindAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InspectionRemindersCompanion toCompanion(bool nullToAbsent) {
    return InspectionRemindersCompanion(
      inspectionId: Value(inspectionId),
      orgId: Value(orgId),
      hiveId: Value(hiveId),
      days: Value(days),
      remindAt: Value(remindAt),
      createdAt: Value(createdAt),
    );
  }

  factory InspectionReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionReminder(
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      orgId: serializer.fromJson<String>(json['orgId']),
      hiveId: serializer.fromJson<String>(json['hiveId']),
      days: serializer.fromJson<int>(json['days']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'inspectionId': serializer.toJson<String>(inspectionId),
      'orgId': serializer.toJson<String>(orgId),
      'hiveId': serializer.toJson<String>(hiveId),
      'days': serializer.toJson<int>(days),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InspectionReminder copyWith({
    String? inspectionId,
    String? orgId,
    String? hiveId,
    int? days,
    DateTime? remindAt,
    DateTime? createdAt,
  }) => InspectionReminder(
    inspectionId: inspectionId ?? this.inspectionId,
    orgId: orgId ?? this.orgId,
    hiveId: hiveId ?? this.hiveId,
    days: days ?? this.days,
    remindAt: remindAt ?? this.remindAt,
    createdAt: createdAt ?? this.createdAt,
  );
  InspectionReminder copyWithCompanion(InspectionRemindersCompanion data) {
    return InspectionReminder(
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      hiveId: data.hiveId.present ? data.hiveId.value : this.hiveId,
      days: data.days.present ? data.days.value : this.days,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionReminder(')
          ..write('inspectionId: $inspectionId, ')
          ..write('orgId: $orgId, ')
          ..write('hiveId: $hiveId, ')
          ..write('days: $days, ')
          ..write('remindAt: $remindAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(inspectionId, orgId, hiveId, days, remindAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionReminder &&
          other.inspectionId == this.inspectionId &&
          other.orgId == this.orgId &&
          other.hiveId == this.hiveId &&
          other.days == this.days &&
          other.remindAt == this.remindAt &&
          other.createdAt == this.createdAt);
}

class InspectionRemindersCompanion extends UpdateCompanion<InspectionReminder> {
  final Value<String> inspectionId;
  final Value<String> orgId;
  final Value<String> hiveId;
  final Value<int> days;
  final Value<DateTime> remindAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InspectionRemindersCompanion({
    this.inspectionId = const Value.absent(),
    this.orgId = const Value.absent(),
    this.hiveId = const Value.absent(),
    this.days = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionRemindersCompanion.insert({
    required String inspectionId,
    required String orgId,
    required String hiveId,
    required int days,
    required DateTime remindAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : inspectionId = Value(inspectionId),
       orgId = Value(orgId),
       hiveId = Value(hiveId),
       days = Value(days),
       remindAt = Value(remindAt),
       createdAt = Value(createdAt);
  static Insertable<InspectionReminder> custom({
    Expression<String>? inspectionId,
    Expression<String>? orgId,
    Expression<String>? hiveId,
    Expression<int>? days,
    Expression<DateTime>? remindAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (orgId != null) 'org_id': orgId,
      if (hiveId != null) 'hive_id': hiveId,
      if (days != null) 'days': days,
      if (remindAt != null) 'remind_at': remindAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionRemindersCompanion copyWith({
    Value<String>? inspectionId,
    Value<String>? orgId,
    Value<String>? hiveId,
    Value<int>? days,
    Value<DateTime>? remindAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return InspectionRemindersCompanion(
      inspectionId: inspectionId ?? this.inspectionId,
      orgId: orgId ?? this.orgId,
      hiveId: hiveId ?? this.hiveId,
      days: days ?? this.days,
      remindAt: remindAt ?? this.remindAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (hiveId.present) {
      map['hive_id'] = Variable<String>(hiveId.value);
    }
    if (days.present) {
      map['days'] = Variable<int>(days.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
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
    return (StringBuffer('InspectionRemindersCompanion(')
          ..write('inspectionId: $inspectionId, ')
          ..write('orgId: $orgId, ')
          ..write('hiveId: $hiveId, ')
          ..write('days: $days, ')
          ..write('remindAt: $remindAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaTable extends Media with TableInfo<$MediaTable, MediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiveIdMeta = const VerificationMeta('hiveId');
  @override
  late final GeneratedColumn<String> hiveId = GeneratedColumn<String>(
    'hive_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaKind>($MediaTable.$converterkind);
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    createdBy,
    deletedAt,
    serverSeq,
    orgId,
    hiveId,
    inspectionId,
    kind,
    storagePath,
    capturedAt,
    byteSize,
    durationMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('hive_id')) {
      context.handle(
        _hiveIdMeta,
        hiveId.isAcceptableOrUnknown(data['hive_id']!, _hiveIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hiveIdMeta);
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      hiveId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hive_id'],
      )!,
      kind: $MediaTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $MediaTable createAlias(String alias) {
    return $MediaTable(attachedDatabase, alias);
  }

  static TypeConverter<MediaKind, String> $converterkind =
      const ServerEnumConverter(MediaKind.values);
}

class MediaCompanion extends UpdateCompanion<MediaItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> createdBy;
  final Value<DateTime?> deletedAt;
  final Value<int?> serverSeq;
  final Value<String> orgId;
  final Value<String> hiveId;
  final Value<String?> inspectionId;
  final Value<MediaKind> kind;
  final Value<String> storagePath;
  final Value<DateTime> capturedAt;
  final Value<int> byteSize;
  final Value<int?> durationMs;
  final Value<int> rowid;
  const MediaCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.orgId = const Value.absent(),
    this.hiveId = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.kind = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.createdBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    required String orgId,
    required String hiveId,
    this.inspectionId = const Value.absent(),
    required MediaKind kind,
    required String storagePath,
    required DateTime capturedAt,
    required int byteSize,
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       orgId = Value(orgId),
       hiveId = Value(hiveId),
       kind = Value(kind),
       storagePath = Value(storagePath),
       capturedAt = Value(capturedAt),
       byteSize = Value(byteSize);
  static Insertable<MediaItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? deletedAt,
    Expression<int>? serverSeq,
    Expression<String>? orgId,
    Expression<String>? hiveId,
    Expression<String>? inspectionId,
    Expression<String>? kind,
    Expression<String>? storagePath,
    Expression<DateTime>? capturedAt,
    Expression<int>? byteSize,
    Expression<int>? durationMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (orgId != null) 'org_id': orgId,
      if (hiveId != null) 'hive_id': hiveId,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (kind != null) 'kind': kind,
      if (storagePath != null) 'storage_path': storagePath,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (byteSize != null) 'byte_size': byteSize,
      if (durationMs != null) 'duration_ms': durationMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? createdBy,
    Value<DateTime?>? deletedAt,
    Value<int?>? serverSeq,
    Value<String>? orgId,
    Value<String>? hiveId,
    Value<String?>? inspectionId,
    Value<MediaKind>? kind,
    Value<String>? storagePath,
    Value<DateTime>? capturedAt,
    Value<int>? byteSize,
    Value<int?>? durationMs,
    Value<int>? rowid,
  }) {
    return MediaCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt ?? this.deletedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      orgId: orgId ?? this.orgId,
      hiveId: hiveId ?? this.hiveId,
      inspectionId: inspectionId ?? this.inspectionId,
      kind: kind ?? this.kind,
      storagePath: storagePath ?? this.storagePath,
      capturedAt: capturedAt ?? this.capturedAt,
      byteSize: byteSize ?? this.byteSize,
      durationMs: durationMs ?? this.durationMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (hiveId.present) {
      map['hive_id'] = Variable<String>(hiveId.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $MediaTable.$converterkind.toSql(kind.value),
      );
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('orgId: $orgId, ')
          ..write('hiveId: $hiveId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('kind: $kind, ')
          ..write('storagePath: $storagePath, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('byteSize: $byteSize, ')
          ..write('durationMs: $durationMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$MediaItemInsertable implements Insertable<MediaItem> {
  MediaItem _object;
  _$MediaItemInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MediaCompanion(
      id: Value(_object.id),
      createdAt: Value(_object.createdAt),
      updatedAt: Value(_object.updatedAt),
      createdBy: Value(_object.createdBy),
      deletedAt: Value(_object.deletedAt),
      serverSeq: Value(_object.serverSeq),
      orgId: Value(_object.orgId),
      hiveId: Value(_object.hiveId),
      inspectionId: Value(_object.inspectionId),
      kind: Value(_object.kind),
      storagePath: Value(_object.storagePath),
      capturedAt: Value(_object.capturedAt),
      byteSize: Value(_object.byteSize),
      durationMs: Value(_object.durationMs),
    ).toColumns(false);
  }
}

extension MediaItemToInsertable on MediaItem {
  _$MediaItemInsertable toInsertable() {
    return _$MediaItemInsertable(this);
  }
}

class $MediaUploadsTable extends MediaUploads
    with TableInfo<$MediaUploadsTable, MediaUpload> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaUploadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaUploadStatus, String>
  uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MediaUploadStatus>($MediaUploadsTable.$converteruploadStatus);
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
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
    mediaId,
    orgId,
    fileName,
    uploadStatus,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_uploads';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaUpload> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
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
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaUpload map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaUpload(
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      uploadStatus: $MediaUploadsTable.$converteruploadStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}upload_status'],
        )!,
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MediaUploadsTable createAlias(String alias) {
    return $MediaUploadsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaUploadStatus, String, String>
  $converteruploadStatus = const EnumNameConverter<MediaUploadStatus>(
    MediaUploadStatus.values,
  );
}

class MediaUpload extends DataClass implements Insertable<MediaUpload> {
  final String mediaId;
  final String orgId;

  /// Uygulamanın medya klasöründeki dosya adı.
  final String fileName;
  final MediaUploadStatus uploadStatus;
  final int attempts;

  /// Boşsa hemen denenir.
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  const MediaUpload({
    required this.mediaId,
    required this.orgId,
    required this.fileName,
    required this.uploadStatus,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<String>(mediaId);
    map['org_id'] = Variable<String>(orgId);
    map['file_name'] = Variable<String>(fileName);
    {
      map['upload_status'] = Variable<String>(
        $MediaUploadsTable.$converteruploadStatus.toSql(uploadStatus),
      );
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MediaUploadsCompanion toCompanion(bool nullToAbsent) {
    return MediaUploadsCompanion(
      mediaId: Value(mediaId),
      orgId: Value(orgId),
      fileName: Value(fileName),
      uploadStatus: Value(uploadStatus),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory MediaUpload.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaUpload(
      mediaId: serializer.fromJson<String>(json['mediaId']),
      orgId: serializer.fromJson<String>(json['orgId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      uploadStatus: $MediaUploadsTable.$converteruploadStatus.fromJson(
        serializer.fromJson<String>(json['uploadStatus']),
      ),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<String>(mediaId),
      'orgId': serializer.toJson<String>(orgId),
      'fileName': serializer.toJson<String>(fileName),
      'uploadStatus': serializer.toJson<String>(
        $MediaUploadsTable.$converteruploadStatus.toJson(uploadStatus),
      ),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MediaUpload copyWith({
    String? mediaId,
    String? orgId,
    String? fileName,
    MediaUploadStatus? uploadStatus,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => MediaUpload(
    mediaId: mediaId ?? this.mediaId,
    orgId: orgId ?? this.orgId,
    fileName: fileName ?? this.fileName,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  MediaUpload copyWithCompanion(MediaUploadsCompanion data) {
    return MediaUpload(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaUpload(')
          ..write('mediaId: $mediaId, ')
          ..write('orgId: $orgId, ')
          ..write('fileName: $fileName, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaId,
    orgId,
    fileName,
    uploadStatus,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaUpload &&
          other.mediaId == this.mediaId &&
          other.orgId == this.orgId &&
          other.fileName == this.fileName &&
          other.uploadStatus == this.uploadStatus &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class MediaUploadsCompanion extends UpdateCompanion<MediaUpload> {
  final Value<String> mediaId;
  final Value<String> orgId;
  final Value<String> fileName;
  final Value<MediaUploadStatus> uploadStatus;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MediaUploadsCompanion({
    this.mediaId = const Value.absent(),
    this.orgId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaUploadsCompanion.insert({
    required String mediaId,
    required String orgId,
    required String fileName,
    required MediaUploadStatus uploadStatus,
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : mediaId = Value(mediaId),
       orgId = Value(orgId),
       fileName = Value(fileName),
       uploadStatus = Value(uploadStatus),
       createdAt = Value(createdAt);
  static Insertable<MediaUpload> custom({
    Expression<String>? mediaId,
    Expression<String>? orgId,
    Expression<String>? fileName,
    Expression<String>? uploadStatus,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (orgId != null) 'org_id': orgId,
      if (fileName != null) 'file_name': fileName,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaUploadsCompanion copyWith({
    Value<String>? mediaId,
    Value<String>? orgId,
    Value<String>? fileName,
    Value<MediaUploadStatus>? uploadStatus,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MediaUploadsCompanion(
      mediaId: mediaId ?? this.mediaId,
      orgId: orgId ?? this.orgId,
      fileName: fileName ?? this.fileName,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(
        $MediaUploadsTable.$converteruploadStatus.toSql(uploadStatus.value),
      );
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
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
    return (StringBuffer('MediaUploadsCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('orgId: $orgId, ')
          ..write('fileName: $fileName, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final String key;
  final String value;
  const LocalSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  LocalSetting copyWith({String? key, String? value}) =>
      LocalSetting(key: key ?? this.key, value: value ?? this.value);
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const LocalSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<LocalSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return LocalSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordTableMeta = const VerificationMeta(
    'recordTable',
  );
  @override
  late final GeneratedColumn<String> recordTable = GeneratedColumn<String>(
    'record_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OutboxOperation, String>
  operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<OutboxOperation>($OutboxTable.$converteroperation);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($OutboxTable.$converterpayload);
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
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordTable,
    recordId,
    operation,
    payload,
    createdAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_table')) {
      context.handle(
        _recordTableMeta,
        recordTable.isAcceptableOrUnknown(
          data['record_table']!,
          _recordTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_table'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      operation: $OutboxTable.$converteroperation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}operation'],
        )!,
      ),
      payload: $OutboxTable.$converterpayload.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payload'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OutboxOperation, String, String>
  $converteroperation = const EnumNameConverter<OutboxOperation>(
    OutboxOperation.values,
  );
  static TypeConverter<Map<String, Object?>, String> $converterpayload =
      const JsonMapConverter();
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;

  /// Yazılan tablonun adı (sunucudakiyle aynı).
  final String recordTable;
  final String recordId;
  final OutboxOperation operation;

  /// Satırın yazma anındaki tam hâli, sunucunun kolon adlarıyla.
  final Map<String, Object?> payload;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  const OutboxEntry({
    required this.id,
    required this.recordTable,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_table'] = Variable<String>(recordTable);
    map['record_id'] = Variable<String>(recordId);
    {
      map['operation'] = Variable<String>(
        $OutboxTable.$converteroperation.toSql(operation),
      );
    }
    {
      map['payload'] = Variable<String>(
        $OutboxTable.$converterpayload.toSql(payload),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      recordTable: Value(recordTable),
      recordId: Value(recordId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      recordTable: serializer.fromJson<String>(json['recordTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: $OutboxTable.$converteroperation.fromJson(
        serializer.fromJson<String>(json['operation']),
      ),
      payload: serializer.fromJson<Map<String, Object?>>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordTable': serializer.toJson<String>(recordTable),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(
        $OutboxTable.$converteroperation.toJson(operation),
      ),
      'payload': serializer.toJson<Map<String, Object?>>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? recordTable,
    String? recordId,
    OutboxOperation? operation,
    Map<String, Object?>? payload,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    recordTable: recordTable ?? this.recordTable,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxEntry copyWithCompanion(OutboxCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      recordTable: data.recordTable.present
          ? data.recordTable.value
          : this.recordTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('recordTable: $recordTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordTable,
    recordId,
    operation,
    payload,
    createdAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.recordTable == this.recordTable &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class OutboxCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> recordTable;
  final Value<String> recordId;
  final Value<OutboxOperation> operation;
  final Value<Map<String, Object?>> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.recordTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.id = const Value.absent(),
    required String recordTable,
    required String recordId,
    required OutboxOperation operation,
    required Map<String, Object?> payload,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : recordTable = Value(recordTable),
       recordId = Value(recordId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? recordTable,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordTable != null) 'record_table': recordTable,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? recordTable,
    Value<String>? recordId,
    Value<OutboxOperation>? operation,
    Value<Map<String, Object?>>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      recordTable: recordTable ?? this.recordTable,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordTable.present) {
      map['record_table'] = Variable<String>(recordTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(
        $OutboxTable.$converteroperation.toSql(operation.value),
      );
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
        $OutboxTable.$converterpayload.toSql(payload.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('recordTable: $recordTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordTableMeta = const VerificationMeta(
    'recordTable',
  );
  @override
  late final GeneratedColumn<String> recordTable = GeneratedColumn<String>(
    'record_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledSeqMeta = const VerificationMeta(
    'lastPulledSeq',
  );
  @override
  late final GeneratedColumn<int> lastPulledSeq = GeneratedColumn<int>(
    'last_pulled_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [recordTable, lastPulledSeq];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_table')) {
      context.handle(
        _recordTableMeta,
        recordTable.isAcceptableOrUnknown(
          data['record_table']!,
          _recordTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordTableMeta);
    }
    if (data.containsKey('last_pulled_seq')) {
      context.handle(
        _lastPulledSeqMeta,
        lastPulledSeq.isAcceptableOrUnknown(
          data['last_pulled_seq']!,
          _lastPulledSeqMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordTable};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      recordTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_table'],
      )!,
      lastPulledSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_pulled_seq'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String recordTable;
  final int lastPulledSeq;
  const SyncCursor({required this.recordTable, required this.lastPulledSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_table'] = Variable<String>(recordTable);
    map['last_pulled_seq'] = Variable<int>(lastPulledSeq);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      recordTable: Value(recordTable),
      lastPulledSeq: Value(lastPulledSeq),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      recordTable: serializer.fromJson<String>(json['recordTable']),
      lastPulledSeq: serializer.fromJson<int>(json['lastPulledSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordTable': serializer.toJson<String>(recordTable),
      'lastPulledSeq': serializer.toJson<int>(lastPulledSeq),
    };
  }

  SyncCursor copyWith({String? recordTable, int? lastPulledSeq}) => SyncCursor(
    recordTable: recordTable ?? this.recordTable,
    lastPulledSeq: lastPulledSeq ?? this.lastPulledSeq,
  );
  SyncCursor copyWithCompanion(SyncStateCompanion data) {
    return SyncCursor(
      recordTable: data.recordTable.present
          ? data.recordTable.value
          : this.recordTable,
      lastPulledSeq: data.lastPulledSeq.present
          ? data.lastPulledSeq.value
          : this.lastPulledSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('recordTable: $recordTable, ')
          ..write('lastPulledSeq: $lastPulledSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordTable, lastPulledSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.recordTable == this.recordTable &&
          other.lastPulledSeq == this.lastPulledSeq);
}

class SyncStateCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> recordTable;
  final Value<int> lastPulledSeq;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.recordTable = const Value.absent(),
    this.lastPulledSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String recordTable,
    this.lastPulledSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recordTable = Value(recordTable);
  static Insertable<SyncCursor> custom({
    Expression<String>? recordTable,
    Expression<int>? lastPulledSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordTable != null) 'record_table': recordTable,
      if (lastPulledSeq != null) 'last_pulled_seq': lastPulledSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? recordTable,
    Value<int>? lastPulledSeq,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      recordTable: recordTable ?? this.recordTable,
      lastPulledSeq: lastPulledSeq ?? this.lastPulledSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordTable.present) {
      map['record_table'] = Variable<String>(recordTable.value);
    }
    if (lastPulledSeq.present) {
      map['last_pulled_seq'] = Variable<int>(lastPulledSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('recordTable: $recordTable, ')
          ..write('lastPulledSeq: $lastPulledSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganizationsTable organizations = $OrganizationsTable(this);
  late final $MembershipsTable memberships = $MembershipsTable(this);
  late final $ApiariesTable apiaries = $ApiariesTable(this);
  late final $QueensTable queens = $QueensTable(this);
  late final $HivesTable hives = $HivesTable(this);
  late final $HiveLocationHistoryTable hiveLocationHistory =
      $HiveLocationHistoryTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $InspectionDraftsTable inspectionDrafts = $InspectionDraftsTable(
    this,
  );
  late final $InspectionRemindersTable inspectionReminders =
      $InspectionRemindersTable(this);
  late final $MediaTable media = $MediaTable(this);
  late final $MediaUploadsTable mediaUploads = $MediaUploadsTable(this);
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final Index membershipsOrgIdIdx = Index(
    'memberships_org_id_idx',
    'CREATE INDEX memberships_org_id_idx ON memberships (org_id)',
  );
  late final Index apiariesOrgIdIdx = Index(
    'apiaries_org_id_idx',
    'CREATE INDEX apiaries_org_id_idx ON apiaries (org_id)',
  );
  late final Index queensOrgIdIdx = Index(
    'queens_org_id_idx',
    'CREATE INDEX queens_org_id_idx ON queens (org_id)',
  );
  late final Index hivesOrgIdIdx = Index(
    'hives_org_id_idx',
    'CREATE INDEX hives_org_id_idx ON hives (org_id)',
  );
  late final Index hivesApiaryIdIdx = Index(
    'hives_apiary_id_idx',
    'CREATE INDEX hives_apiary_id_idx ON hives (apiary_id)',
  );
  late final Index hiveLocationHistoryOrgIdIdx = Index(
    'hive_location_history_org_id_idx',
    'CREATE INDEX hive_location_history_org_id_idx ON hive_location_history (org_id)',
  );
  late final Index hiveLocationHistoryHiveIdIdx = Index(
    'hive_location_history_hive_id_idx',
    'CREATE INDEX hive_location_history_hive_id_idx ON hive_location_history (hive_id)',
  );
  late final Index inspectionsOrgIdIdx = Index(
    'inspections_org_id_idx',
    'CREATE INDEX inspections_org_id_idx ON inspections (org_id)',
  );
  late final Index inspectionsHiveIdIdx = Index(
    'inspections_hive_id_idx',
    'CREATE INDEX inspections_hive_id_idx ON inspections (hive_id)',
  );
  late final Index mediaOrgIdIdx = Index(
    'media_org_id_idx',
    'CREATE INDEX media_org_id_idx ON media (org_id)',
  );
  late final Index mediaHiveIdIdx = Index(
    'media_hive_id_idx',
    'CREATE INDEX media_hive_id_idx ON media (hive_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organizations,
    memberships,
    apiaries,
    queens,
    hives,
    hiveLocationHistory,
    inspections,
    inspectionDrafts,
    inspectionReminders,
    media,
    mediaUploads,
    localSettings,
    outbox,
    syncState,
    membershipsOrgIdIdx,
    apiariesOrgIdIdx,
    queensOrgIdIdx,
    hivesOrgIdIdx,
    hivesApiaryIdIdx,
    hiveLocationHistoryOrgIdIdx,
    hiveLocationHistoryHiveIdIdx,
    inspectionsOrgIdIdx,
    inspectionsHiveIdIdx,
    mediaOrgIdIdx,
    mediaHiveIdIdx,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$OrganizationsTableCreateCompanionBuilder =
    OrganizationsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      required String name,
      required String countryCode,
      required String currency,
      Value<String?> trRegistrationNo,
      Value<String?> trAksNo,
      Value<HiveCountRange?> hiveCountRange,
      Value<int> rowid,
    });
typedef $$OrganizationsTableUpdateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      Value<String> name,
      Value<String> countryCode,
      Value<String> currency,
      Value<String?> trRegistrationNo,
      Value<String?> trAksNo,
      Value<HiveCountRange?> hiveCountRange,
      Value<int> rowid,
    });

class $$OrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trRegistrationNo => $composableBuilder(
    column: $table.trRegistrationNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trAksNo => $composableBuilder(
    column: $table.trAksNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HiveCountRange?, HiveCountRange, String>
  get hiveCountRange => $composableBuilder(
    column: $table.hiveCountRange,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$OrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trRegistrationNo => $composableBuilder(
    column: $table.trRegistrationNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trAksNo => $composableBuilder(
    column: $table.trAksNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiveCountRange => $composableBuilder(
    column: $table.hiveCountRange,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get trRegistrationNo => $composableBuilder(
    column: $table.trRegistrationNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trAksNo =>
      $composableBuilder(column: $table.trAksNo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HiveCountRange?, String>
  get hiveCountRange => $composableBuilder(
    column: $table.hiveCountRange,
    builder: (column) => column,
  );
}

class $$OrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationsTable,
          OrganizationRow,
          $$OrganizationsTableFilterComposer,
          $$OrganizationsTableOrderingComposer,
          $$OrganizationsTableAnnotationComposer,
          $$OrganizationsTableCreateCompanionBuilder,
          $$OrganizationsTableUpdateCompanionBuilder,
          (
            OrganizationRow,
            BaseReferences<_$AppDatabase, $OrganizationsTable, OrganizationRow>,
          ),
          OrganizationRow,
          PrefetchHooks Function()
        > {
  $$OrganizationsTableTableManager(_$AppDatabase db, $OrganizationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> trRegistrationNo = const Value.absent(),
                Value<String?> trAksNo = const Value.absent(),
                Value<HiveCountRange?> hiveCountRange = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                name: name,
                countryCode: countryCode,
                currency: currency,
                trRegistrationNo: trRegistrationNo,
                trAksNo: trAksNo,
                hiveCountRange: hiveCountRange,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String name,
                required String countryCode,
                required String currency,
                Value<String?> trRegistrationNo = const Value.absent(),
                Value<String?> trAksNo = const Value.absent(),
                Value<HiveCountRange?> hiveCountRange = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                name: name,
                countryCode: countryCode,
                currency: currency,
                trRegistrationNo: trRegistrationNo,
                trAksNo: trAksNo,
                hiveCountRange: hiveCountRange,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganizationsTable, OrganizationRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OrganizationsTable,
                    OrganizationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationsTable,
      OrganizationRow,
      $$OrganizationsTableFilterComposer,
      $$OrganizationsTableOrderingComposer,
      $$OrganizationsTableAnnotationComposer,
      $$OrganizationsTableCreateCompanionBuilder,
      $$OrganizationsTableUpdateCompanionBuilder,
      (
        OrganizationRow,
        BaseReferences<_$AppDatabase, $OrganizationsTable, OrganizationRow>,
      ),
      OrganizationRow,
      PrefetchHooks Function()
    >;
typedef $$MembershipsTableCreateCompanionBuilder =
    MembershipsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      required String orgId,
      required String userId,
      required MembershipRole role,
      Value<int> rowid,
    });
typedef $$MembershipsTableUpdateCompanionBuilder =
    MembershipsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      Value<String> orgId,
      Value<String> userId,
      Value<MembershipRole> role,
      Value<int> rowid,
    });

class $$MembershipsTableFilterComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MembershipRole, MembershipRole, String>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$MembershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MembershipRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$MembershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembershipsTable,
          MembershipRow,
          $$MembershipsTableFilterComposer,
          $$MembershipsTableOrderingComposer,
          $$MembershipsTableAnnotationComposer,
          $$MembershipsTableCreateCompanionBuilder,
          $$MembershipsTableUpdateCompanionBuilder,
          (
            MembershipRow,
            BaseReferences<_$AppDatabase, $MembershipsTable, MembershipRow>,
          ),
          MembershipRow,
          PrefetchHooks Function()
        > {
  $$MembershipsTableTableManager(_$AppDatabase db, $MembershipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembershipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<MembershipRole> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembershipsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                userId: userId,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String userId,
                required MembershipRole role,
                Value<int> rowid = const Value.absent(),
              }) => MembershipsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                userId: userId,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MembershipsTable, MembershipRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MembershipsTable,
                    MembershipRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembershipsTable,
      MembershipRow,
      $$MembershipsTableFilterComposer,
      $$MembershipsTableOrderingComposer,
      $$MembershipsTableAnnotationComposer,
      $$MembershipsTableCreateCompanionBuilder,
      $$MembershipsTableUpdateCompanionBuilder,
      (
        MembershipRow,
        BaseReferences<_$AppDatabase, $MembershipsTable, MembershipRow>,
      ),
      MembershipRow,
      PrefetchHooks Function()
    >;
typedef $$ApiariesTableCreateCompanionBuilder = ApiariesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  required String orgId,
  required String name,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int?> altitudeM,
  Value<String?> landownerName,
  Value<String?> landownerPhone,
  Value<LandTenure?> landTenure,
  Value<String?> waterSource,
  Value<int?> vehicleDistanceM,
  Value<String?> roadNotes,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ApiariesTableUpdateCompanionBuilder = ApiariesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  Value<String> orgId,
  Value<String> name,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int?> altitudeM,
  Value<String?> landownerName,
  Value<String?> landownerPhone,
  Value<LandTenure?> landTenure,
  Value<String?> waterSource,
  Value<int?> vehicleDistanceM,
  Value<String?> roadNotes,
  Value<String?> notes,
  Value<int> rowid,
});

class $$ApiariesTableFilterComposer
    extends Composer<_$AppDatabase, $ApiariesTable> {
  $$ApiariesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landownerName => $composableBuilder(
    column: $table.landownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landownerPhone => $composableBuilder(
    column: $table.landownerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LandTenure?, LandTenure, String>
  get landTenure => $composableBuilder(
    column: $table.landTenure,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get waterSource => $composableBuilder(
    column: $table.waterSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vehicleDistanceM => $composableBuilder(
    column: $table.vehicleDistanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roadNotes => $composableBuilder(
    column: $table.roadNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiariesTable> {
  $$ApiariesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landownerName => $composableBuilder(
    column: $table.landownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landownerPhone => $composableBuilder(
    column: $table.landownerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landTenure => $composableBuilder(
    column: $table.landTenure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterSource => $composableBuilder(
    column: $table.waterSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vehicleDistanceM => $composableBuilder(
    column: $table.vehicleDistanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roadNotes => $composableBuilder(
    column: $table.roadNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiariesTable> {
  $$ApiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get altitudeM =>
      $composableBuilder(column: $table.altitudeM, builder: (column) => column);

  GeneratedColumn<String> get landownerName => $composableBuilder(
    column: $table.landownerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get landownerPhone => $composableBuilder(
    column: $table.landownerPhone,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LandTenure?, String> get landTenure =>
      $composableBuilder(
        column: $table.landTenure,
        builder: (column) => column,
      );

  GeneratedColumn<String> get waterSource => $composableBuilder(
    column: $table.waterSource,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vehicleDistanceM => $composableBuilder(
    column: $table.vehicleDistanceM,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roadNotes =>
      $composableBuilder(column: $table.roadNotes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ApiariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApiariesTable,
          Apiary,
          $$ApiariesTableFilterComposer,
          $$ApiariesTableOrderingComposer,
          $$ApiariesTableAnnotationComposer,
          $$ApiariesTableCreateCompanionBuilder,
          $$ApiariesTableUpdateCompanionBuilder,
          (Apiary, BaseReferences<_$AppDatabase, $ApiariesTable, Apiary>),
          Apiary,
          PrefetchHooks Function()
        > {
  $$ApiariesTableTableManager(_$AppDatabase db, $ApiariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int?> altitudeM = const Value.absent(),
                Value<String?> landownerName = const Value.absent(),
                Value<String?> landownerPhone = const Value.absent(),
                Value<LandTenure?> landTenure = const Value.absent(),
                Value<String?> waterSource = const Value.absent(),
                Value<int?> vehicleDistanceM = const Value.absent(),
                Value<String?> roadNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiariesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                name: name,
                latitude: latitude,
                longitude: longitude,
                altitudeM: altitudeM,
                landownerName: landownerName,
                landownerPhone: landownerPhone,
                landTenure: landTenure,
                waterSource: waterSource,
                vehicleDistanceM: vehicleDistanceM,
                roadNotes: roadNotes,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String name,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int?> altitudeM = const Value.absent(),
                Value<String?> landownerName = const Value.absent(),
                Value<String?> landownerPhone = const Value.absent(),
                Value<LandTenure?> landTenure = const Value.absent(),
                Value<String?> waterSource = const Value.absent(),
                Value<int?> vehicleDistanceM = const Value.absent(),
                Value<String?> roadNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiariesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                name: name,
                latitude: latitude,
                longitude: longitude,
                altitudeM: altitudeM,
                landownerName: landownerName,
                landownerPhone: landownerPhone,
                landTenure: landTenure,
                waterSource: waterSource,
                vehicleDistanceM: vehicleDistanceM,
                roadNotes: roadNotes,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ApiariesTable, Apiary>(table),
                  BaseReferences<_$AppDatabase, $ApiariesTable, Apiary>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApiariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApiariesTable,
      Apiary,
      $$ApiariesTableFilterComposer,
      $$ApiariesTableOrderingComposer,
      $$ApiariesTableAnnotationComposer,
      $$ApiariesTableCreateCompanionBuilder,
      $$ApiariesTableUpdateCompanionBuilder,
      (Apiary, BaseReferences<_$AppDatabase, $ApiariesTable, Apiary>),
      Apiary,
      PrefetchHooks Function()
    >;
typedef $$QueensTableCreateCompanionBuilder = QueensCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  required String orgId,
  Value<int?> year,
  Value<QueenMarkColor?> markColor,
  Value<String?> breed,
  Value<String?> breedLine,
  Value<QueenSource?> source,
  Value<QueenMatingStatus?> matingStatus,
  Value<bool> wingClipped,
  Value<String?> motherQueenId,
  Value<int> rowid,
});
typedef $$QueensTableUpdateCompanionBuilder = QueensCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  Value<String> orgId,
  Value<int?> year,
  Value<QueenMarkColor?> markColor,
  Value<String?> breed,
  Value<String?> breedLine,
  Value<QueenSource?> source,
  Value<QueenMatingStatus?> matingStatus,
  Value<bool> wingClipped,
  Value<String?> motherQueenId,
  Value<int> rowid,
});

class $$QueensTableFilterComposer
    extends Composer<_$AppDatabase, $QueensTable> {
  $$QueensTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueenMarkColor?, QueenMarkColor, String>
  get markColor => $composableBuilder(
    column: $table.markColor,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breedLine => $composableBuilder(
    column: $table.breedLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueenSource?, QueenSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<QueenMatingStatus?, QueenMatingStatus, String>
  get matingStatus => $composableBuilder(
    column: $table.matingStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get wingClipped => $composableBuilder(
    column: $table.wingClipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motherQueenId => $composableBuilder(
    column: $table.motherQueenId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueensTableOrderingComposer
    extends Composer<_$AppDatabase, $QueensTable> {
  $$QueensTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get markColor => $composableBuilder(
    column: $table.markColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breedLine => $composableBuilder(
    column: $table.breedLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matingStatus => $composableBuilder(
    column: $table.matingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wingClipped => $composableBuilder(
    column: $table.wingClipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motherQueenId => $composableBuilder(
    column: $table.motherQueenId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueensTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueensTable> {
  $$QueensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueenMarkColor?, String> get markColor =>
      $composableBuilder(column: $table.markColor, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get breedLine =>
      $composableBuilder(column: $table.breedLine, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueenSource?, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QueenMatingStatus?, String>
  get matingStatus => $composableBuilder(
    column: $table.matingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wingClipped => $composableBuilder(
    column: $table.wingClipped,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motherQueenId => $composableBuilder(
    column: $table.motherQueenId,
    builder: (column) => column,
  );
}

class $$QueensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QueensTable,
          Queen,
          $$QueensTableFilterComposer,
          $$QueensTableOrderingComposer,
          $$QueensTableAnnotationComposer,
          $$QueensTableCreateCompanionBuilder,
          $$QueensTableUpdateCompanionBuilder,
          (Queen, BaseReferences<_$AppDatabase, $QueensTable, Queen>),
          Queen,
          PrefetchHooks Function()
        > {
  $$QueensTableTableManager(_$AppDatabase db, $QueensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<QueenMarkColor?> markColor = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<String?> breedLine = const Value.absent(),
                Value<QueenSource?> source = const Value.absent(),
                Value<QueenMatingStatus?> matingStatus = const Value.absent(),
                Value<bool> wingClipped = const Value.absent(),
                Value<String?> motherQueenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueensCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                year: year,
                markColor: markColor,
                breed: breed,
                breedLine: breedLine,
                source: source,
                matingStatus: matingStatus,
                wingClipped: wingClipped,
                motherQueenId: motherQueenId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                Value<int?> year = const Value.absent(),
                Value<QueenMarkColor?> markColor = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<String?> breedLine = const Value.absent(),
                Value<QueenSource?> source = const Value.absent(),
                Value<QueenMatingStatus?> matingStatus = const Value.absent(),
                Value<bool> wingClipped = const Value.absent(),
                Value<String?> motherQueenId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueensCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                year: year,
                markColor: markColor,
                breed: breed,
                breedLine: breedLine,
                source: source,
                matingStatus: matingStatus,
                wingClipped: wingClipped,
                motherQueenId: motherQueenId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QueensTable, Queen>(table),
                  BaseReferences<_$AppDatabase, $QueensTable, Queen>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QueensTable,
      Queen,
      $$QueensTableFilterComposer,
      $$QueensTableOrderingComposer,
      $$QueensTableAnnotationComposer,
      $$QueensTableCreateCompanionBuilder,
      $$QueensTableUpdateCompanionBuilder,
      (Queen, BaseReferences<_$AppDatabase, $QueensTable, Queen>),
      Queen,
      PrefetchHooks Function()
    >;
typedef $$HivesTableCreateCompanionBuilder = HivesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  required String orgId,
  required String number,
  Value<String?> tagCode,
  required HiveType type,
  required HiveStatus status,
  required String apiaryId,
  Value<String?> queenId,
  Value<int> boxCount,
  Value<int?> frameCount,
  Value<HiveSource?> source,
  Value<String?> marking,
  Value<int> rowid,
});
typedef $$HivesTableUpdateCompanionBuilder = HivesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  Value<String> orgId,
  Value<String> number,
  Value<String?> tagCode,
  Value<HiveType> type,
  Value<HiveStatus> status,
  Value<String> apiaryId,
  Value<String?> queenId,
  Value<int> boxCount,
  Value<int?> frameCount,
  Value<HiveSource?> source,
  Value<String?> marking,
  Value<int> rowid,
});

class $$HivesTableFilterComposer extends Composer<_$AppDatabase, $HivesTable> {
  $$HivesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagCode => $composableBuilder(
    column: $table.tagCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HiveType, HiveType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<HiveStatus, HiveStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get queenId => $composableBuilder(
    column: $table.queenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boxCount => $composableBuilder(
    column: $table.boxCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frameCount => $composableBuilder(
    column: $table.frameCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HiveSource?, HiveSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get marking => $composableBuilder(
    column: $table.marking,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HivesTableOrderingComposer
    extends Composer<_$AppDatabase, $HivesTable> {
  $$HivesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagCode => $composableBuilder(
    column: $table.tagCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queenId => $composableBuilder(
    column: $table.queenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boxCount => $composableBuilder(
    column: $table.boxCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frameCount => $composableBuilder(
    column: $table.frameCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marking => $composableBuilder(
    column: $table.marking,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HivesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HivesTable> {
  $$HivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get tagCode =>
      $composableBuilder(column: $table.tagCode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HiveType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HiveStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get apiaryId =>
      $composableBuilder(column: $table.apiaryId, builder: (column) => column);

  GeneratedColumn<String> get queenId =>
      $composableBuilder(column: $table.queenId, builder: (column) => column);

  GeneratedColumn<int> get boxCount =>
      $composableBuilder(column: $table.boxCount, builder: (column) => column);

  GeneratedColumn<int> get frameCount => $composableBuilder(
    column: $table.frameCount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HiveSource?, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get marking =>
      $composableBuilder(column: $table.marking, builder: (column) => column);
}

class $$HivesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HivesTable,
          Hive,
          $$HivesTableFilterComposer,
          $$HivesTableOrderingComposer,
          $$HivesTableAnnotationComposer,
          $$HivesTableCreateCompanionBuilder,
          $$HivesTableUpdateCompanionBuilder,
          (Hive, BaseReferences<_$AppDatabase, $HivesTable, Hive>),
          Hive,
          PrefetchHooks Function()
        > {
  $$HivesTableTableManager(_$AppDatabase db, $HivesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HivesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HivesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String?> tagCode = const Value.absent(),
                Value<HiveType> type = const Value.absent(),
                Value<HiveStatus> status = const Value.absent(),
                Value<String> apiaryId = const Value.absent(),
                Value<String?> queenId = const Value.absent(),
                Value<int> boxCount = const Value.absent(),
                Value<int?> frameCount = const Value.absent(),
                Value<HiveSource?> source = const Value.absent(),
                Value<String?> marking = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HivesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                number: number,
                tagCode: tagCode,
                type: type,
                status: status,
                apiaryId: apiaryId,
                queenId: queenId,
                boxCount: boxCount,
                frameCount: frameCount,
                source: source,
                marking: marking,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String number,
                Value<String?> tagCode = const Value.absent(),
                required HiveType type,
                required HiveStatus status,
                required String apiaryId,
                Value<String?> queenId = const Value.absent(),
                Value<int> boxCount = const Value.absent(),
                Value<int?> frameCount = const Value.absent(),
                Value<HiveSource?> source = const Value.absent(),
                Value<String?> marking = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HivesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                number: number,
                tagCode: tagCode,
                type: type,
                status: status,
                apiaryId: apiaryId,
                queenId: queenId,
                boxCount: boxCount,
                frameCount: frameCount,
                source: source,
                marking: marking,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HivesTable, Hive>(table),
                  BaseReferences<_$AppDatabase, $HivesTable, Hive>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HivesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HivesTable,
      Hive,
      $$HivesTableFilterComposer,
      $$HivesTableOrderingComposer,
      $$HivesTableAnnotationComposer,
      $$HivesTableCreateCompanionBuilder,
      $$HivesTableUpdateCompanionBuilder,
      (Hive, BaseReferences<_$AppDatabase, $HivesTable, Hive>),
      Hive,
      PrefetchHooks Function()
    >;
typedef $$HiveLocationHistoryTableCreateCompanionBuilder =
    HiveLocationHistoryCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      required String orgId,
      required String hiveId,
      required String apiaryId,
      required DateTime movedAt,
      Value<int> rowid,
    });
typedef $$HiveLocationHistoryTableUpdateCompanionBuilder =
    HiveLocationHistoryCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      Value<String> orgId,
      Value<String> hiveId,
      Value<String> apiaryId,
      Value<DateTime> movedAt,
      Value<int> rowid,
    });

class $$HiveLocationHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $HiveLocationHistoryTable> {
  $$HiveLocationHistoryTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get movedAt => $composableBuilder(
    column: $table.movedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HiveLocationHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $HiveLocationHistoryTable> {
  $$HiveLocationHistoryTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get movedAt => $composableBuilder(
    column: $table.movedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HiveLocationHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiveLocationHistoryTable> {
  $$HiveLocationHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get hiveId =>
      $composableBuilder(column: $table.hiveId, builder: (column) => column);

  GeneratedColumn<String> get apiaryId =>
      $composableBuilder(column: $table.apiaryId, builder: (column) => column);

  GeneratedColumn<DateTime> get movedAt =>
      $composableBuilder(column: $table.movedAt, builder: (column) => column);
}

class $$HiveLocationHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiveLocationHistoryTable,
          HiveLocationEntry,
          $$HiveLocationHistoryTableFilterComposer,
          $$HiveLocationHistoryTableOrderingComposer,
          $$HiveLocationHistoryTableAnnotationComposer,
          $$HiveLocationHistoryTableCreateCompanionBuilder,
          $$HiveLocationHistoryTableUpdateCompanionBuilder,
          (
            HiveLocationEntry,
            BaseReferences<
              _$AppDatabase,
              $HiveLocationHistoryTable,
              HiveLocationEntry
            >,
          ),
          HiveLocationEntry,
          PrefetchHooks Function()
        > {
  $$HiveLocationHistoryTableTableManager(
    _$AppDatabase db,
    $HiveLocationHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiveLocationHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiveLocationHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HiveLocationHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> hiveId = const Value.absent(),
                Value<String> apiaryId = const Value.absent(),
                Value<DateTime> movedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HiveLocationHistoryCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                apiaryId: apiaryId,
                movedAt: movedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String hiveId,
                required String apiaryId,
                required DateTime movedAt,
                Value<int> rowid = const Value.absent(),
              }) => HiveLocationHistoryCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                apiaryId: apiaryId,
                movedAt: movedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HiveLocationHistoryTable, HiveLocationEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $HiveLocationHistoryTable,
                    HiveLocationEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HiveLocationHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiveLocationHistoryTable,
      HiveLocationEntry,
      $$HiveLocationHistoryTableFilterComposer,
      $$HiveLocationHistoryTableOrderingComposer,
      $$HiveLocationHistoryTableAnnotationComposer,
      $$HiveLocationHistoryTableCreateCompanionBuilder,
      $$HiveLocationHistoryTableUpdateCompanionBuilder,
      (
        HiveLocationEntry,
        BaseReferences<
          _$AppDatabase,
          $HiveLocationHistoryTable,
          HiveLocationEntry
        >,
      ),
      HiveLocationEntry,
      PrefetchHooks Function()
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      required String orgId,
      required String hiveId,
      required String apiaryId,
      required DateTime inspectedAt,
      Value<QueenState?> queenState,
      Value<int?> beeFrames,
      Value<int?> broodFrames,
      Value<int?> honeyFrames,
      Value<Temperament?> temperament,
      Value<bool?> swarmSigns,
      Value<QueenCells?> queenCells,
      Value<bool?> diseaseSuspected,
      Value<Map<String, Object?>> data,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> createdBy,
      Value<DateTime?> deletedAt,
      Value<int?> serverSeq,
      Value<String> orgId,
      Value<String> hiveId,
      Value<String> apiaryId,
      Value<DateTime> inspectedAt,
      Value<QueenState?> queenState,
      Value<int?> beeFrames,
      Value<int?> broodFrames,
      Value<int?> honeyFrames,
      Value<Temperament?> temperament,
      Value<bool?> swarmSigns,
      Value<QueenCells?> queenCells,
      Value<bool?> diseaseSuspected,
      Value<Map<String, Object?>> data,
      Value<int> rowid,
    });

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inspectedAt => $composableBuilder(
    column: $table.inspectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueenState?, QueenState, String>
  get queenState => $composableBuilder(
    column: $table.queenState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get beeFrames => $composableBuilder(
    column: $table.beeFrames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get broodFrames => $composableBuilder(
    column: $table.broodFrames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get honeyFrames => $composableBuilder(
    column: $table.honeyFrames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Temperament?, Temperament, String>
  get temperament => $composableBuilder(
    column: $table.temperament,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get swarmSigns => $composableBuilder(
    column: $table.swarmSigns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QueenCells?, QueenCells, String>
  get queenCells => $composableBuilder(
    column: $table.queenCells,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get diseaseSuspected => $composableBuilder(
    column: $table.diseaseSuspected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiaryId => $composableBuilder(
    column: $table.apiaryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inspectedAt => $composableBuilder(
    column: $table.inspectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queenState => $composableBuilder(
    column: $table.queenState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beeFrames => $composableBuilder(
    column: $table.beeFrames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get broodFrames => $composableBuilder(
    column: $table.broodFrames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get honeyFrames => $composableBuilder(
    column: $table.honeyFrames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperament => $composableBuilder(
    column: $table.temperament,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get swarmSigns => $composableBuilder(
    column: $table.swarmSigns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queenCells => $composableBuilder(
    column: $table.queenCells,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get diseaseSuspected => $composableBuilder(
    column: $table.diseaseSuspected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get hiveId =>
      $composableBuilder(column: $table.hiveId, builder: (column) => column);

  GeneratedColumn<String> get apiaryId =>
      $composableBuilder(column: $table.apiaryId, builder: (column) => column);

  GeneratedColumn<DateTime> get inspectedAt => $composableBuilder(
    column: $table.inspectedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QueenState?, String> get queenState =>
      $composableBuilder(
        column: $table.queenState,
        builder: (column) => column,
      );

  GeneratedColumn<int> get beeFrames =>
      $composableBuilder(column: $table.beeFrames, builder: (column) => column);

  GeneratedColumn<int> get broodFrames => $composableBuilder(
    column: $table.broodFrames,
    builder: (column) => column,
  );

  GeneratedColumn<int> get honeyFrames => $composableBuilder(
    column: $table.honeyFrames,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Temperament?, String> get temperament =>
      $composableBuilder(
        column: $table.temperament,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get swarmSigns => $composableBuilder(
    column: $table.swarmSigns,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QueenCells?, String> get queenCells =>
      $composableBuilder(
        column: $table.queenCells,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get diseaseSuspected => $composableBuilder(
    column: $table.diseaseSuspected,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (
            Inspection,
            BaseReferences<_$AppDatabase, $InspectionsTable, Inspection>,
          ),
          Inspection,
          PrefetchHooks Function()
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> hiveId = const Value.absent(),
                Value<String> apiaryId = const Value.absent(),
                Value<DateTime> inspectedAt = const Value.absent(),
                Value<QueenState?> queenState = const Value.absent(),
                Value<int?> beeFrames = const Value.absent(),
                Value<int?> broodFrames = const Value.absent(),
                Value<int?> honeyFrames = const Value.absent(),
                Value<Temperament?> temperament = const Value.absent(),
                Value<bool?> swarmSigns = const Value.absent(),
                Value<QueenCells?> queenCells = const Value.absent(),
                Value<bool?> diseaseSuspected = const Value.absent(),
                Value<Map<String, Object?>> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                apiaryId: apiaryId,
                inspectedAt: inspectedAt,
                queenState: queenState,
                beeFrames: beeFrames,
                broodFrames: broodFrames,
                honeyFrames: honeyFrames,
                temperament: temperament,
                swarmSigns: swarmSigns,
                queenCells: queenCells,
                diseaseSuspected: diseaseSuspected,
                data: data,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String hiveId,
                required String apiaryId,
                required DateTime inspectedAt,
                Value<QueenState?> queenState = const Value.absent(),
                Value<int?> beeFrames = const Value.absent(),
                Value<int?> broodFrames = const Value.absent(),
                Value<int?> honeyFrames = const Value.absent(),
                Value<Temperament?> temperament = const Value.absent(),
                Value<bool?> swarmSigns = const Value.absent(),
                Value<QueenCells?> queenCells = const Value.absent(),
                Value<bool?> diseaseSuspected = const Value.absent(),
                Value<Map<String, Object?>> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                apiaryId: apiaryId,
                inspectedAt: inspectedAt,
                queenState: queenState,
                beeFrames: beeFrames,
                broodFrames: broodFrames,
                honeyFrames: honeyFrames,
                temperament: temperament,
                swarmSigns: swarmSigns,
                queenCells: queenCells,
                diseaseSuspected: diseaseSuspected,
                data: data,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionsTable, Inspection>(table),
                  BaseReferences<_$AppDatabase, $InspectionsTable, Inspection>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (
        Inspection,
        BaseReferences<_$AppDatabase, $InspectionsTable, Inspection>,
      ),
      Inspection,
      PrefetchHooks Function()
    >;
typedef $$InspectionDraftsTableCreateCompanionBuilder =
    InspectionDraftsCompanion Function({
      required String hiveId,
      required String orgId,
      required InspectionDraft draft,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InspectionDraftsTableUpdateCompanionBuilder =
    InspectionDraftsCompanion Function({
      Value<String> hiveId,
      Value<String> orgId,
      Value<InspectionDraft> draft,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InspectionDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionDraftsTable> {
  $$InspectionDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionDraft, InspectionDraft, String>
  get draft => $composableBuilder(
    column: $table.draft,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionDraftsTable> {
  $$InspectionDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draft => $composableBuilder(
    column: $table.draft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionDraftsTable> {
  $$InspectionDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hiveId =>
      $composableBuilder(column: $table.hiveId, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionDraft, String> get draft =>
      $composableBuilder(column: $table.draft, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InspectionDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionDraftsTable,
          InspectionDraftRow,
          $$InspectionDraftsTableFilterComposer,
          $$InspectionDraftsTableOrderingComposer,
          $$InspectionDraftsTableAnnotationComposer,
          $$InspectionDraftsTableCreateCompanionBuilder,
          $$InspectionDraftsTableUpdateCompanionBuilder,
          (
            InspectionDraftRow,
            BaseReferences<
              _$AppDatabase,
              $InspectionDraftsTable,
              InspectionDraftRow
            >,
          ),
          InspectionDraftRow,
          PrefetchHooks Function()
        > {
  $$InspectionDraftsTableTableManager(
    _$AppDatabase db,
    $InspectionDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hiveId = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<InspectionDraft> draft = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionDraftsCompanion(
                hiveId: hiveId,
                orgId: orgId,
                draft: draft,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hiveId,
                required String orgId,
                required InspectionDraft draft,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionDraftsCompanion.insert(
                hiveId: hiveId,
                orgId: orgId,
                draft: draft,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionDraftsTable, InspectionDraftRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionDraftsTable,
                    InspectionDraftRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionDraftsTable,
      InspectionDraftRow,
      $$InspectionDraftsTableFilterComposer,
      $$InspectionDraftsTableOrderingComposer,
      $$InspectionDraftsTableAnnotationComposer,
      $$InspectionDraftsTableCreateCompanionBuilder,
      $$InspectionDraftsTableUpdateCompanionBuilder,
      (
        InspectionDraftRow,
        BaseReferences<
          _$AppDatabase,
          $InspectionDraftsTable,
          InspectionDraftRow
        >,
      ),
      InspectionDraftRow,
      PrefetchHooks Function()
    >;
typedef $$InspectionRemindersTableCreateCompanionBuilder =
    InspectionRemindersCompanion Function({
      required String inspectionId,
      required String orgId,
      required String hiveId,
      required int days,
      required DateTime remindAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$InspectionRemindersTableUpdateCompanionBuilder =
    InspectionRemindersCompanion Function({
      Value<String> inspectionId,
      Value<String> orgId,
      Value<String> hiveId,
      Value<int> days,
      Value<DateTime> remindAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$InspectionRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionRemindersTable> {
  $$InspectionRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionRemindersTable> {
  $$InspectionRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionRemindersTable> {
  $$InspectionRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get hiveId =>
      $composableBuilder(column: $table.hiveId, builder: (column) => column);

  GeneratedColumn<int> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InspectionRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionRemindersTable,
          InspectionReminder,
          $$InspectionRemindersTableFilterComposer,
          $$InspectionRemindersTableOrderingComposer,
          $$InspectionRemindersTableAnnotationComposer,
          $$InspectionRemindersTableCreateCompanionBuilder,
          $$InspectionRemindersTableUpdateCompanionBuilder,
          (
            InspectionReminder,
            BaseReferences<
              _$AppDatabase,
              $InspectionRemindersTable,
              InspectionReminder
            >,
          ),
          InspectionReminder,
          PrefetchHooks Function()
        > {
  $$InspectionRemindersTableTableManager(
    _$AppDatabase db,
    $InspectionRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionRemindersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InspectionRemindersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> inspectionId = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> hiveId = const Value.absent(),
                Value<int> days = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionRemindersCompanion(
                inspectionId: inspectionId,
                orgId: orgId,
                hiveId: hiveId,
                days: days,
                remindAt: remindAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String inspectionId,
                required String orgId,
                required String hiveId,
                required int days,
                required DateTime remindAt,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => InspectionRemindersCompanion.insert(
                inspectionId: inspectionId,
                orgId: orgId,
                hiveId: hiveId,
                days: days,
                remindAt: remindAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionRemindersTable, InspectionReminder>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionRemindersTable,
                    InspectionReminder
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionRemindersTable,
      InspectionReminder,
      $$InspectionRemindersTableFilterComposer,
      $$InspectionRemindersTableOrderingComposer,
      $$InspectionRemindersTableAnnotationComposer,
      $$InspectionRemindersTableCreateCompanionBuilder,
      $$InspectionRemindersTableUpdateCompanionBuilder,
      (
        InspectionReminder,
        BaseReferences<
          _$AppDatabase,
          $InspectionRemindersTable,
          InspectionReminder
        >,
      ),
      InspectionReminder,
      PrefetchHooks Function()
    >;
typedef $$MediaTableCreateCompanionBuilder = MediaCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  required String orgId,
  required String hiveId,
  Value<String?> inspectionId,
  required MediaKind kind,
  required String storagePath,
  required DateTime capturedAt,
  required int byteSize,
  Value<int?> durationMs,
  Value<int> rowid,
});
typedef $$MediaTableUpdateCompanionBuilder = MediaCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> createdBy,
  Value<DateTime?> deletedAt,
  Value<int?> serverSeq,
  Value<String> orgId,
  Value<String> hiveId,
  Value<String?> inspectionId,
  Value<MediaKind> kind,
  Value<String> storagePath,
  Value<DateTime> capturedAt,
  Value<int> byteSize,
  Value<int?> durationMs,
  Value<int> rowid,
});

class $$MediaTableFilterComposer extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MediaKind, MediaKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiveId => $composableBuilder(
    column: $table.hiveId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaTable> {
  $$MediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get hiveId =>
      $composableBuilder(column: $table.hiveId, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MediaKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );
}

class $$MediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaTable,
          MediaItem,
          $$MediaTableFilterComposer,
          $$MediaTableOrderingComposer,
          $$MediaTableAnnotationComposer,
          $$MediaTableCreateCompanionBuilder,
          $$MediaTableUpdateCompanionBuilder,
          (MediaItem, BaseReferences<_$AppDatabase, $MediaTable, MediaItem>),
          MediaItem,
          PrefetchHooks Function()
        > {
  $$MediaTableTableManager(_$AppDatabase db, $MediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> hiveId = const Value.absent(),
                Value<String?> inspectionId = const Value.absent(),
                Value<MediaKind> kind = const Value.absent(),
                Value<String> storagePath = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                inspectionId: inspectionId,
                kind: kind,
                storagePath: storagePath,
                capturedAt: capturedAt,
                byteSize: byteSize,
                durationMs: durationMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                required String orgId,
                required String hiveId,
                Value<String?> inspectionId = const Value.absent(),
                required MediaKind kind,
                required String storagePath,
                required DateTime capturedAt,
                required int byteSize,
                Value<int?> durationMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                deletedAt: deletedAt,
                serverSeq: serverSeq,
                orgId: orgId,
                hiveId: hiveId,
                inspectionId: inspectionId,
                kind: kind,
                storagePath: storagePath,
                capturedAt: capturedAt,
                byteSize: byteSize,
                durationMs: durationMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaTable, MediaItem>(table),
                  BaseReferences<_$AppDatabase, $MediaTable, MediaItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaTable,
      MediaItem,
      $$MediaTableFilterComposer,
      $$MediaTableOrderingComposer,
      $$MediaTableAnnotationComposer,
      $$MediaTableCreateCompanionBuilder,
      $$MediaTableUpdateCompanionBuilder,
      (MediaItem, BaseReferences<_$AppDatabase, $MediaTable, MediaItem>),
      MediaItem,
      PrefetchHooks Function()
    >;
typedef $$MediaUploadsTableCreateCompanionBuilder =
    MediaUploadsCompanion Function({
      required String mediaId,
      required String orgId,
      required String fileName,
      required MediaUploadStatus uploadStatus,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MediaUploadsTableUpdateCompanionBuilder =
    MediaUploadsCompanion Function({
      Value<String> mediaId,
      Value<String> orgId,
      Value<String> fileName,
      Value<MediaUploadStatus> uploadStatus,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MediaUploadsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaUploadsTable> {
  $$MediaUploadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MediaUploadStatus, MediaUploadStatus, String>
  get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaUploadsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaUploadsTable> {
  $$MediaUploadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaUploadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaUploadsTable> {
  $$MediaUploadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaUploadStatus, String>
  get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MediaUploadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaUploadsTable,
          MediaUpload,
          $$MediaUploadsTableFilterComposer,
          $$MediaUploadsTableOrderingComposer,
          $$MediaUploadsTableAnnotationComposer,
          $$MediaUploadsTableCreateCompanionBuilder,
          $$MediaUploadsTableUpdateCompanionBuilder,
          (
            MediaUpload,
            BaseReferences<_$AppDatabase, $MediaUploadsTable, MediaUpload>,
          ),
          MediaUpload,
          PrefetchHooks Function()
        > {
  $$MediaUploadsTableTableManager(_$AppDatabase db, $MediaUploadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaUploadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaUploadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaUploadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> mediaId = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<MediaUploadStatus> uploadStatus = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaUploadsCompanion(
                mediaId: mediaId,
                orgId: orgId,
                fileName: fileName,
                uploadStatus: uploadStatus,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaId,
                required String orgId,
                required String fileName,
                required MediaUploadStatus uploadStatus,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaUploadsCompanion.insert(
                mediaId: mediaId,
                orgId: orgId,
                fileName: fileName,
                uploadStatus: uploadStatus,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaUploadsTable, MediaUpload>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MediaUploadsTable,
                    MediaUpload
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaUploadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaUploadsTable,
      MediaUpload,
      $$MediaUploadsTableFilterComposer,
      $$MediaUploadsTableOrderingComposer,
      $$MediaUploadsTableAnnotationComposer,
      $$MediaUploadsTableCreateCompanionBuilder,
      $$MediaUploadsTableUpdateCompanionBuilder,
      (
        MediaUpload,
        BaseReferences<_$AppDatabase, $MediaUploadsTable, MediaUpload>,
      ),
      MediaUpload,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LocalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettingsTable,
                    LocalSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  required String recordTable,
  required String recordId,
  required OutboxOperation operation,
  required Map<String, Object?> payload,
  required DateTime createdAt,
  Value<int> attempts,
  Value<String?> lastError,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> id,
  Value<String> recordTable,
  Value<String> recordId,
  Value<OutboxOperation> operation,
  Value<Map<String, Object?>> payload,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<String?> lastError,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OutboxOperation, OutboxOperation, String>
  get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OutboxOperation, String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxEntry,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> recordTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<OutboxOperation> operation = const Value.absent(),
                Value<Map<String, Object?>> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                recordTable: recordTable,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String recordTable,
                required String recordId,
                required OutboxOperation operation,
                required Map<String, Object?> payload,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                recordTable: recordTable,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxEntry>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxEntry,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxEntry, BaseReferences<_$AppDatabase, $OutboxTable, OutboxEntry>),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  required String recordTable,
  Value<int> lastPulledSeq,
  Value<int> rowid,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<String> recordTable,
  Value<int> lastPulledSeq,
  Value<int> rowid,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPulledSeq => $composableBuilder(
    column: $table.lastPulledSeq,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPulledSeq => $composableBuilder(
    column: $table.lastPulledSeq,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recordTable => $composableBuilder(
    column: $table.recordTable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPulledSeq => $composableBuilder(
    column: $table.lastPulledSeq,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncCursor,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recordTable = const Value.absent(),
                Value<int> lastPulledSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                recordTable: recordTable,
                lastPulledSeq: lastPulledSeq,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recordTable,
                Value<int> lastPulledSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                recordTable: recordTable,
                lastPulledSeq: lastPulledSeq,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncCursor>(table),
                  BaseReferences<_$AppDatabase, $SyncStateTable, SyncCursor>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncCursor,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (SyncCursor, BaseReferences<_$AppDatabase, $SyncStateTable, SyncCursor>),
      SyncCursor,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganizationsTableTableManager get organizations =>
      $$OrganizationsTableTableManager(_db, _db.organizations);
  $$MembershipsTableTableManager get memberships =>
      $$MembershipsTableTableManager(_db, _db.memberships);
  $$ApiariesTableTableManager get apiaries =>
      $$ApiariesTableTableManager(_db, _db.apiaries);
  $$QueensTableTableManager get queens =>
      $$QueensTableTableManager(_db, _db.queens);
  $$HivesTableTableManager get hives =>
      $$HivesTableTableManager(_db, _db.hives);
  $$HiveLocationHistoryTableTableManager get hiveLocationHistory =>
      $$HiveLocationHistoryTableTableManager(_db, _db.hiveLocationHistory);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$InspectionDraftsTableTableManager get inspectionDrafts =>
      $$InspectionDraftsTableTableManager(_db, _db.inspectionDrafts);
  $$InspectionRemindersTableTableManager get inspectionReminders =>
      $$InspectionRemindersTableTableManager(_db, _db.inspectionReminders);
  $$MediaTableTableManager get media =>
      $$MediaTableTableManager(_db, _db.media);
  $$MediaUploadsTableTableManager get mediaUploads =>
      $$MediaUploadsTableTableManager(_db, _db.mediaUploads);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
