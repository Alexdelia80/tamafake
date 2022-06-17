// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userInstance;

  AvatarDao? _avatarInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` TEXT, `data` TEXT, `steps` REAL, `calories` REAL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AvatarTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` TEXT, `exp` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get user {
    return _userInstance ??= _$UserDao(database, changeListener);
  }

  @override
  AvatarDao get avatar {
    return _avatarInstance ??= _$AvatarDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userTableInsertionAdapter = InsertionAdapter(
            database,
            'UserTable',
            (UserTable item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'data': item.data,
                  'steps': item.steps,
                  'calories': item.calories
                }),
        _userTableDeletionAdapter = DeletionAdapter(
            database,
            'UserTable',
            ['id'],
            (UserTable item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'data': item.data,
                  'steps': item.steps,
                  'calories': item.calories
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserTable> _userTableInsertionAdapter;

  final DeletionAdapter<UserTable> _userTableDeletionAdapter;

  @override
  Future<List<UserTable>> findUser() async {
    return _queryAdapter.queryList('SELECT * FROM UserTable',
        mapper: (Map<String, Object?> row) => UserTable(
            row['id'] as int?,
            row['userId'] as String?,
            row['data'] as String?,
            row['steps'] as double?,
            row['calories'] as double?));
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserTable');
  }

  @override
  Future<UserTable?> findData(String data) async {
    return _queryAdapter.query('SELECT * FROM UserTable WHERE data = ?1',
        mapper: (Map<String, Object?> row) => UserTable(
            row['id'] as int?,
            row['userId'] as String?,
            row['data'] as String?,
            row['steps'] as double?,
            row['calories'] as double?),
        arguments: [data]);
  }

  @override
  Future<void> insertUser(UserTable user) async {
    await _userTableInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserTable user) async {
    await _userTableDeletionAdapter.delete(user);
  }
}

class _$AvatarDao extends AvatarDao {
  _$AvatarDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _avatarTableInsertionAdapter = InsertionAdapter(
            database,
            'AvatarTable',
            (AvatarTable item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'exp': item.exp
                }),
        _avatarTableDeletionAdapter = DeletionAdapter(
            database,
            'AvatarTable',
            ['id'],
            (AvatarTable item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'exp': item.exp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AvatarTable> _avatarTableInsertionAdapter;

  final DeletionAdapter<AvatarTable> _avatarTableDeletionAdapter;

  @override
  Future<List<AvatarTable>> findAvatar() async {
    return _queryAdapter.queryList('SELECT * FROM AvatarTable',
        mapper: (Map<String, Object?> row) => AvatarTable(
            row['id'] as int?, row['userId'] as String?, row['exp'] as int?));
  }

  @override
  Future<void> insertAvatar(AvatarTable avatar) async {
    await _avatarTableInsertionAdapter.insert(avatar, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAvatar(AvatarTable avatar) async {
    await _avatarTableDeletionAdapter.delete(avatar);
  }
}
