import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';

@dao
abstract class PackageDao {
  @Query("SELECT * FROM learning_package")
  Stream<List<LearningPackage>> getPackages();

  @Query("SELECT * FROM learning_packages")
  Stream<List<LearningPackage>> observePackages();

  @insert
  Future<void> addPackage(LearningPackage package);

  // Update package
  @update
  Future<void> updatePackage(LearningPackage package);

  // Delete package
  @delete
  Future<void> deletePackage(LearningPackage package);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertPackage(LearningPackage package);

  // Get all packages by author
  @Query('SELECT * FROM learning_packages WHERE author = :authorEmail')
  Future<List<LearningPackage>> getPackagesByAuthor(String authorEmail);

  // Get all packages
  @Query('SELECT * FROM learning_packages')
  Future<List<LearningPackage>> getAllPackages();

  // Insert package
  @insert
  Future<void> insertPackage(LearningPackage package);

  //insert packages
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPackages(List<LearningPackage> packages);

  // Get package by ID
  @Query('SELECT * FROM learning_packages WHERE packageId = :packageId')
  Future<LearningPackage?> getPackageById(String packageId);

  @Query("DELETE FROM learning_packages")
  Future<void> deleteAllPackages();
}
