import 'package:kalimati/core/data/database/app_database.dart';
import 'package:kalimati/features/dashboard/domain/contracts/package_repository.dart';
import 'package:kalimati/features/dashboard/domain/entities/definition.dart';
import 'package:kalimati/features/dashboard/domain/entities/sentence.dart';
import 'package:kalimati/features/dashboard/domain/entities/word.dart';

import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';
import 'package:kalimati/features/dashboard/domain/entities/resource.dart';

class PackageRepoLocalDb implements PackageRepository {
  final AppDatabase _database;

  PackageRepoLocalDb(this._database);

  // ========== PACKAGE CRUD OPERATIONS ==========

  @override
  Future<List<LearningPackage>> getTeacherPackages(String teacherEmail) async {
    return await _database.packageDao.getPackagesByAuthor(teacherEmail);
  }

  @override
  Future<Map<String, dynamic>> getPackageWithRelations(String packageId) async {
    final package = await _database.packageDao.getPackageById(packageId);
    if (package == null) return {};

    final words = await _database.wordDao.getWordsByPackage(packageId);
    final wordsWithRelations = <Map<String, dynamic>>[];

    for (final word in words) {
      final definitions = await _database.definitionDao.getDefinitionsByWord(
        word.id!,
      );

      final sentencesWithResources = <Map<String, dynamic>>[];
      final sentences = await _database.sentenceDao.getSentencesByWord(
        word.id!,
      );

      for (final sentence in sentences) {
        final resources = await _database.resourceDao.getResourcesBySentence(
          sentence.id!,
        );
        sentencesWithResources.add({
          'sentence': sentence,
          'resources': resources,
        });
      }

      final wordResources = await _database.resourceDao.getResourcesByWord(
        word.id!,
      );

      wordsWithRelations.add({
        'word': word,
        'definitions': definitions,
        'sentences': sentencesWithResources,
        'resources': wordResources,
      });
    }

    return {'package': package, 'words': wordsWithRelations};
  }

  @override
  Future<void> createPackageWithRelations({
    required LearningPackage package,
    required List<Map<String, dynamic>> wordsWithRelations,
  }) async {
    // Use Floor's built-in transaction support
    return _database.packageDao.insertPackage(package).then((_) async {
      for (final wordData in wordsWithRelations) {
        final word = wordData['word'] as Word;
        await _database.wordDao.insertWord(word);
        final wordId = word.id!;

        // Save definitions
        final definitions = wordData['definitions'] as List<Definition>;
        for (final definition in definitions) {
          await _database.definitionDao.insertDefinition(
            definition.copyWith(wordId: wordId),
          );
        }

        // Save sentences and their resources
        final sentencesData =
            wordData['sentences'] as List<Map<String, dynamic>>;
        for (final sentenceData in sentencesData) {
          final sentence = sentenceData['sentence'] as Sentence;
          await _database.sentenceDao.insertSentence(
            sentence.copyWith(wordId: wordId),
          );
          final sentenceId = sentence.id!;

          final resources = sentenceData['resources'] as List<Resource>;
          for (final resource in resources) {
            await _database.resourceDao.insertResource(
              resource.copyWith(sentenceId: sentenceId),
            );
          }
        }

        // Save word resources
        final wordResources = wordData['resources'] as List<Resource>;
        for (final resource in wordResources) {
          await _database.resourceDao.insertResource(
            resource.copyWith(wordId: wordId),
          );
        }
      }
    });
  }

  @override
  Future<void> updatePackageWithRelations({
    required LearningPackage package,
    required List<Map<String, dynamic>> wordsWithRelations,
  }) async {
    // For simplicity, delete and recreate (you can optimize this later)
    await deletePackageWithRelations(package.packageId);
    await createPackageWithRelations(
      package: package,
      wordsWithRelations: wordsWithRelations,
    );
  }

  @override
  Future<void> deletePackageWithRelations(String packageId) async {
    // Get all words first
    final words = await _database.wordDao.getWordsByPackage(packageId);

    // Delete all relationships for each word
    for (final word in words) {
      final wordId = word.id!;

      // Delete sentence resources
      final sentences = await _database.sentenceDao.getSentencesByWord(wordId);
      for (final sentence in sentences) {
        await _database.resourceDao.deleteResourcesBySentence(sentence.id!);
      }

      // Delete sentences, definitions, and word resources
      await Future.wait([
        _database.sentenceDao.deleteSentencesByWord(wordId),
        _database.definitionDao.deleteDefinitionsByWord(wordId),
        _database.resourceDao.deleteResourcesByWord(wordId),
      ]);
    }

    // Delete all words
    await _database.wordDao.deleteWordsByPackage(packageId);

    // Finally delete the package
    final package = await _database.packageDao.getPackageById(packageId);
    if (package != null) {
      await _database.packageDao.deletePackage(package);
    }
  }

  // ========== PACKAGE MANAGEMENT ==========

  @override
  Future<bool> canEditPackage(String packageId, String teacherEmail) async {
    final package = await _database.packageDao.getPackageById(packageId);
    return package != null && package.author == teacherEmail;
  }

  @override
  Future<LearningPackage?> getPackageById(String packageId) async {
    return await _database.packageDao.getPackageById(packageId);
  }

  // ========== STUDENT OPERATIONS ==========

  @override
  Stream<List<LearningPackage>> getPackages() {
    return _database.packageDao.getPackages();
  }

  @override
  Future<List<LearningPackage>> searchPackages(String query) async {
    final List<LearningPackage> allPackages = await _database.packageDao
        .getAllPackages();
    final lowercaseQuery = query.toLowerCase();

    return allPackages.where((package) {
      return package.title.toLowerCase().contains(lowercaseQuery) ||
          package.description.toLowerCase().contains(lowercaseQuery) ||
          package.category.toLowerCase().contains(lowercaseQuery) ||
          package.level.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<void> addPackage(LearningPackage package) {
    return _database.packageDao.addPackage(package);
  }

  @override
  Future<void> deletePackage(LearningPackage package) {
    return _database.packageDao.deletePackage(package);
  }

  @override
  Future<void> updatePackage(LearningPackage package) {
    return _database.packageDao.updatePackage(package);
  }
}
