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

  SourceDao? _sourceDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `source` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `bookSourceUrl` TEXT NOT NULL, `bookSourceName` TEXT NOT NULL, `bookSourceGroup` TEXT, `bookSourceType` INTEGER NOT NULL, `bookUrlPattern` TEXT, `customOrder` INTEGER NOT NULL, `enabled` INTEGER NOT NULL, `enabledExplore` INTEGER NOT NULL, `enabledCookieJar` INTEGER NOT NULL, `concurrentRate` TEXT, `header` TEXT, `loginUrl` TEXT, `loginUi` TEXT, `loginCheckJs` TEXT, `bookSourceComment` TEXT, `lastUpdateTime` INTEGER NOT NULL, `respondTime` INTEGER NOT NULL, `weight` INTEGER NOT NULL, `exploreUrl` TEXT, `ruleExplore` TEXT, `searchUrl` TEXT, `ruleSearch` TEXT, `ruleBookInfo` TEXT, `ruleToc` TEXT, `ruleContent` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SourceDao get sourceDao {
    return _sourceDaoInstance ??= _$SourceDao(database, changeListener);
  }
}

class _$SourceDao extends SourceDao {
  _$SourceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sourceInsertionAdapter = InsertionAdapter(
            database,
            'source',
            (Source item) => <String, Object?>{
                  'id': item.id,
                  'bookSourceUrl': item.bookSourceUrl,
                  'bookSourceName': item.bookSourceName,
                  'bookSourceGroup': item.bookSourceGroup,
                  'bookSourceType': item.bookSourceType,
                  'bookUrlPattern': item.bookUrlPattern,
                  'customOrder': item.customOrder,
                  'enabled': item.enabled ? 1 : 0,
                  'enabledExplore': item.enabledExplore ? 1 : 0,
                  'enabledCookieJar': item.enabledCookieJar ? 1 : 0,
                  'concurrentRate': item.concurrentRate,
                  'header': item.header,
                  'loginUrl': item.loginUrl,
                  'loginUi': item.loginUi,
                  'loginCheckJs': item.loginCheckJs,
                  'bookSourceComment': item.bookSourceComment,
                  'lastUpdateTime': item.lastUpdateTime,
                  'respondTime': item.respondTime,
                  'weight': item.weight,
                  'exploreUrl': item.exploreUrl,
                  'ruleExplore':
                      _exploreRuleTypeConvert.encode(item.ruleExplore),
                  'searchUrl': item.searchUrl,
                  'ruleSearch': _searchRuleTypeConvert.encode(item.ruleSearch),
                  'ruleBookInfo':
                      _bookInfoRuleTypeConvert.encode(item.ruleBookInfo),
                  'ruleToc': _tocRuleTypeConvert.encode(item.ruleToc),
                  'ruleContent':
                      _contentRuleTypeConvert.encode(item.ruleContent)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Source> _sourceInsertionAdapter;

  @override
  Future<List<Source>> findAllSource(String order) async {
    return _queryAdapter.queryList('SELECT * FROM source ORDER BY ?1',
        mapper: (Map<String, Object?> row) => Source(
            row['id'] as int?,
            row['bookSourceName'] as String,
            row['bookSourceComment'] as String?,
            row['bookSourceGroup'] as String?,
            row['bookSourceType'] as int,
            row['bookSourceUrl'] as String,
            row['customOrder'] as int,
            (row['enabled'] as int) != 0,
            (row['enabledExplore'] as int) != 0,
            row['exploreUrl'] as String?,
            row['lastUpdateTime'] as int,
            row['respondTime'] as int,
            _tocRuleTypeConvert.decode(row['ruleToc'] as String),
            _bookInfoRuleTypeConvert.decode(row['ruleBookInfo'] as String),
            _contentRuleTypeConvert.decode(row['ruleContent'] as String),
            _exploreRuleTypeConvert.decode(row['ruleExplore'] as String),
            _searchRuleTypeConvert.decode(row['ruleSearch'] as String),
            row['searchUrl'] as String?,
            row['weight'] as int),
        arguments: [order]);
  }

  @override
  Future<List<Source>> findEnabledSource(String order) async {
    return _queryAdapter.queryList(
        'SELECT * FROM source where enabled = 1 ORDER BY ?1',
        mapper: (Map<String, Object?> row) => Source(
            row['id'] as int?,
            row['bookSourceName'] as String,
            row['bookSourceComment'] as String?,
            row['bookSourceGroup'] as String?,
            row['bookSourceType'] as int,
            row['bookSourceUrl'] as String,
            row['customOrder'] as int,
            (row['enabled'] as int) != 0,
            (row['enabledExplore'] as int) != 0,
            row['exploreUrl'] as String?,
            row['lastUpdateTime'] as int,
            row['respondTime'] as int,
            _tocRuleTypeConvert.decode(row['ruleToc'] as String),
            _bookInfoRuleTypeConvert.decode(row['ruleBookInfo'] as String),
            _contentRuleTypeConvert.decode(row['ruleContent'] as String),
            _exploreRuleTypeConvert.decode(row['ruleExplore'] as String),
            _searchRuleTypeConvert.decode(row['ruleSearch'] as String),
            row['searchUrl'] as String?,
            row['weight'] as int),
        arguments: [order]);
  }

  @override
  Future<List<Source>> findAllSourceByName(String name, String order) async {
    return _queryAdapter.queryList(
        'SELECT * FROM source where bookSourceName like ?1 ORDER BY ?2',
        mapper: (Map<String, Object?> row) => Source(
            row['id'] as int?,
            row['bookSourceName'] as String,
            row['bookSourceComment'] as String?,
            row['bookSourceGroup'] as String?,
            row['bookSourceType'] as int,
            row['bookSourceUrl'] as String,
            row['customOrder'] as int,
            (row['enabled'] as int) != 0,
            (row['enabledExplore'] as int) != 0,
            row['exploreUrl'] as String?,
            row['lastUpdateTime'] as int,
            row['respondTime'] as int,
            _tocRuleTypeConvert.decode(row['ruleToc'] as String),
            _bookInfoRuleTypeConvert.decode(row['ruleBookInfo'] as String),
            _contentRuleTypeConvert.decode(row['ruleContent'] as String),
            _exploreRuleTypeConvert.decode(row['ruleExplore'] as String),
            _searchRuleTypeConvert.decode(row['ruleSearch'] as String),
            row['searchUrl'] as String?,
            row['weight'] as int),
        arguments: [name, order]);
  }

  @override
  Future<int> insertOrUpdateRule(Source source) {
    return _sourceInsertionAdapter.insertAndReturnId(
        source, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertOrUpdateRules(List<Source> sources) {
    return _sourceInsertionAdapter.insertListAndReturnIds(
        sources, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _exploreRuleTypeConvert = ExploreRuleTypeConvert();
final _bookInfoRuleTypeConvert = BookInfoRuleTypeConvert();
final _contentRuleTypeConvert = ContentRuleTypeConvert();
final _searchRuleTypeConvert = SearchRuleTypeConvert();
final _tocRuleTypeConvert = TocRuleTypeConvert();
