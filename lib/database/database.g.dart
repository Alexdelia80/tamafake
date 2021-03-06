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
            'CREATE TABLE IF NOT EXISTS `UserTable` (`data` INTEGER NOT NULL, `userId` TEXT, `steps` REAL, `calCardio` REAL, `calFatBurn` REAL, `calPeak` REAL, PRIMARY KEY (`data`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AvatarTable` (`exp` INTEGER NOT NULL, `userId` TEXT, `level` INTEGER, PRIMARY KEY (`exp`))');

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
                  'data': item.data,
                  'userId': item.userId,
                  'steps': item.steps,
                  'calCardio': item.calCardio,
                  'calFatBurn': item.calFatBurn,
                  'calPeak': item.calPeak
                }),
        _userTableDeletionAdapter = DeletionAdapter(
            database,
            'UserTable',
            ['data'],
            (UserTable item) => <String, Object?>{
                  'data': item.data,
                  'userId': item.userId,
                  'steps': item.steps,
                  'calCardio': item.calCardio,
                  'calFatBurn': item.calFatBurn,
                  'calPeak': item.calPeak
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
            row['data'] as int,
            row['userId'] as String?,
            row['steps'] as double?,
            row['calCardio'] as double?,
            row['calFatBurn'] as double?,
            row['calPeak'] as double?));
  }

  @override
  Future<void> deleteAllUser() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserTable');
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
                  'exp': item.exp,
                  'userId': item.userId,
                  'level': item.level
                }),
        _avatarTableDeletionAdapter = DeletionAdapter(
            database,
            'AvatarTable',
            ['exp'],
            (AvatarTable item) => <String, Object?>{
                  'exp': item.exp,
                  'userId': item.userId,
                  'level': item.level
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
            row['exp'] as int, row['userId'] as String?, row['level'] as int?));
  }

  @override
  Future<void> deleteAllAvatar() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AvatarTable');
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