import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/word.dart';

@dao
abstract class WordDao {
  @Query("SELECT * FROM words")
  Stream<List<Word>> getWords();

  @insert
  Future<void> addWord(Word word);

  // Delete word
  @delete
  Future<void> deleteWord(Word word);

  // Get word by ID
  @Query('SELECT * FROM words WHERE id = :wordId')
  Future<Word?> getWordById(int wordId);

  // Update word
  @update
  Future<void> updateWord(Word word);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertWord(Word word);

  // Get words by package
  @Query('SELECT * FROM words WHERE packageId = :packageId')
  Future<List<Word>> getWordsByPackage(String packageId);

  // Insert word
  @insert
  Future<void> insertWord(Word word);

  // Insert multiple words
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWords(List<Word> words);

  // Delete all words in a package
  @Query('DELETE FROM words WHERE packageId = :packageId')
  Future<void> deleteWordsByPackage(String packageId);

  @Query("DELETE FROM words")
  Future<void> deleteAllWords();
}
