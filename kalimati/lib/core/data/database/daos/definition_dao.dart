import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/definition.dart';

@dao
abstract class DefinitionDao {
  // Get definitions by word
  @Query('SELECT * FROM definitions WHERE wordId = :wordId')
  Future<List<Definition?>> getDefinitionsByWord(int wordId);

  // Get definition by ID
  @Query('SELECT * FROM definitions WHERE id = :definitionId')
  Future<Definition?> getDefinitionById(int definitionId);

  // Insert definition
  @insert
  Future<void> insertDefinition(Definition definition);

  // Insert multiple definitions
  @insert
  Future<void> insertDefinitions(List<Definition> definitions);

  // Update definition
  @update
  Future<void> updateDefinition(Definition definition);

  // Delete definition
  @delete
  Future<void> deleteDefinition(Definition definition);

  // Delete all definitions for a word
  @Query('DELETE FROM definitions WHERE wordId = :wordId')
  Future<void> deleteDefinitionsByWord(int wordId);
}
