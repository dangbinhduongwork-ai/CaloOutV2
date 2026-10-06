// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class ActivityLog extends DataClass implements Insertable<ActivityLog> {
  final String id;
  final String? activityId;
  final String? customName;
  final double met;
  final int durationMinutes;
  final double caloriesBurned;
  final double weightKgSnapshot;
  final DateTime performedAt;

  const ActivityLog({
    required this.id,
    this.activityId,
    this.customName,
    required this.met,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.weightKgSnapshot,
    required this.performedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<String>(activityId);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['met'] = Variable<double>(met);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['calories_burned'] = Variable<double>(caloriesBurned);
    map['weight_kg_snapshot'] = Variable<double>(weightKgSnapshot);
    map['performed_at'] = Variable<DateTime>(performedAt);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      met: Value(met),
      durationMinutes: Value(durationMinutes),
      caloriesBurned: Value(caloriesBurned),
      weightKgSnapshot: Value(weightKgSnapshot),
      performedAt: Value(performedAt),
    );
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLog(
      id: serializer.fromJson<String>(json['id']),
      activityId: serializer.fromJson<String?>(json['activityId']),
      customName: serializer.fromJson<String?>(json['customName']),
      met: serializer.fromJson<double>(json['met']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      caloriesBurned: serializer.fromJson<double>(json['caloriesBurned']),
      weightKgSnapshot: serializer.fromJson<double>(json['weightKgSnapshot']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activityId': serializer.toJson<String?>(activityId),
      'customName': serializer.toJson<String?>(customName),
      'met': serializer.toJson<double>(met),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'caloriesBurned': serializer.toJson<double>(caloriesBurned),
      'weightKgSnapshot': serializer.toJson<double>(weightKgSnapshot),
      'performedAt': serializer.toJson<DateTime>(performedAt),
    };
  }

  ActivityLog copyWith({
    String? id,
    Value<String?> activityId = const Value.absent(),
    Value<String?> customName = const Value.absent(),
    double? met,
    int? durationMinutes,
    double? caloriesBurned,
    double? weightKgSnapshot,
    DateTime? performedAt,
  }) =>
      ActivityLog(
        id: id ?? this.id,
        activityId: activityId.present ? activityId.value : this.activityId,
        customName: customName.present ? customName.value : this.customName,
        met: met ?? this.met,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        caloriesBurned: caloriesBurned ?? this.caloriesBurned,
        weightKgSnapshot: weightKgSnapshot ?? this.weightKgSnapshot,
        performedAt: performedAt ?? this.performedAt,
      );

  @override
  String toString() {
    return (StringBuffer('ActivityLog(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('customName: $customName, ')
          ..write('met: $met, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('weightKgSnapshot: $weightKgSnapshot, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        activityId,
        customName,
        met,
        durationMinutes,
        caloriesBurned,
        weightKgSnapshot,
        performedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLog &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.customName == this.customName &&
          other.met == this.met &&
          other.durationMinutes == this.durationMinutes &&
          other.caloriesBurned == this.caloriesBurned &&
          other.weightKgSnapshot == this.weightKgSnapshot &&
          other.performedAt == this.performedAt);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLog> {
  final Value<String> id;
  final Value<String?> activityId;
  final Value<String?> customName;
  final Value<double> met;
  final Value<int> durationMinutes;
  final Value<double> caloriesBurned;
  final Value<double> weightKgSnapshot;
  final Value<DateTime> performedAt;

  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.customName = const Value.absent(),
    this.met = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.weightKgSnapshot = const Value.absent(),
    this.performedAt = const Value.absent(),
  });

  ActivityLogsCompanion.insert({
    required String id,
    this.activityId = const Value.absent(),
    this.customName = const Value.absent(),
    required double met,
    required int durationMinutes,
    required double caloriesBurned,
    required double weightKgSnapshot,
    required DateTime performedAt,
  })  : id = Value(id),
        met = Value(met),
        durationMinutes = Value(durationMinutes),
        caloriesBurned = Value(caloriesBurned),
        weightKgSnapshot = Value(weightKgSnapshot),
        performedAt = Value(performedAt);

  static Insertable<ActivityLog> custom({
    Expression<String>? id,
    Expression<String>? activityId,
    Expression<String>? customName,
    Expression<double>? met,
    Expression<int>? durationMinutes,
    Expression<double>? caloriesBurned,
    Expression<double>? weightKgSnapshot,
    Expression<DateTime>? performedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (customName != null) 'custom_name': customName,
      if (met != null) 'met': met,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      if (weightKgSnapshot != null) 'weight_kg_snapshot': weightKgSnapshot,
      if (performedAt != null) 'performed_at': performedAt,
    });
  }

  ActivityLogsCompanion copyWith({
    Value<String>? id,
    Value<String?>? activityId,
    Value<String?>? customName,
    Value<double>? met,
    Value<int>? durationMinutes,
    Value<double>? caloriesBurned,
    Value<double>? weightKgSnapshot,
    Value<DateTime>? performedAt,
  }) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      customName: customName ?? this.customName,
      met: met ?? this.met,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      weightKgSnapshot: weightKgSnapshot ?? this.weightKgSnapshot,
      performedAt: performedAt ?? this.performedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (met.present) {
      map['met'] = Variable<double>(met.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<double>(caloriesBurned.value);
    }
    if (weightKgSnapshot.present) {
      map['weight_kg_snapshot'] = Variable<double>(weightKgSnapshot.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    return map;
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _activityIdMeta =
      const VerificationMeta('activityId');
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
      'activity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);

  static const VerificationMeta _customNameMeta =
      const VerificationMeta('customName');
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
      'custom_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);

  static const VerificationMeta _metMeta = const VerificationMeta('met');
  @override
  late final GeneratedColumn<double> met = GeneratedColumn<double>(
      'met', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  static const VerificationMeta _caloriesBurnedMeta =
      const VerificationMeta('caloriesBurned');
  @override
  late final GeneratedColumn<double> caloriesBurned = GeneratedColumn<double>(
      'calories_burned', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  static const VerificationMeta _weightKgSnapshotMeta =
      const VerificationMeta('weightKgSnapshot');
  @override
  late final GeneratedColumn<double> weightKgSnapshot = GeneratedColumn<double>(
      'weight_kg_snapshot', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [
        id,
        activityId,
        customName,
        met,
        durationMinutes,
        caloriesBurned,
        weightKgSnapshot,
        performedAt,
      ];

  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';

  @override
  VerificationContext validateIntegrity(Insertable<ActivityLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
          _activityIdMeta,
          activityId.isAcceptableOrUnknown(
              data['activity_id']!, _activityIdMeta));
    }
    if (data.containsKey('custom_name')) {
      context.handle(
          _customNameMeta,
          customName.isAcceptableOrUnknown(
              data['custom_name']!, _customNameMeta));
    }
    if (data.containsKey('met')) {
      context.handle(
          _metMeta, met.isAcceptableOrUnknown(data['met']!, _metMeta));
    } else if (isInserting) {
      context.missing(_metMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
          _caloriesBurnedMeta,
          caloriesBurned.isAcceptableOrUnknown(
              data['calories_burned']!, _caloriesBurnedMeta));
    } else if (isInserting) {
      context.missing(_caloriesBurnedMeta);
    }
    if (data.containsKey('weight_kg_snapshot')) {
      context.handle(
          _weightKgSnapshotMeta,
          weightKgSnapshot.isAcceptableOrUnknown(
              data['weight_kg_snapshot']!, _weightKgSnapshotMeta));
    } else if (isInserting) {
      context.missing(_weightKgSnapshotMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  ActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      activityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_id']),
      customName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_name']),
      met: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}met'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      caloriesBurned: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}calories_burned'])!,
      weightKgSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}weight_kg_snapshot'])!,
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class CustomActivity extends DataClass implements Insertable<CustomActivity> {
  final String id;
  final String name;
  final double met;
  final DateTime createdAt;

  const CustomActivity({
    required this.id,
    required this.name,
    required this.met,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['met'] = Variable<double>(met);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomActivitiesCompanion toCompanion(bool nullToAbsent) {
    return CustomActivitiesCompanion(
      id: Value(id),
      name: Value(name),
      met: Value(met),
      createdAt: Value(createdAt),
    );
  }

  factory CustomActivity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomActivity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      met: serializer.fromJson<double>(json['met']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'met': serializer.toJson<double>(met),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomActivity copyWith({
    String? id,
    String? name,
    double? met,
    DateTime? createdAt,
  }) =>
      CustomActivity(
        id: id ?? this.id,
        name: name ?? this.name,
        met: met ?? this.met,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() {
    return (StringBuffer('CustomActivity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('met: $met, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, met, createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomActivity &&
          other.id == this.id &&
          other.name == this.name &&
          other.met == this.met &&
          other.createdAt == this.createdAt);
}

class CustomActivitiesCompanion extends UpdateCompanion<CustomActivity> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> met;
  final Value<DateTime> createdAt;

  const CustomActivitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.met = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  CustomActivitiesCompanion.insert({
    required String id,
    required String name,
    required double met,
    required DateTime createdAt,
  })  : id = Value(id),
        name = Value(name),
        met = Value(met),
        createdAt = Value(createdAt);

  static Insertable<CustomActivity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? met,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (met != null) 'met': met,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? met,
    Value<DateTime>? createdAt,
  }) {
    return CustomActivitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      met: met ?? this.met,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (met.present) {
      map['met'] = Variable<double>(met.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }
}

class $CustomActivitiesTable extends CustomActivities
    with TableInfo<$CustomActivitiesTable, CustomActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomActivitiesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _metMeta = const VerificationMeta('met');
  @override
  late final GeneratedColumn<double> met = GeneratedColumn<double>(
      'met', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, name, met, createdAt];

  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_activities';

  @override
  VerificationContext validateIntegrity(Insertable<CustomActivity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('met')) {
      context.handle(
          _metMeta, met.isAcceptableOrUnknown(data['met']!, _metMeta));
    } else if (isInserting) {
      context.missing(_metMeta);
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
  CustomActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomActivity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      met: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}met'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomActivitiesTable createAlias(String alias) {
    return $CustomActivitiesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $CustomActivitiesTable customActivities =
      $CustomActivitiesTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [activityLogs, customActivities];
}
