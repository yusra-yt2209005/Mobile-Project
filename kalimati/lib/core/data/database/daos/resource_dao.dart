import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/resource.dart';



@dao
abstract class ResourceDao {
  // Get resources by sentence
  @Query('SELECT * FROM resources WHERE sentenceId = :sentenceId')
  Future<List<Resource?>> getResourcesBySentence(int sentenceId);

  // Get resources by word
  @Query('SELECT * FROM resources WHERE wordId = :wordId')
  Future<List<Resource?>> getResourcesByWord(int wordId);

  // Get resource by ID
  @Query('SELECT * FROM resources WHERE id = :resourceId')
  Future<Resource?> getResourceById(int resourceId);

  // Insert resource
  @insert
  Future<void> insertResource(Resource resource);

  // Insert multiple resources
  @insert
  Future<void> insertResources(List<Resource> resources);

  // Update resource
  @update
  Future<void> updateResource(Resource resource);

  // Delete resource
  @delete
  Future<void> deleteResource(Resource resource);

  // Delete all resources for a sentence
  @Query('DELETE FROM resources WHERE sentenceId = :sentenceId')
  Future<void> deleteResourcesBySentence(int sentenceId);

  // Delete all resources for a word
  @Query('DELETE FROM resources WHERE wordId = :wordId')
  Future<void> deleteResourcesByWord(int wordId);
}
