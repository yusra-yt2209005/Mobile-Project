import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/sentence.dart';


@dao
abstract class SentenceDao {
  // Get sentences by word
  @Query('SELECT * FROM sentences WHERE wordId = :wordId')
  Future<List<Sentence>> getSentencesByWord(int wordId);

  // Get sentence by ID
  @Query('SELECT * FROM sentences WHERE id = :sentenceId')
  Future<Sentence?> getSentenceById(int sentenceId);

  // Insert sentence
  @insert
  Future<void> insertSentence(Sentence sentence);

  // Insert multiple sentences
  @insert
  Future<void> insertSentences(List<Sentence> sentences);

  // Update sentence
  @update
  Future<void> updateSentence(Sentence sentence);

  // Delete sentence
  @delete
  Future<void> deleteSentence(Sentence sentence);

  // Delete all sentences for a word
  @Query('DELETE FROM sentences WHERE wordId = :wordId')
  Future<void> deleteSentencesByWord(int wordId);
}