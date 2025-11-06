// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  PackageDao? _packageDaoInstance;

  WordDao? _wordDaoInstance;

  DefinitionDao? _definitionDaoInstance;

  SentenceDao? _sentenceDaoInstance;

  ResourceDao? _resourceDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `learning_packages` (`packageId` TEXT NOT NULL, `author` TEXT NOT NULL, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `iconUrl` TEXT, `keywords` TEXT NOT NULL, `language` TEXT NOT NULL, `last_updated_date` TEXT NOT NULL, `level` TEXT NOT NULL, `title` TEXT NOT NULL, `version` INTEGER NOT NULL, PRIMARY KEY (`packageId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `words` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL, `packageId` TEXT NOT NULL, FOREIGN KEY (`packageId`) REFERENCES `learning_packages` (`packageId`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `definitions` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL, `source` TEXT NOT NULL, `wordId` INTEGER NOT NULL, FOREIGN KEY (`wordId`) REFERENCES `words` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sentences` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL, `wordId` INTEGER NOT NULL, FOREIGN KEY (`wordId`) REFERENCES `words` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `resources` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `extension` TEXT NOT NULL, `resourceUrl` TEXT NOT NULL, `title` TEXT NOT NULL, `type` TEXT NOT NULL, `sentenceId` INTEGER, `wordId` INTEGER, FOREIGN KEY (`sentenceId`) REFERENCES `sentences` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`wordId`) REFERENCES `words` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PackageDao get packageDao {
    return _packageDaoInstance ??= _$PackageDao(database, changeListener);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }

  @override
  DefinitionDao get definitionDao {
    return _definitionDaoInstance ??= _$DefinitionDao(database, changeListener);
  }

  @override
  SentenceDao get sentenceDao {
    return _sentenceDaoInstance ??= _$SentenceDao(database, changeListener);
  }

  @override
  ResourceDao get resourceDao {
    return _resourceDaoInstance ??= _$ResourceDao(database, changeListener);
  }
}

