// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AssetTypesTable extends AssetTypes
    with TableInfo<$AssetTypesTable, AssetType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, code, label, enabled, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_types';
  @override
  VerificationContext validateIntegrity(Insertable<AssetType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $AssetTypesTable createAlias(String alias) {
    return $AssetTypesTable(attachedDatabase, alias);
  }
}

class AssetType extends DataClass implements Insertable<AssetType> {
  final int id;
  final String code;
  final String label;
  final bool enabled;
  final int order;
  const AssetType(
      {required this.id,
      required this.code,
      required this.label,
      required this.enabled,
      required this.order});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['label'] = Variable<String>(label);
    map['enabled'] = Variable<bool>(enabled);
    map['order'] = Variable<int>(order);
    return map;
  }

  AssetTypesCompanion toCompanion(bool nullToAbsent) {
    return AssetTypesCompanion(
      id: Value(id),
      code: Value(code),
      label: Value(label),
      enabled: Value(enabled),
      order: Value(order),
    );
  }

  factory AssetType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetType(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      label: serializer.fromJson<String>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'label': serializer.toJson<String>(label),
      'enabled': serializer.toJson<bool>(enabled),
      'order': serializer.toJson<int>(order),
    };
  }

  AssetType copyWith(
          {int? id, String? code, String? label, bool? enabled, int? order}) =>
      AssetType(
        id: id ?? this.id,
        code: code ?? this.code,
        label: label ?? this.label,
        enabled: enabled ?? this.enabled,
        order: order ?? this.order,
      );
  AssetType copyWithCompanion(AssetTypesCompanion data) {
    return AssetType(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetType(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, label, enabled, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetType &&
          other.id == this.id &&
          other.code == this.code &&
          other.label == this.label &&
          other.enabled == this.enabled &&
          other.order == this.order);
}

class AssetTypesCompanion extends UpdateCompanion<AssetType> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> label;
  final Value<bool> enabled;
  final Value<int> order;
  const AssetTypesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.order = const Value.absent(),
  });
  AssetTypesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String label,
    this.enabled = const Value.absent(),
    this.order = const Value.absent(),
  })  : code = Value(code),
        label = Value(label);
  static Insertable<AssetType> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? label,
    Expression<bool>? enabled,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
      if (order != null) 'order': order,
    });
  }

  AssetTypesCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? label,
      Value<bool>? enabled,
      Value<int>? order}) {
    return AssetTypesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetTypesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $LiabilityTypesTable extends LiabilityTypes
    with TableInfo<$LiabilityTypesTable, LiabilityType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiabilityTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, code, label, enabled, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liability_types';
  @override
  VerificationContext validateIntegrity(Insertable<LiabilityType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LiabilityType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiabilityType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $LiabilityTypesTable createAlias(String alias) {
    return $LiabilityTypesTable(attachedDatabase, alias);
  }
}

class LiabilityType extends DataClass implements Insertable<LiabilityType> {
  final int id;
  final String code;
  final String label;
  final bool enabled;
  final int order;
  const LiabilityType(
      {required this.id,
      required this.code,
      required this.label,
      required this.enabled,
      required this.order});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['label'] = Variable<String>(label);
    map['enabled'] = Variable<bool>(enabled);
    map['order'] = Variable<int>(order);
    return map;
  }

  LiabilityTypesCompanion toCompanion(bool nullToAbsent) {
    return LiabilityTypesCompanion(
      id: Value(id),
      code: Value(code),
      label: Value(label),
      enabled: Value(enabled),
      order: Value(order),
    );
  }

  factory LiabilityType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiabilityType(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      label: serializer.fromJson<String>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'label': serializer.toJson<String>(label),
      'enabled': serializer.toJson<bool>(enabled),
      'order': serializer.toJson<int>(order),
    };
  }

  LiabilityType copyWith(
          {int? id, String? code, String? label, bool? enabled, int? order}) =>
      LiabilityType(
        id: id ?? this.id,
        code: code ?? this.code,
        label: label ?? this.label,
        enabled: enabled ?? this.enabled,
        order: order ?? this.order,
      );
  LiabilityType copyWithCompanion(LiabilityTypesCompanion data) {
    return LiabilityType(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiabilityType(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, label, enabled, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiabilityType &&
          other.id == this.id &&
          other.code == this.code &&
          other.label == this.label &&
          other.enabled == this.enabled &&
          other.order == this.order);
}

class LiabilityTypesCompanion extends UpdateCompanion<LiabilityType> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> label;
  final Value<bool> enabled;
  final Value<int> order;
  const LiabilityTypesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.order = const Value.absent(),
  });
  LiabilityTypesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String label,
    this.enabled = const Value.absent(),
    this.order = const Value.absent(),
  })  : code = Value(code),
        label = Value(label);
  static Insertable<LiabilityType> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? label,
    Expression<bool>? enabled,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
      if (order != null) 'order': order,
    });
  }

  LiabilityTypesCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? label,
      Value<bool>? enabled,
      Value<int>? order}) {
    return LiabilityTypesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiabilityTypesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES asset_types (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CNY'));
  static const VerificationMeta _valuationDateMeta =
      const VerificationMeta('valuationDate');
  @override
  late final GeneratedColumn<DateTime> valuationDate =
      GeneratedColumn<DateTime>('valuation_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _annualRateMeta =
      const VerificationMeta('annualRate');
  @override
  late final GeneratedColumn<double> annualRate = GeneratedColumn<double>(
      'annual_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        typeId,
        amount,
        currency,
        valuationDate,
        annualRate,
        startDate,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<Asset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('valuation_date')) {
      context.handle(
          _valuationDateMeta,
          valuationDate.isAcceptableOrUnknown(
              data['valuation_date']!, _valuationDateMeta));
    } else if (isInserting) {
      context.missing(_valuationDateMeta);
    }
    if (data.containsKey('annual_rate')) {
      context.handle(
          _annualRateMeta,
          annualRate.isAcceptableOrUnknown(
              data['annual_rate']!, _annualRateMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      valuationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}valuation_date'])!,
      annualRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}annual_rate']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final int id;
  final String name;
  final int typeId;
  final double amount;
  final String currency;
  final DateTime valuationDate;
  final double? annualRate;
  final DateTime? startDate;
  final String? notes;
  const Asset(
      {required this.id,
      required this.name,
      required this.typeId,
      required this.amount,
      required this.currency,
      required this.valuationDate,
      this.annualRate,
      this.startDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type_id'] = Variable<int>(typeId);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['valuation_date'] = Variable<DateTime>(valuationDate);
    if (!nullToAbsent || annualRate != null) {
      map['annual_rate'] = Variable<double>(annualRate);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      typeId: Value(typeId),
      amount: Value(amount),
      currency: Value(currency),
      valuationDate: Value(valuationDate),
      annualRate: annualRate == null && nullToAbsent
          ? const Value.absent()
          : Value(annualRate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      typeId: serializer.fromJson<int>(json['typeId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      valuationDate: serializer.fromJson<DateTime>(json['valuationDate']),
      annualRate: serializer.fromJson<double?>(json['annualRate']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'typeId': serializer.toJson<int>(typeId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'valuationDate': serializer.toJson<DateTime>(valuationDate),
      'annualRate': serializer.toJson<double?>(annualRate),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Asset copyWith(
          {int? id,
          String? name,
          int? typeId,
          double? amount,
          String? currency,
          DateTime? valuationDate,
          Value<double?> annualRate = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Asset(
        id: id ?? this.id,
        name: name ?? this.name,
        typeId: typeId ?? this.typeId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        valuationDate: valuationDate ?? this.valuationDate,
        annualRate: annualRate.present ? annualRate.value : this.annualRate,
        startDate: startDate.present ? startDate.value : this.startDate,
        notes: notes.present ? notes.value : this.notes,
      );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      valuationDate: data.valuationDate.present
          ? data.valuationDate.value
          : this.valuationDate,
      annualRate:
          data.annualRate.present ? data.annualRate.value : this.annualRate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('valuationDate: $valuationDate, ')
          ..write('annualRate: $annualRate, ')
          ..write('startDate: $startDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, typeId, amount, currency,
      valuationDate, annualRate, startDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.name == this.name &&
          other.typeId == this.typeId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.valuationDate == this.valuationDate &&
          other.annualRate == this.annualRate &&
          other.startDate == this.startDate &&
          other.notes == this.notes);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> typeId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<DateTime> valuationDate;
  final Value<double?> annualRate;
  final Value<DateTime?> startDate;
  final Value<String?> notes;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.typeId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.valuationDate = const Value.absent(),
    this.annualRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AssetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int typeId,
    required double amount,
    this.currency = const Value.absent(),
    required DateTime valuationDate,
    this.annualRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.notes = const Value.absent(),
  })  : name = Value(name),
        typeId = Value(typeId),
        amount = Value(amount),
        valuationDate = Value(valuationDate);
  static Insertable<Asset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? typeId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<DateTime>? valuationDate,
    Expression<double>? annualRate,
    Expression<DateTime>? startDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (typeId != null) 'type_id': typeId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (valuationDate != null) 'valuation_date': valuationDate,
      if (annualRate != null) 'annual_rate': annualRate,
      if (startDate != null) 'start_date': startDate,
      if (notes != null) 'notes': notes,
    });
  }

  AssetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? typeId,
      Value<double>? amount,
      Value<String>? currency,
      Value<DateTime>? valuationDate,
      Value<double?>? annualRate,
      Value<DateTime?>? startDate,
      Value<String?>? notes}) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      valuationDate: valuationDate ?? this.valuationDate,
      annualRate: annualRate ?? this.annualRate,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (valuationDate.present) {
      map['valuation_date'] = Variable<DateTime>(valuationDate.value);
    }
    if (annualRate.present) {
      map['annual_rate'] = Variable<double>(annualRate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('valuationDate: $valuationDate, ')
          ..write('annualRate: $annualRate, ')
          ..write('startDate: $startDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $LiabilitiesTable extends Liabilities
    with TableInfo<$LiabilitiesTable, Liability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES liability_types (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CNY'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, typeId, amount, interestRate, dueDate, currency, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liabilities';
  @override
  VerificationContext validateIntegrity(Insertable<Liability> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Liability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Liability(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $LiabilitiesTable createAlias(String alias) {
    return $LiabilitiesTable(attachedDatabase, alias);
  }
}

class Liability extends DataClass implements Insertable<Liability> {
  final int id;
  final String name;
  final int typeId;
  final double amount;
  final double? interestRate;
  final DateTime? dueDate;
  final String currency;
  final String? notes;
  const Liability(
      {required this.id,
      required this.name,
      required this.typeId,
      required this.amount,
      this.interestRate,
      this.dueDate,
      required this.currency,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type_id'] = Variable<int>(typeId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<double>(interestRate);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LiabilitiesCompanion toCompanion(bool nullToAbsent) {
    return LiabilitiesCompanion(
      id: Value(id),
      name: Value(name),
      typeId: Value(typeId),
      amount: Value(amount),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      currency: Value(currency),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Liability.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Liability(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      typeId: serializer.fromJson<int>(json['typeId']),
      amount: serializer.fromJson<double>(json['amount']),
      interestRate: serializer.fromJson<double?>(json['interestRate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'typeId': serializer.toJson<int>(typeId),
      'amount': serializer.toJson<double>(amount),
      'interestRate': serializer.toJson<double?>(interestRate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Liability copyWith(
          {int? id,
          String? name,
          int? typeId,
          double? amount,
          Value<double?> interestRate = const Value.absent(),
          Value<DateTime?> dueDate = const Value.absent(),
          String? currency,
          Value<String?> notes = const Value.absent()}) =>
      Liability(
        id: id ?? this.id,
        name: name ?? this.name,
        typeId: typeId ?? this.typeId,
        amount: amount ?? this.amount,
        interestRate:
            interestRate.present ? interestRate.value : this.interestRate,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        currency: currency ?? this.currency,
        notes: notes.present ? notes.value : this.notes,
      );
  Liability copyWithCompanion(LiabilitiesCompanion data) {
    return Liability(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      amount: data.amount.present ? data.amount.value : this.amount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Liability(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('interestRate: $interestRate, ')
          ..write('dueDate: $dueDate, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, typeId, amount, interestRate, dueDate, currency, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Liability &&
          other.id == this.id &&
          other.name == this.name &&
          other.typeId == this.typeId &&
          other.amount == this.amount &&
          other.interestRate == this.interestRate &&
          other.dueDate == this.dueDate &&
          other.currency == this.currency &&
          other.notes == this.notes);
}

class LiabilitiesCompanion extends UpdateCompanion<Liability> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> typeId;
  final Value<double> amount;
  final Value<double?> interestRate;
  final Value<DateTime?> dueDate;
  final Value<String> currency;
  final Value<String?> notes;
  const LiabilitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.typeId = const Value.absent(),
    this.amount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
  });
  LiabilitiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int typeId,
    required double amount,
    this.interestRate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
  })  : name = Value(name),
        typeId = Value(typeId),
        amount = Value(amount);
  static Insertable<Liability> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? typeId,
    Expression<double>? amount,
    Expression<double>? interestRate,
    Expression<DateTime>? dueDate,
    Expression<String>? currency,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (typeId != null) 'type_id': typeId,
      if (amount != null) 'amount': amount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (dueDate != null) 'due_date': dueDate,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
    });
  }

  LiabilitiesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? typeId,
      Value<double>? amount,
      Value<double?>? interestRate,
      Value<DateTime?>? dueDate,
      Value<String>? currency,
      Value<String?>? notes}) {
    return LiabilitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      interestRate: interestRate ?? this.interestRate,
      dueDate: dueDate ?? this.dueDate,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('interestRate: $interestRate, ')
          ..write('dueDate: $dueDate, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $AssetHoldingsTable extends AssetHoldings
    with TableInfo<$AssetHoldingsTable, AssetHolding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetHoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<int> assetId = GeneratedColumn<int>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, assetId, name, price, quantity, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_holdings';
  @override
  VerificationContext validateIntegrity(Insertable<AssetHolding> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetHolding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetHolding(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asset_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $AssetHoldingsTable createAlias(String alias) {
    return $AssetHoldingsTable(attachedDatabase, alias);
  }
}

class AssetHolding extends DataClass implements Insertable<AssetHolding> {
  final int id;
  final int assetId;
  final String name;
  final double price;
  final double quantity;
  final String? notes;
  const AssetHolding(
      {required this.id,
      required this.assetId,
      required this.name,
      required this.price,
      required this.quantity,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['asset_id'] = Variable<int>(assetId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AssetHoldingsCompanion toCompanion(bool nullToAbsent) {
    return AssetHoldingsCompanion(
      id: Value(id),
      assetId: Value(assetId),
      name: Value(name),
      price: Value(price),
      quantity: Value(quantity),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory AssetHolding.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetHolding(
      id: serializer.fromJson<int>(json['id']),
      assetId: serializer.fromJson<int>(json['assetId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<double>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assetId': serializer.toJson<int>(assetId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<double>(quantity),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  AssetHolding copyWith(
          {int? id,
          int? assetId,
          String? name,
          double? price,
          double? quantity,
          Value<String?> notes = const Value.absent()}) =>
      AssetHolding(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        notes: notes.present ? notes.value : this.notes,
      );
  AssetHolding copyWithCompanion(AssetHoldingsCompanion data) {
    return AssetHolding(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetHolding(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, name, price, quantity, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetHolding &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.name == this.name &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.notes == this.notes);
}

class AssetHoldingsCompanion extends UpdateCompanion<AssetHolding> {
  final Value<int> id;
  final Value<int> assetId;
  final Value<String> name;
  final Value<double> price;
  final Value<double> quantity;
  final Value<String?> notes;
  const AssetHoldingsCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AssetHoldingsCompanion.insert({
    this.id = const Value.absent(),
    required int assetId,
    required String name,
    required double price,
    required double quantity,
    this.notes = const Value.absent(),
  })  : assetId = Value(assetId),
        name = Value(name),
        price = Value(price),
        quantity = Value(quantity);
  static Insertable<AssetHolding> custom({
    Expression<int>? id,
    Expression<int>? assetId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<double>? quantity,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
    });
  }

  AssetHoldingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? assetId,
      Value<String>? name,
      Value<double>? price,
      Value<double>? quantity,
      Value<String?>? notes}) {
    return AssetHoldingsCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<int>(assetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetHoldingsCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $AssetChangesTable extends AssetChanges
    with TableInfo<$AssetChangesTable, AssetChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<int> assetId = GeneratedColumn<int>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _beforeAmountMeta =
      const VerificationMeta('beforeAmount');
  @override
  late final GeneratedColumn<double> beforeAmount = GeneratedColumn<double>(
      'before_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _afterAmountMeta =
      const VerificationMeta('afterAmount');
  @override
  late final GeneratedColumn<double> afterAmount = GeneratedColumn<double>(
      'after_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _differenceMeta =
      const VerificationMeta('difference');
  @override
  late final GeneratedColumn<double> difference = GeneratedColumn<double>(
      'difference', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, assetId, beforeAmount, afterAmount, difference, createdAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_changes';
  @override
  VerificationContext validateIntegrity(Insertable<AssetChange> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('before_amount')) {
      context.handle(
          _beforeAmountMeta,
          beforeAmount.isAcceptableOrUnknown(
              data['before_amount']!, _beforeAmountMeta));
    } else if (isInserting) {
      context.missing(_beforeAmountMeta);
    }
    if (data.containsKey('after_amount')) {
      context.handle(
          _afterAmountMeta,
          afterAmount.isAcceptableOrUnknown(
              data['after_amount']!, _afterAmountMeta));
    } else if (isInserting) {
      context.missing(_afterAmountMeta);
    }
    if (data.containsKey('difference')) {
      context.handle(
          _differenceMeta,
          difference.isAcceptableOrUnknown(
              data['difference']!, _differenceMeta));
    } else if (isInserting) {
      context.missing(_differenceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetChange(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asset_id'])!,
      beforeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}before_amount'])!,
      afterAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}after_amount'])!,
      difference: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difference'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $AssetChangesTable createAlias(String alias) {
    return $AssetChangesTable(attachedDatabase, alias);
  }
}

class AssetChange extends DataClass implements Insertable<AssetChange> {
  final int id;
  final int assetId;
  final double beforeAmount;
  final double afterAmount;
  final double difference;
  final DateTime createdAt;
  final String? notes;
  const AssetChange(
      {required this.id,
      required this.assetId,
      required this.beforeAmount,
      required this.afterAmount,
      required this.difference,
      required this.createdAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['asset_id'] = Variable<int>(assetId);
    map['before_amount'] = Variable<double>(beforeAmount);
    map['after_amount'] = Variable<double>(afterAmount);
    map['difference'] = Variable<double>(difference);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AssetChangesCompanion toCompanion(bool nullToAbsent) {
    return AssetChangesCompanion(
      id: Value(id),
      assetId: Value(assetId),
      beforeAmount: Value(beforeAmount),
      afterAmount: Value(afterAmount),
      difference: Value(difference),
      createdAt: Value(createdAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory AssetChange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetChange(
      id: serializer.fromJson<int>(json['id']),
      assetId: serializer.fromJson<int>(json['assetId']),
      beforeAmount: serializer.fromJson<double>(json['beforeAmount']),
      afterAmount: serializer.fromJson<double>(json['afterAmount']),
      difference: serializer.fromJson<double>(json['difference']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assetId': serializer.toJson<int>(assetId),
      'beforeAmount': serializer.toJson<double>(beforeAmount),
      'afterAmount': serializer.toJson<double>(afterAmount),
      'difference': serializer.toJson<double>(difference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  AssetChange copyWith(
          {int? id,
          int? assetId,
          double? beforeAmount,
          double? afterAmount,
          double? difference,
          DateTime? createdAt,
          Value<String?> notes = const Value.absent()}) =>
      AssetChange(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        beforeAmount: beforeAmount ?? this.beforeAmount,
        afterAmount: afterAmount ?? this.afterAmount,
        difference: difference ?? this.difference,
        createdAt: createdAt ?? this.createdAt,
        notes: notes.present ? notes.value : this.notes,
      );
  AssetChange copyWithCompanion(AssetChangesCompanion data) {
    return AssetChange(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      beforeAmount: data.beforeAmount.present
          ? data.beforeAmount.value
          : this.beforeAmount,
      afterAmount:
          data.afterAmount.present ? data.afterAmount.value : this.afterAmount,
      difference:
          data.difference.present ? data.difference.value : this.difference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetChange(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('beforeAmount: $beforeAmount, ')
          ..write('afterAmount: $afterAmount, ')
          ..write('difference: $difference, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, assetId, beforeAmount, afterAmount, difference, createdAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetChange &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.beforeAmount == this.beforeAmount &&
          other.afterAmount == this.afterAmount &&
          other.difference == this.difference &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes);
}

class AssetChangesCompanion extends UpdateCompanion<AssetChange> {
  final Value<int> id;
  final Value<int> assetId;
  final Value<double> beforeAmount;
  final Value<double> afterAmount;
  final Value<double> difference;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  const AssetChangesCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.beforeAmount = const Value.absent(),
    this.afterAmount = const Value.absent(),
    this.difference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AssetChangesCompanion.insert({
    this.id = const Value.absent(),
    required int assetId,
    required double beforeAmount,
    required double afterAmount,
    required double difference,
    required DateTime createdAt,
    this.notes = const Value.absent(),
  })  : assetId = Value(assetId),
        beforeAmount = Value(beforeAmount),
        afterAmount = Value(afterAmount),
        difference = Value(difference),
        createdAt = Value(createdAt);
  static Insertable<AssetChange> custom({
    Expression<int>? id,
    Expression<int>? assetId,
    Expression<double>? beforeAmount,
    Expression<double>? afterAmount,
    Expression<double>? difference,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (beforeAmount != null) 'before_amount': beforeAmount,
      if (afterAmount != null) 'after_amount': afterAmount,
      if (difference != null) 'difference': difference,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
    });
  }

  AssetChangesCompanion copyWith(
      {Value<int>? id,
      Value<int>? assetId,
      Value<double>? beforeAmount,
      Value<double>? afterAmount,
      Value<double>? difference,
      Value<DateTime>? createdAt,
      Value<String?>? notes}) {
    return AssetChangesCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      beforeAmount: beforeAmount ?? this.beforeAmount,
      afterAmount: afterAmount ?? this.afterAmount,
      difference: difference ?? this.difference,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<int>(assetId.value);
    }
    if (beforeAmount.present) {
      map['before_amount'] = Variable<double>(beforeAmount.value);
    }
    if (afterAmount.present) {
      map['after_amount'] = Variable<double>(afterAmount.value);
    }
    if (difference.present) {
      map['difference'] = Variable<double>(difference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetChangesCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('beforeAmount: $beforeAmount, ')
          ..write('afterAmount: $afterAmount, ')
          ..write('difference: $difference, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, enabled, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Person(
      {required this.id,
      required this.name,
      required this.enabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      name: Value(name),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Person copyWith(
          {int? id,
          String? name,
          bool? enabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, enabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.enabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? enabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PersonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<String> cycle = GeneratedColumn<String>(
      'cycle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES persons (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, amount, cycle, personId, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
          _cycleMeta, cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta));
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      cycle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cycle'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String name;
  final double amount;
  final String cycle;
  final int personId;
  final DateTime date;
  final String? notes;
  const Expense(
      {required this.id,
      required this.name,
      required this.amount,
      required this.cycle,
      required this.personId,
      required this.date,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['cycle'] = Variable<String>(cycle);
    map['person_id'] = Variable<int>(personId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      cycle: Value(cycle),
      personId: Value(personId),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      cycle: serializer.fromJson<String>(json['cycle']),
      personId: serializer.fromJson<int>(json['personId']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'cycle': serializer.toJson<String>(cycle),
      'personId': serializer.toJson<int>(personId),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Expense copyWith(
          {int? id,
          String? name,
          double? amount,
          String? cycle,
          int? personId,
          DateTime? date,
          Value<String?> notes = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        cycle: cycle ?? this.cycle,
        personId: personId ?? this.personId,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      personId: data.personId.present ? data.personId.value : this.personId,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cycle: $cycle, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, amount, cycle, personId, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.cycle == this.cycle &&
          other.personId == this.personId &&
          other.date == this.date &&
          other.notes == this.notes);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> cycle;
  final Value<int> personId;
  final Value<DateTime> date;
  final Value<String?> notes;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.cycle = const Value.absent(),
    this.personId = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double amount,
    required String cycle,
    required int personId,
    required DateTime date,
    this.notes = const Value.absent(),
  })  : name = Value(name),
        amount = Value(amount),
        cycle = Value(cycle),
        personId = Value(personId),
        date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? cycle,
    Expression<int>? personId,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (cycle != null) 'cycle': cycle,
      if (personId != null) 'person_id': personId,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? cycle,
      Value<int>? personId,
      Value<DateTime>? date,
      Value<String?>? notes}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cycle: cycle ?? this.cycle,
      personId: personId ?? this.personId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(cycle.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cycle: $cycle, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, Snapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _totalAssetsMeta =
      const VerificationMeta('totalAssets');
  @override
  late final GeneratedColumn<double> totalAssets = GeneratedColumn<double>(
      'total_assets', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalLiabilitiesMeta =
      const VerificationMeta('totalLiabilities');
  @override
  late final GeneratedColumn<double> totalLiabilities = GeneratedColumn<double>(
      'total_liabilities', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _netWorthMeta =
      const VerificationMeta('netWorth');
  @override
  late final GeneratedColumn<double> netWorth = GeneratedColumn<double>(
      'net_worth', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, totalAssets, totalLiabilities, netWorth, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<Snapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_assets')) {
      context.handle(
          _totalAssetsMeta,
          totalAssets.isAcceptableOrUnknown(
              data['total_assets']!, _totalAssetsMeta));
    } else if (isInserting) {
      context.missing(_totalAssetsMeta);
    }
    if (data.containsKey('total_liabilities')) {
      context.handle(
          _totalLiabilitiesMeta,
          totalLiabilities.isAcceptableOrUnknown(
              data['total_liabilities']!, _totalLiabilitiesMeta));
    } else if (isInserting) {
      context.missing(_totalLiabilitiesMeta);
    }
    if (data.containsKey('net_worth')) {
      context.handle(_netWorthMeta,
          netWorth.isAcceptableOrUnknown(data['net_worth']!, _netWorthMeta));
    } else if (isInserting) {
      context.missing(_netWorthMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      totalAssets: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_assets'])!,
      totalLiabilities: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_liabilities'])!,
      netWorth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_worth'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }
}

class Snapshot extends DataClass implements Insertable<Snapshot> {
  final int id;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;
  final DateTime createdAt;
  const Snapshot(
      {required this.id,
      required this.totalAssets,
      required this.totalLiabilities,
      required this.netWorth,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_assets'] = Variable<double>(totalAssets);
    map['total_liabilities'] = Variable<double>(totalLiabilities);
    map['net_worth'] = Variable<double>(netWorth);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      totalAssets: Value(totalAssets),
      totalLiabilities: Value(totalLiabilities),
      netWorth: Value(netWorth),
      createdAt: Value(createdAt),
    );
  }

  factory Snapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snapshot(
      id: serializer.fromJson<int>(json['id']),
      totalAssets: serializer.fromJson<double>(json['totalAssets']),
      totalLiabilities: serializer.fromJson<double>(json['totalLiabilities']),
      netWorth: serializer.fromJson<double>(json['netWorth']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalAssets': serializer.toJson<double>(totalAssets),
      'totalLiabilities': serializer.toJson<double>(totalLiabilities),
      'netWorth': serializer.toJson<double>(netWorth),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Snapshot copyWith(
          {int? id,
          double? totalAssets,
          double? totalLiabilities,
          double? netWorth,
          DateTime? createdAt}) =>
      Snapshot(
        id: id ?? this.id,
        totalAssets: totalAssets ?? this.totalAssets,
        totalLiabilities: totalLiabilities ?? this.totalLiabilities,
        netWorth: netWorth ?? this.netWorth,
        createdAt: createdAt ?? this.createdAt,
      );
  Snapshot copyWithCompanion(SnapshotsCompanion data) {
    return Snapshot(
      id: data.id.present ? data.id.value : this.id,
      totalAssets:
          data.totalAssets.present ? data.totalAssets.value : this.totalAssets,
      totalLiabilities: data.totalLiabilities.present
          ? data.totalLiabilities.value
          : this.totalLiabilities,
      netWorth: data.netWorth.present ? data.netWorth.value : this.netWorth,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snapshot(')
          ..write('id: $id, ')
          ..write('totalAssets: $totalAssets, ')
          ..write('totalLiabilities: $totalLiabilities, ')
          ..write('netWorth: $netWorth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, totalAssets, totalLiabilities, netWorth, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snapshot &&
          other.id == this.id &&
          other.totalAssets == this.totalAssets &&
          other.totalLiabilities == this.totalLiabilities &&
          other.netWorth == this.netWorth &&
          other.createdAt == this.createdAt);
}

class SnapshotsCompanion extends UpdateCompanion<Snapshot> {
  final Value<int> id;
  final Value<double> totalAssets;
  final Value<double> totalLiabilities;
  final Value<double> netWorth;
  final Value<DateTime> createdAt;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.totalAssets = const Value.absent(),
    this.totalLiabilities = const Value.absent(),
    this.netWorth = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required double totalAssets,
    required double totalLiabilities,
    required double netWorth,
    required DateTime createdAt,
  })  : totalAssets = Value(totalAssets),
        totalLiabilities = Value(totalLiabilities),
        netWorth = Value(netWorth),
        createdAt = Value(createdAt);
  static Insertable<Snapshot> custom({
    Expression<int>? id,
    Expression<double>? totalAssets,
    Expression<double>? totalLiabilities,
    Expression<double>? netWorth,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalAssets != null) 'total_assets': totalAssets,
      if (totalLiabilities != null) 'total_liabilities': totalLiabilities,
      if (netWorth != null) 'net_worth': netWorth,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnapshotsCompanion copyWith(
      {Value<int>? id,
      Value<double>? totalAssets,
      Value<double>? totalLiabilities,
      Value<double>? netWorth,
      Value<DateTime>? createdAt}) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      totalAssets: totalAssets ?? this.totalAssets,
      totalLiabilities: totalLiabilities ?? this.totalLiabilities,
      netWorth: netWorth ?? this.netWorth,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalAssets.present) {
      map['total_assets'] = Variable<double>(totalAssets.value);
    }
    if (totalLiabilities.present) {
      map['total_liabilities'] = Variable<double>(totalLiabilities.value);
    }
    if (netWorth.present) {
      map['net_worth'] = Variable<double>(netWorth.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('totalAssets: $totalAssets, ')
          ..write('totalLiabilities: $totalLiabilities, ')
          ..write('netWorth: $netWorth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AssetTypesTable assetTypes = $AssetTypesTable(this);
  late final $LiabilityTypesTable liabilityTypes = $LiabilityTypesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $LiabilitiesTable liabilities = $LiabilitiesTable(this);
  late final $AssetHoldingsTable assetHoldings = $AssetHoldingsTable(this);
  late final $AssetChangesTable assetChanges = $AssetChangesTable(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        assetTypes,
        liabilityTypes,
        assets,
        liabilities,
        assetHoldings,
        assetChanges,
        persons,
        expenses,
        snapshots
      ];
}

typedef $$AssetTypesTableCreateCompanionBuilder = AssetTypesCompanion Function({
  Value<int> id,
  required String code,
  required String label,
  Value<bool> enabled,
  Value<int> order,
});
typedef $$AssetTypesTableUpdateCompanionBuilder = AssetTypesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> label,
  Value<bool> enabled,
  Value<int> order,
});

final class $$AssetTypesTableReferences
    extends BaseReferences<_$AppDatabase, $AssetTypesTable, AssetType> {
  $$AssetTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.assets,
          aliasName: $_aliasNameGenerator(db.assetTypes.id, db.assets.typeId));

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.typeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetTypesTableFilterComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  Expression<bool> assetsRefs(
      Expression<bool> Function($$AssetsTableFilterComposer f) f) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));
}

class $$AssetTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetTypesTable> {
  $$AssetTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  Expression<T> assetsRefs<T extends Object>(
      Expression<T> Function($$AssetsTableAnnotationComposer a) f) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetTypesTable,
    AssetType,
    $$AssetTypesTableFilterComposer,
    $$AssetTypesTableOrderingComposer,
    $$AssetTypesTableAnnotationComposer,
    $$AssetTypesTableCreateCompanionBuilder,
    $$AssetTypesTableUpdateCompanionBuilder,
    (AssetType, $$AssetTypesTableReferences),
    AssetType,
    PrefetchHooks Function({bool assetsRefs})> {
  $$AssetTypesTableTableManager(_$AppDatabase db, $AssetTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> order = const Value.absent(),
          }) =>
              AssetTypesCompanion(
            id: id,
            code: code,
            label: label,
            enabled: enabled,
            order: order,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String label,
            Value<bool> enabled = const Value.absent(),
            Value<int> order = const Value.absent(),
          }) =>
              AssetTypesCompanion.insert(
            id: id,
            code: code,
            label: label,
            enabled: enabled,
            order: order,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AssetTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assetsRefs) db.assets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetsRefs)
                    await $_getPrefetchedData<AssetType, $AssetTypesTable,
                            Asset>(
                        currentTable: table,
                        referencedTable:
                            $$AssetTypesTableReferences._assetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetTypesTableReferences(db, table, p0)
                                .assetsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.typeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssetTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetTypesTable,
    AssetType,
    $$AssetTypesTableFilterComposer,
    $$AssetTypesTableOrderingComposer,
    $$AssetTypesTableAnnotationComposer,
    $$AssetTypesTableCreateCompanionBuilder,
    $$AssetTypesTableUpdateCompanionBuilder,
    (AssetType, $$AssetTypesTableReferences),
    AssetType,
    PrefetchHooks Function({bool assetsRefs})>;
typedef $$LiabilityTypesTableCreateCompanionBuilder = LiabilityTypesCompanion
    Function({
  Value<int> id,
  required String code,
  required String label,
  Value<bool> enabled,
  Value<int> order,
});
typedef $$LiabilityTypesTableUpdateCompanionBuilder = LiabilityTypesCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> label,
  Value<bool> enabled,
  Value<int> order,
});

final class $$LiabilityTypesTableReferences
    extends BaseReferences<_$AppDatabase, $LiabilityTypesTable, LiabilityType> {
  $$LiabilityTypesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LiabilitiesTable, List<Liability>>
      _liabilitiesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.liabilities,
              aliasName: $_aliasNameGenerator(
                  db.liabilityTypes.id, db.liabilities.typeId));

  $$LiabilitiesTableProcessedTableManager get liabilitiesRefs {
    final manager = $$LiabilitiesTableTableManager($_db, $_db.liabilities)
        .filter((f) => f.typeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_liabilitiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LiabilityTypesTableFilterComposer
    extends Composer<_$AppDatabase, $LiabilityTypesTable> {
  $$LiabilityTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  Expression<bool> liabilitiesRefs(
      Expression<bool> Function($$LiabilitiesTableFilterComposer f) f) {
    final $$LiabilitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableFilterComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LiabilityTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $LiabilityTypesTable> {
  $$LiabilityTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));
}

class $$LiabilityTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiabilityTypesTable> {
  $$LiabilityTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  Expression<T> liabilitiesRefs<T extends Object>(
      Expression<T> Function($$LiabilitiesTableAnnotationComposer a) f) {
    final $$LiabilitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LiabilityTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LiabilityTypesTable,
    LiabilityType,
    $$LiabilityTypesTableFilterComposer,
    $$LiabilityTypesTableOrderingComposer,
    $$LiabilityTypesTableAnnotationComposer,
    $$LiabilityTypesTableCreateCompanionBuilder,
    $$LiabilityTypesTableUpdateCompanionBuilder,
    (LiabilityType, $$LiabilityTypesTableReferences),
    LiabilityType,
    PrefetchHooks Function({bool liabilitiesRefs})> {
  $$LiabilityTypesTableTableManager(
      _$AppDatabase db, $LiabilityTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiabilityTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiabilityTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiabilityTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> order = const Value.absent(),
          }) =>
              LiabilityTypesCompanion(
            id: id,
            code: code,
            label: label,
            enabled: enabled,
            order: order,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String label,
            Value<bool> enabled = const Value.absent(),
            Value<int> order = const Value.absent(),
          }) =>
              LiabilityTypesCompanion.insert(
            id: id,
            code: code,
            label: label,
            enabled: enabled,
            order: order,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LiabilityTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({liabilitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (liabilitiesRefs) db.liabilities],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (liabilitiesRefs)
                    await $_getPrefetchedData<LiabilityType,
                            $LiabilityTypesTable, Liability>(
                        currentTable: table,
                        referencedTable: $$LiabilityTypesTableReferences
                            ._liabilitiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LiabilityTypesTableReferences(db, table, p0)
                                .liabilitiesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.typeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LiabilityTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LiabilityTypesTable,
    LiabilityType,
    $$LiabilityTypesTableFilterComposer,
    $$LiabilityTypesTableOrderingComposer,
    $$LiabilityTypesTableAnnotationComposer,
    $$LiabilityTypesTableCreateCompanionBuilder,
    $$LiabilityTypesTableUpdateCompanionBuilder,
    (LiabilityType, $$LiabilityTypesTableReferences),
    LiabilityType,
    PrefetchHooks Function({bool liabilitiesRefs})>;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  required String name,
  required int typeId,
  required double amount,
  Value<String> currency,
  required DateTime valuationDate,
  Value<double?> annualRate,
  Value<DateTime?> startDate,
  Value<String?> notes,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> typeId,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime> valuationDate,
  Value<double?> annualRate,
  Value<DateTime?> startDate,
  Value<String?> notes,
});

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, Asset> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetTypesTable _typeIdTable(_$AppDatabase db) => db.assetTypes
      .createAlias($_aliasNameGenerator(db.assets.typeId, db.assetTypes.id));

  $$AssetTypesTableProcessedTableManager get typeId {
    final $_column = $_itemColumn<int>('type_id')!;

    final manager = $$AssetTypesTableTableManager($_db, $_db.assetTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AssetHoldingsTable, List<AssetHolding>>
      _assetHoldingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.assetHoldings,
              aliasName:
                  $_aliasNameGenerator(db.assets.id, db.assetHoldings.assetId));

  $$AssetHoldingsTableProcessedTableManager get assetHoldingsRefs {
    final manager = $$AssetHoldingsTableTableManager($_db, $_db.assetHoldings)
        .filter((f) => f.assetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetHoldingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AssetChangesTable, List<AssetChange>>
      _assetChangesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.assetChanges,
              aliasName:
                  $_aliasNameGenerator(db.assets.id, db.assetChanges.assetId));

  $$AssetChangesTableProcessedTableManager get assetChangesRefs {
    final manager = $$AssetChangesTableTableManager($_db, $_db.assetChanges)
        .filter((f) => f.assetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assetChangesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get valuationDate => $composableBuilder(
      column: $table.valuationDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get annualRate => $composableBuilder(
      column: $table.annualRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$AssetTypesTableFilterComposer get typeId {
    final $$AssetTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.assetTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetTypesTableFilterComposer(
              $db: $db,
              $table: $db.assetTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> assetHoldingsRefs(
      Expression<bool> Function($$AssetHoldingsTableFilterComposer f) f) {
    final $$AssetHoldingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assetHoldings,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetHoldingsTableFilterComposer(
              $db: $db,
              $table: $db.assetHoldings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> assetChangesRefs(
      Expression<bool> Function($$AssetChangesTableFilterComposer f) f) {
    final $$AssetChangesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assetChanges,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetChangesTableFilterComposer(
              $db: $db,
              $table: $db.assetChanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get valuationDate => $composableBuilder(
      column: $table.valuationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get annualRate => $composableBuilder(
      column: $table.annualRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$AssetTypesTableOrderingComposer get typeId {
    final $$AssetTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.assetTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetTypesTableOrderingComposer(
              $db: $db,
              $table: $db.assetTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get valuationDate => $composableBuilder(
      column: $table.valuationDate, builder: (column) => column);

  GeneratedColumn<double> get annualRate => $composableBuilder(
      column: $table.annualRate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$AssetTypesTableAnnotationComposer get typeId {
    final $$AssetTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.assetTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.assetTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> assetHoldingsRefs<T extends Object>(
      Expression<T> Function($$AssetHoldingsTableAnnotationComposer a) f) {
    final $$AssetHoldingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assetHoldings,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetHoldingsTableAnnotationComposer(
              $db: $db,
              $table: $db.assetHoldings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> assetChangesRefs<T extends Object>(
      Expression<T> Function($$AssetChangesTableAnnotationComposer a) f) {
    final $$AssetChangesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.assetChanges,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetChangesTableAnnotationComposer(
              $db: $db,
              $table: $db.assetChanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function(
        {bool typeId, bool assetHoldingsRefs, bool assetChangesRefs})> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> typeId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> valuationDate = const Value.absent(),
            Value<double?> annualRate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            name: name,
            typeId: typeId,
            amount: amount,
            currency: currency,
            valuationDate: valuationDate,
            annualRate: annualRate,
            startDate: startDate,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int typeId,
            required double amount,
            Value<String> currency = const Value.absent(),
            required DateTime valuationDate,
            Value<double?> annualRate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            name: name,
            typeId: typeId,
            amount: amount,
            currency: currency,
            valuationDate: valuationDate,
            annualRate: annualRate,
            startDate: startDate,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AssetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {typeId = false,
              assetHoldingsRefs = false,
              assetChangesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (assetHoldingsRefs) db.assetHoldings,
                if (assetChangesRefs) db.assetChanges
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (typeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.typeId,
                    referencedTable: $$AssetsTableReferences._typeIdTable(db),
                    referencedColumn:
                        $$AssetsTableReferences._typeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assetHoldingsRefs)
                    await $_getPrefetchedData<Asset, $AssetsTable,
                            AssetHolding>(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._assetHoldingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .assetHoldingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (assetChangesRefs)
                    await $_getPrefetchedData<Asset, $AssetsTable, AssetChange>(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._assetChangesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .assetChangesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function(
        {bool typeId, bool assetHoldingsRefs, bool assetChangesRefs})>;
typedef $$LiabilitiesTableCreateCompanionBuilder = LiabilitiesCompanion
    Function({
  Value<int> id,
  required String name,
  required int typeId,
  required double amount,
  Value<double?> interestRate,
  Value<DateTime?> dueDate,
  Value<String> currency,
  Value<String?> notes,
});
typedef $$LiabilitiesTableUpdateCompanionBuilder = LiabilitiesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> typeId,
  Value<double> amount,
  Value<double?> interestRate,
  Value<DateTime?> dueDate,
  Value<String> currency,
  Value<String?> notes,
});

final class $$LiabilitiesTableReferences
    extends BaseReferences<_$AppDatabase, $LiabilitiesTable, Liability> {
  $$LiabilitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LiabilityTypesTable _typeIdTable(_$AppDatabase db) =>
      db.liabilityTypes.createAlias(
          $_aliasNameGenerator(db.liabilities.typeId, db.liabilityTypes.id));

  $$LiabilityTypesTableProcessedTableManager get typeId {
    final $_column = $_itemColumn<int>('type_id')!;

    final manager = $$LiabilityTypesTableTableManager($_db, $_db.liabilityTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LiabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$LiabilityTypesTableFilterComposer get typeId {
    final $$LiabilityTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.liabilityTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilityTypesTableFilterComposer(
              $db: $db,
              $table: $db.liabilityTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$LiabilityTypesTableOrderingComposer get typeId {
    final $$LiabilityTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.liabilityTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilityTypesTableOrderingComposer(
              $db: $db,
              $table: $db.liabilityTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$LiabilityTypesTableAnnotationComposer get typeId {
    final $$LiabilityTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.liabilityTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilityTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.liabilityTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LiabilitiesTable,
    Liability,
    $$LiabilitiesTableFilterComposer,
    $$LiabilitiesTableOrderingComposer,
    $$LiabilitiesTableAnnotationComposer,
    $$LiabilitiesTableCreateCompanionBuilder,
    $$LiabilitiesTableUpdateCompanionBuilder,
    (Liability, $$LiabilitiesTableReferences),
    Liability,
    PrefetchHooks Function({bool typeId})> {
  $$LiabilitiesTableTableManager(_$AppDatabase db, $LiabilitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiabilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiabilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> typeId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double?> interestRate = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              LiabilitiesCompanion(
            id: id,
            name: name,
            typeId: typeId,
            amount: amount,
            interestRate: interestRate,
            dueDate: dueDate,
            currency: currency,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int typeId,
            required double amount,
            Value<double?> interestRate = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              LiabilitiesCompanion.insert(
            id: id,
            name: name,
            typeId: typeId,
            amount: amount,
            interestRate: interestRate,
            dueDate: dueDate,
            currency: currency,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LiabilitiesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({typeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (typeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.typeId,
                    referencedTable:
                        $$LiabilitiesTableReferences._typeIdTable(db),
                    referencedColumn:
                        $$LiabilitiesTableReferences._typeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LiabilitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LiabilitiesTable,
    Liability,
    $$LiabilitiesTableFilterComposer,
    $$LiabilitiesTableOrderingComposer,
    $$LiabilitiesTableAnnotationComposer,
    $$LiabilitiesTableCreateCompanionBuilder,
    $$LiabilitiesTableUpdateCompanionBuilder,
    (Liability, $$LiabilitiesTableReferences),
    Liability,
    PrefetchHooks Function({bool typeId})>;
typedef $$AssetHoldingsTableCreateCompanionBuilder = AssetHoldingsCompanion
    Function({
  Value<int> id,
  required int assetId,
  required String name,
  required double price,
  required double quantity,
  Value<String?> notes,
});
typedef $$AssetHoldingsTableUpdateCompanionBuilder = AssetHoldingsCompanion
    Function({
  Value<int> id,
  Value<int> assetId,
  Value<String> name,
  Value<double> price,
  Value<double> quantity,
  Value<String?> notes,
});

final class $$AssetHoldingsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetHoldingsTable, AssetHolding> {
  $$AssetHoldingsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets.createAlias(
      $_aliasNameGenerator(db.assetHoldings.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<int>('asset_id')!;

    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AssetHoldingsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetHoldingsTable> {
  $$AssetHoldingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetHoldingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetHoldingsTable> {
  $$AssetHoldingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetHoldingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetHoldingsTable> {
  $$AssetHoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetHoldingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetHoldingsTable,
    AssetHolding,
    $$AssetHoldingsTableFilterComposer,
    $$AssetHoldingsTableOrderingComposer,
    $$AssetHoldingsTableAnnotationComposer,
    $$AssetHoldingsTableCreateCompanionBuilder,
    $$AssetHoldingsTableUpdateCompanionBuilder,
    (AssetHolding, $$AssetHoldingsTableReferences),
    AssetHolding,
    PrefetchHooks Function({bool assetId})> {
  $$AssetHoldingsTableTableManager(_$AppDatabase db, $AssetHoldingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetHoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetHoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetHoldingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> assetId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetHoldingsCompanion(
            id: id,
            assetId: assetId,
            name: name,
            price: price,
            quantity: quantity,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int assetId,
            required String name,
            required double price,
            required double quantity,
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetHoldingsCompanion.insert(
            id: id,
            assetId: assetId,
            name: name,
            price: price,
            quantity: quantity,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AssetHoldingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$AssetHoldingsTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$AssetHoldingsTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AssetHoldingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetHoldingsTable,
    AssetHolding,
    $$AssetHoldingsTableFilterComposer,
    $$AssetHoldingsTableOrderingComposer,
    $$AssetHoldingsTableAnnotationComposer,
    $$AssetHoldingsTableCreateCompanionBuilder,
    $$AssetHoldingsTableUpdateCompanionBuilder,
    (AssetHolding, $$AssetHoldingsTableReferences),
    AssetHolding,
    PrefetchHooks Function({bool assetId})>;
typedef $$AssetChangesTableCreateCompanionBuilder = AssetChangesCompanion
    Function({
  Value<int> id,
  required int assetId,
  required double beforeAmount,
  required double afterAmount,
  required double difference,
  required DateTime createdAt,
  Value<String?> notes,
});
typedef $$AssetChangesTableUpdateCompanionBuilder = AssetChangesCompanion
    Function({
  Value<int> id,
  Value<int> assetId,
  Value<double> beforeAmount,
  Value<double> afterAmount,
  Value<double> difference,
  Value<DateTime> createdAt,
  Value<String?> notes,
});

final class $$AssetChangesTableReferences
    extends BaseReferences<_$AppDatabase, $AssetChangesTable, AssetChange> {
  $$AssetChangesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets
      .createAlias($_aliasNameGenerator(db.assetChanges.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager get assetId {
    final $_column = $_itemColumn<int>('asset_id')!;

    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AssetChangesTableFilterComposer
    extends Composer<_$AppDatabase, $AssetChangesTable> {
  $$AssetChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get beforeAmount => $composableBuilder(
      column: $table.beforeAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get afterAmount => $composableBuilder(
      column: $table.afterAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difference => $composableBuilder(
      column: $table.difference, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetChangesTable> {
  $$AssetChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get beforeAmount => $composableBuilder(
      column: $table.beforeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get afterAmount => $composableBuilder(
      column: $table.afterAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difference => $composableBuilder(
      column: $table.difference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetChangesTable> {
  $$AssetChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get beforeAmount => $composableBuilder(
      column: $table.beforeAmount, builder: (column) => column);

  GeneratedColumn<double> get afterAmount => $composableBuilder(
      column: $table.afterAmount, builder: (column) => column);

  GeneratedColumn<double> get difference => $composableBuilder(
      column: $table.difference, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetChangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetChangesTable,
    AssetChange,
    $$AssetChangesTableFilterComposer,
    $$AssetChangesTableOrderingComposer,
    $$AssetChangesTableAnnotationComposer,
    $$AssetChangesTableCreateCompanionBuilder,
    $$AssetChangesTableUpdateCompanionBuilder,
    (AssetChange, $$AssetChangesTableReferences),
    AssetChange,
    PrefetchHooks Function({bool assetId})> {
  $$AssetChangesTableTableManager(_$AppDatabase db, $AssetChangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> assetId = const Value.absent(),
            Value<double> beforeAmount = const Value.absent(),
            Value<double> afterAmount = const Value.absent(),
            Value<double> difference = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetChangesCompanion(
            id: id,
            assetId: assetId,
            beforeAmount: beforeAmount,
            afterAmount: afterAmount,
            difference: difference,
            createdAt: createdAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int assetId,
            required double beforeAmount,
            required double afterAmount,
            required double difference,
            required DateTime createdAt,
            Value<String?> notes = const Value.absent(),
          }) =>
              AssetChangesCompanion.insert(
            id: id,
            assetId: assetId,
            beforeAmount: beforeAmount,
            afterAmount: afterAmount,
            difference: difference,
            createdAt: createdAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AssetChangesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$AssetChangesTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$AssetChangesTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AssetChangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetChangesTable,
    AssetChange,
    $$AssetChangesTableFilterComposer,
    $$AssetChangesTableOrderingComposer,
    $$AssetChangesTableAnnotationComposer,
    $$AssetChangesTableCreateCompanionBuilder,
    $$AssetChangesTableUpdateCompanionBuilder,
    (AssetChange, $$AssetChangesTableReferences),
    AssetChange,
    PrefetchHooks Function({bool assetId})>;
typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> enabled,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, Person> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: $_aliasNameGenerator(db.persons.id, db.expenses.personId));

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, $$PersonsTableReferences),
    Person,
    PrefetchHooks Function({bool expensesRefs})> {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PersonsCompanion(
            id: id,
            name: name,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<bool> enabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              PersonsCompanion.insert(
            id: id,
            name: name,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PersonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<Person, $PersonsTable, Expense>(
                        currentTable: table,
                        referencedTable:
                            $$PersonsTableReferences._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonsTableReferences(db, table, p0)
                                .expensesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PersonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, $$PersonsTableReferences),
    Person,
    PrefetchHooks Function({bool expensesRefs})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String name,
  required double amount,
  required String cycle,
  required int personId,
  required DateTime date,
  Value<String?> notes,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> amount,
  Value<String> cycle,
  Value<int> personId,
  Value<DateTime> date,
  Value<String?> notes,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) => db.persons
      .createAlias($_aliasNameGenerator(db.expenses.personId, db.persons.id));

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PersonsTableTableManager($_db, $_db.persons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cycle => $composableBuilder(
      column: $table.cycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableFilterComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cycle => $composableBuilder(
      column: $table.cycle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableOrderingComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableAnnotationComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool personId})> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> cycle = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            name: name,
            amount: amount,
            cycle: cycle,
            personId: personId,
            date: date,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double amount,
            required String cycle,
            required int personId,
            required DateTime date,
            Value<String?> notes = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            cycle: cycle,
            personId: personId,
            date: date,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpensesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable:
                        $$ExpensesTableReferences._personIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._personIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool personId})>;
typedef $$SnapshotsTableCreateCompanionBuilder = SnapshotsCompanion Function({
  Value<int> id,
  required double totalAssets,
  required double totalLiabilities,
  required double netWorth,
  required DateTime createdAt,
});
typedef $$SnapshotsTableUpdateCompanionBuilder = SnapshotsCompanion Function({
  Value<int> id,
  Value<double> totalAssets,
  Value<double> totalLiabilities,
  Value<double> netWorth,
  Value<DateTime> createdAt,
});

class $$SnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAssets => $composableBuilder(
      column: $table.totalAssets, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalLiabilities => $composableBuilder(
      column: $table.totalLiabilities,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netWorth => $composableBuilder(
      column: $table.netWorth, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAssets => $composableBuilder(
      column: $table.totalAssets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalLiabilities => $composableBuilder(
      column: $table.totalLiabilities,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netWorth => $composableBuilder(
      column: $table.netWorth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalAssets => $composableBuilder(
      column: $table.totalAssets, builder: (column) => column);

  GeneratedColumn<double> get totalLiabilities => $composableBuilder(
      column: $table.totalLiabilities, builder: (column) => column);

  GeneratedColumn<double> get netWorth =>
      $composableBuilder(column: $table.netWorth, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnapshotsTable,
    Snapshot,
    $$SnapshotsTableFilterComposer,
    $$SnapshotsTableOrderingComposer,
    $$SnapshotsTableAnnotationComposer,
    $$SnapshotsTableCreateCompanionBuilder,
    $$SnapshotsTableUpdateCompanionBuilder,
    (Snapshot, BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot>),
    Snapshot,
    PrefetchHooks Function()> {
  $$SnapshotsTableTableManager(_$AppDatabase db, $SnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> totalAssets = const Value.absent(),
            Value<double> totalLiabilities = const Value.absent(),
            Value<double> netWorth = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnapshotsCompanion(
            id: id,
            totalAssets: totalAssets,
            totalLiabilities: totalLiabilities,
            netWorth: netWorth,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double totalAssets,
            required double totalLiabilities,
            required double netWorth,
            required DateTime createdAt,
          }) =>
              SnapshotsCompanion.insert(
            id: id,
            totalAssets: totalAssets,
            totalLiabilities: totalLiabilities,
            netWorth: netWorth,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnapshotsTable,
    Snapshot,
    $$SnapshotsTableFilterComposer,
    $$SnapshotsTableOrderingComposer,
    $$SnapshotsTableAnnotationComposer,
    $$SnapshotsTableCreateCompanionBuilder,
    $$SnapshotsTableUpdateCompanionBuilder,
    (Snapshot, BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot>),
    Snapshot,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AssetTypesTableTableManager get assetTypes =>
      $$AssetTypesTableTableManager(_db, _db.assetTypes);
  $$LiabilityTypesTableTableManager get liabilityTypes =>
      $$LiabilityTypesTableTableManager(_db, _db.liabilityTypes);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$LiabilitiesTableTableManager get liabilities =>
      $$LiabilitiesTableTableManager(_db, _db.liabilities);
  $$AssetHoldingsTableTableManager get assetHoldings =>
      $$AssetHoldingsTableTableManager(_db, _db.assetHoldings);
  $$AssetChangesTableTableManager get assetChanges =>
      $$AssetChangesTableTableManager(_db, _db.assetChanges);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
}
