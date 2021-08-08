import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/// The name of the database table is "tasks"
/// By default, the name of the generated data class will be "Task" (without "s")
class Tasks extends Table {
  /// Autoincrement automatically sets this to be the primary key
  IntColumn? get id => integer().autoIncrement()();

  TextColumn get tagName => text().nullable().customConstraint('NULL REFERENCES tags(name)')();

  /// If the length constraint is not fulfilled, the Task will not
  /// be inserted into the database and an exception will be thrown.
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// DateTime is not natively supported by SQLite
  /// Moor converts it to & from UNIX seconds
  DateTimeColumn get dueDate => dateTime().nullable()();

  /// Booleans are not supported as well, Moor converts them to integers
  /// Simple default values are specified as Constants
  BoolColumn? get completed => boolean().withDefault(Constant(false))();
}

class Tags extends Table {
  TextColumn get name => text().withLength(min: 1, max: 10)();
  IntColumn get color => integer()();

  @override
  Set<Column>? get primaryKey => {name};
}

// We have to group tasks with tags manually.
// This class will be used for the table join.
class TaskWithTag {
  final Task task;
  final Tag? tag;

  TaskWithTag({required this.task, this.tag});
}

@UseMoor(tables: [Tasks, Tags], daos: [TaskDao, TagDao])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  // Specify the location of the database file
  AppDatabase() : super((FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true)));

  /// Bump this when changing tables and columns.
  /// Migrations will be covered in the next part.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      beforeOpen: (details) async {},
      // Runs if the database has already been opened on the device with a lower version
      onUpgrade: (migrator, from, to) async {
        if (from == 3) {
          await migrator.addColumn(tasks, tasks.tagName);
          await migrator.createTable(tags);
        }
      });
}

@UseDao(tables: [Tasks, Tags])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase appDb;

  TaskDao(this.appDb) : super(appDb);

  Future<List<Task>> getAllTasks() => select(tasks).get();

  // Updated to use the orderBy statement
  Stream<List<TaskWithTag>> watchAllTasks() {
    // Wrap the whole select statement with parenthesis
    return (select(tasks)
          // Statements like orderBy and where return void => the need to use a cascading ".." operator
          ..orderBy(([
            // Primary sorting by due date
            (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
            // Secondary sorting by alphabet
            (t) => OrderingTerm(expression: t.name),
          ])))
        // As opposed to orderBy or where, join returns a value. This is what we want to watch/get.
        .join([
          // Join all the tasks with their tags.
          // It's important that we use equalsExp and not just equals.
          // This way, we can join using all tag names in the tasks table, not just a specific one.
          leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
        ])
        .watch()
        .map((rows) => rows
            .map((row) => TaskWithTag(task: row.readTable(tasks), tag: row.rawData.data['tags.name'] != null ? row.readTable(tags) : null))
            .toList());
  }

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);

  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);

  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}

@UseDao(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  final AppDatabase appDb;

  TagDao(this.appDb) : super(appDb);

  Stream<List<Tag>> watchTags() => select(tags).watch();

  Future insertTag(Insertable<Tag> tag) => into(tags).insert(tag);
}