class _$PackageDao extends PackageDao {
  _$PackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _learningPackageInsertionAdapter = InsertionAdapter(
            database,
            'learning_packages',
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': item.keywords,
                  'language': item.language,
                  'last_updated_date': item.lastUpdatedDate,
                  'level': item.level,
                  'title': item.title,
                  'version': item.version
                },
            changeListener),
        _learningPackageUpdateAdapter = UpdateAdapter(
            database,
            'learning_packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': item.keywords,
                  'language': item.language,
                  'last_updated_date': item.lastUpdatedDate,
                  'level': item.level,
                  'title': item.title,
                  'version': item.version
                },
            changeListener),
        _learningPackageDeletionAdapter = DeletionAdapter(
            database,
            'learning_packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': item.keywords,
                  'language': item.language,
                  'last_updated_date': item.lastUpdatedDate,
                  'level': item.level,
                  'title': item.title,
                  'version': item.version
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LearningPackage> _learningPackageInsertionAdapter;

  final UpdateAdapter<LearningPackage> _learningPackageUpdateAdapter;

  final DeletionAdapter<LearningPackage> _learningPackageDeletionAdapter;

  @override
  Stream<List<LearningPackage>> getPackages() {
    return _queryAdapter.queryListStream('SELECT * FROM learning_package',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String?,
            keywords: row['keywords'] as String,
            language: row['language'] as String,
            lastUpdatedDate: row['last_updated_date'] as String,
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int),
        queryableName: 'learning_package',
        isView: false);
  }

  @override
  Stream<List<LearningPackage>> observePackages() {
    return _queryAdapter.queryListStream('SELECT * FROM learning_packages',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String?,
            keywords: row['keywords'] as String,
            language: row['language'] as String,
            lastUpdatedDate: row['last_updated_date'] as String,
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int),
        queryableName: 'learning_packages',
        isView: false);
  }

  @override
  Future<List<LearningPackage>> getPackagesByAuthor(String authorEmail) async {
    return _queryAdapter.queryList(
        'SELECT * FROM learning_packages WHERE author = ?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String?,
            keywords: row['keywords'] as String,
            language: row['language'] as String,
            lastUpdatedDate: row['last_updated_date'] as String,
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int),
        arguments: [authorEmail]);
  }

  @override
  Future<List<LearningPackage>> getAllPackages() async {
    return _queryAdapter.queryList('SELECT * FROM learning_packages',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String?,
            keywords: row['keywords'] as String,
            language: row['language'] as String,
            lastUpdatedDate: row['last_updated_date'] as String,
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int));
  }

  @override
  Future<LearningPackage?> getPackageById(String packageId) async {
    return _queryAdapter.query(
        'SELECT * FROM learning_packages WHERE packageId = ?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String?,
            keywords: row['keywords'] as String,
            language: row['language'] as String,
            lastUpdatedDate: row['last_updated_date'] as String,
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int),
        arguments: [packageId]);
  }

  @override
  Future<void> deleteAllPackages() async {
    await _queryAdapter.queryNoReturn('DELETE FROM learning_packages');
  }

  @override
  Future<void> addPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPackages(List<LearningPackage> packages) async {
    await _learningPackageInsertionAdapter.insertList(
        packages, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePackage(LearningPackage package) async {
    await _learningPackageUpdateAdapter.update(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePackage(LearningPackage package) async {
    await _learningPackageDeletionAdapter.delete(package);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _wordInsertionAdapter = InsertionAdapter(
            database,
            'words',
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'packageId': item.packageId
                },
            changeListener),
        _wordUpdateAdapter = UpdateAdapter(
            database,
            'words',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'packageId': item.packageId
                },
            changeListener),
        _wordDeletionAdapter = DeletionAdapter(
            database,
            'words',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'packageId': item.packageId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Word> _wordInsertionAdapter;

  final UpdateAdapter<Word> _wordUpdateAdapter;

  final DeletionAdapter<Word> _wordDeletionAdapter;

  @override
  Stream<List<Word>> getWords() {
    return _queryAdapter.queryListStream('SELECT * FROM words',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            text: row['text'] as String,
            packageId: row['packageId'] as String),
        queryableName: 'words',
        isView: false);
  }

  @override
  Future<Word?> getWordById(int wordId) async {
    return _queryAdapter.query('SELECT * FROM words WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            text: row['text'] as String,
            packageId: row['packageId'] as String),
        arguments: [wordId]);
  }

  @override
  Future<List<Word>> getWordsByPackage(String packageId) async {
    return _queryAdapter.queryList('SELECT * FROM words WHERE packageId = ?1',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int?,
            text: row['text'] as String,
            packageId: row['packageId'] as String),
        arguments: [packageId]);
  }

  @override
  Future<void> deleteWordsByPackage(String packageId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM words WHERE packageId = ?1',
        arguments: [packageId]);
  }

  @override
  Future<void> deleteAllWords() async {
    await _queryAdapter.queryNoReturn('DELETE FROM words');
  }

  @override
  Future<void> addWord(Word word) async {
    await _wordInsertionAdapter.insert(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertWord(Word word) async {
    await _wordInsertionAdapter.insert(word, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertWord(Word word) async {
    await _wordInsertionAdapter.insert(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertWords(List<Word> words) async {
    await _wordInsertionAdapter.insertList(words, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateWord(Word word) async {
    await _wordUpdateAdapter.update(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWord(Word word) async {
    await _wordDeletionAdapter.delete(word);
  }
}

class _$DefinitionDao extends DefinitionDao {
  _$DefinitionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _definitionInsertionAdapter = InsertionAdapter(
            database,
            'definitions',
            (Definition item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'source': item.source,
                  'wordId': item.wordId
                }),
        _definitionUpdateAdapter = UpdateAdapter(
            database,
            'definitions',
            ['id'],
            (Definition item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'source': item.source,
                  'wordId': item.wordId
                }),
        _definitionDeletionAdapter = DeletionAdapter(
            database,
            'definitions',
            ['id'],
            (Definition item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'source': item.source,
                  'wordId': item.wordId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Definition> _definitionInsertionAdapter;

  final UpdateAdapter<Definition> _definitionUpdateAdapter;

  final DeletionAdapter<Definition> _definitionDeletionAdapter;

  @override
  Future<List<Definition?>> getDefinitionsByWord(int wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM definitions WHERE wordId = ?1',
        mapper: (Map<String, Object?> row) => Definition(
            id: row['id'] as int?,
            text: row['text'] as String,
            source: row['source'] as String,
            wordId: row['wordId'] as int),
        arguments: [wordId]);
  }

  @override
  Future<Definition?> getDefinitionById(int definitionId) async {
    return _queryAdapter.query('SELECT * FROM definitions WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Definition(
            id: row['id'] as int?,
            text: row['text'] as String,
            source: row['source'] as String,
            wordId: row['wordId'] as int),
        arguments: [definitionId]);
  }

  @override
  Future<void> deleteDefinitionsByWord(int wordId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM definitions WHERE wordId = ?1',
        arguments: [wordId]);
  }

  @override
  Future<void> insertDefinition(Definition definition) async {
    await _definitionInsertionAdapter.insert(
        definition, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertDefinitions(List<Definition> definitions) async {
    await _definitionInsertionAdapter.insertList(
        definitions, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDefinition(Definition definition) async {
    await _definitionUpdateAdapter.update(definition, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDefinition(Definition definition) async {
    await _definitionDeletionAdapter.delete(definition);
  }
}

class _$SentenceDao extends SentenceDao {
  _$SentenceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sentenceInsertionAdapter = InsertionAdapter(
            database,
            'sentences',
            (Sentence item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'wordId': item.wordId
                }),
        _sentenceUpdateAdapter = UpdateAdapter(
            database,
            'sentences',
            ['id'],
            (Sentence item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'wordId': item.wordId
                }),
        _sentenceDeletionAdapter = DeletionAdapter(
            database,
            'sentences',
            ['id'],
            (Sentence item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'wordId': item.wordId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sentence> _sentenceInsertionAdapter;

  final UpdateAdapter<Sentence> _sentenceUpdateAdapter;

  final DeletionAdapter<Sentence> _sentenceDeletionAdapter;

  @override
  Future<List<Sentence>> getSentencesByWord(int wordId) async {
    return _queryAdapter.queryList('SELECT * FROM sentences WHERE wordId = ?1',
        mapper: (Map<String, Object?> row) => Sentence(
            id: row['id'] as int?,
            text: row['text'] as String,
            wordId: row['wordId'] as int),
        arguments: [wordId]);
  }

  @override
  Future<Sentence?> getSentenceById(int sentenceId) async {
    return _queryAdapter.query('SELECT * FROM sentences WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Sentence(
            id: row['id'] as int?,
            text: row['text'] as String,
            wordId: row['wordId'] as int),
        arguments: [sentenceId]);
  }

  @override
  Future<void> deleteSentencesByWord(int wordId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM sentences WHERE wordId = ?1',
        arguments: [wordId]);
  }

  @override
  Future<void> insertSentence(Sentence sentence) async {
    await _sentenceInsertionAdapter.insert(sentence, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSentences(List<Sentence> sentences) async {
    await _sentenceInsertionAdapter.insertList(
        sentences, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSentence(Sentence sentence) async {
    await _sentenceUpdateAdapter.update(sentence, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSentence(Sentence sentence) async {
    await _sentenceDeletionAdapter.delete(sentence);
  }
}

class _$ResourceDao extends ResourceDao {
  _$ResourceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _resourceInsertionAdapter = InsertionAdapter(
            database,
            'resources',
            (Resource item) => <String, Object?>{
                  'id': item.id,
                  'extension': item.extension,
                  'resourceUrl': item.resourceUrl,
                  'title': item.title,
                  'type': item.type,
                  'sentenceId': item.sentenceId,
                  'wordId': item.wordId
                }),
        _resourceUpdateAdapter = UpdateAdapter(
            database,
            'resources',
            ['id'],
            (Resource item) => <String, Object?>{
                  'id': item.id,
                  'extension': item.extension,
                  'resourceUrl': item.resourceUrl,
                  'title': item.title,
                  'type': item.type,
                  'sentenceId': item.sentenceId,
                  'wordId': item.wordId
                }),
        _resourceDeletionAdapter = DeletionAdapter(
            database,
            'resources',
            ['id'],
            (Resource item) => <String, Object?>{
                  'id': item.id,
                  'extension': item.extension,
                  'resourceUrl': item.resourceUrl,
                  'title': item.title,
                  'type': item.type,
                  'sentenceId': item.sentenceId,
                  'wordId': item.wordId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Resource> _resourceInsertionAdapter;

  final UpdateAdapter<Resource> _resourceUpdateAdapter;

  final DeletionAdapter<Resource> _resourceDeletionAdapter;

  @override
  Future<List<Resource?>> getResourcesBySentence(int sentenceId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM resources WHERE sentenceId = ?1',
        mapper: (Map<String, Object?> row) => Resource(
            id: row['id'] as int?,
            extension: row['extension'] as String,
            resourceUrl: row['resourceUrl'] as String,
            title: row['title'] as String,
            type: row['type'] as String,
            sentenceId: row['sentenceId'] as int?,
            wordId: row['wordId'] as int?),
        arguments: [sentenceId]);
  }

  @override
  Future<List<Resource?>> getResourcesByWord(int wordId) async {
    return _queryAdapter.queryList('SELECT * FROM resources WHERE wordId = ?1',
        mapper: (Map<String, Object?> row) => Resource(
            id: row['id'] as int?,
            extension: row['extension'] as String,
            resourceUrl: row['resourceUrl'] as String,
            title: row['title'] as String,
            type: row['type'] as String,
            sentenceId: row['sentenceId'] as int?,
            wordId: row['wordId'] as int?),
        arguments: [wordId]);
  }

  @override
  Future<Resource?> getResourceById(int resourceId) async {
    return _queryAdapter.query('SELECT * FROM resources WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Resource(
            id: row['id'] as int?,
            extension: row['extension'] as String,
            resourceUrl: row['resourceUrl'] as String,
            title: row['title'] as String,
            type: row['type'] as String,
            sentenceId: row['sentenceId'] as int?,
            wordId: row['wordId'] as int?),
        arguments: [resourceId]);
  }

  @override
  Future<void> deleteResourcesBySentence(int sentenceId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM resources WHERE sentenceId = ?1',
        arguments: [sentenceId]);
  }

  @override
  Future<void> deleteResourcesByWord(int wordId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM resources WHERE wordId = ?1',
        arguments: [wordId]);
  }

  @override
  Future<void> insertResource(Resource resource) async {
    await _resourceInsertionAdapter.insert(resource, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertResources(List<Resource> resources) async {
    await _resourceInsertionAdapter.insertList(
        resources, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateResource(Resource resource) async {
    await _resourceUpdateAdapter.update(resource, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteResource(Resource resource) async {
    await _resourceDeletionAdapter.delete(resource);
  }
}
