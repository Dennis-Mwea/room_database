// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Task extends DataClass implements Insertable<Task> {
  /// Autoincrement automatically sets this to be the primary key
  final int id;

  /// If the length constraint is not fulfilled, the Task will not
  /// be inserted into the database and an exception will be thrown.
  final String name;

  /// DateTime is not natively supported by SQLite
  /// Moor converts it to & from UNIX seconds
  final DateTime? dueDate;

  /// Booleans are not supported as well, Moor converts them to integers
  /// Simple default values are specified as Constants
  final bool completed;
  Task(
      {required this.id,
      required this.name,
      this.dueDate,
      required this.completed});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Task(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      dueDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
      completed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}completed'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime?>(dueDate);
    }
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      name: Value(name),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      completed: Value(completed),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  Task copyWith({int? id, String? name, DateTime? dueDate, bool? completed}) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        dueDate: dueDate ?? this.dueDate,
        completed: completed ?? this.completed,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(dueDate.hashCode, completed.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.name == this.name &&
          other.dueDate == this.dueDate &&
          other.completed == this.completed);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> dueDate;
  final Value<bool> completed;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completed = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dueDate = const Value.absent(),
    this.completed = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime?>? dueDate,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dueDate != null) 'due_date': dueDate,
      if (completed != null) 'completed': completed,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime?>? dueDate,
      Value<bool>? completed}) {
    return TasksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
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
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime?>(dueDate.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dueDate: $dueDate, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  late final GeneratedColumn<DateTime?> dueDate = GeneratedColumn<DateTime?>(
      'due_date', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  late final GeneratedColumn<bool?> completed = GeneratedColumn<bool?>(
      'completed', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (completed IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, dueDate, completed];
  @override
  String get aliasedName => _alias ?? 'tasks';
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
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
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Task.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TasksTable tasks = $TasksTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks];
}
