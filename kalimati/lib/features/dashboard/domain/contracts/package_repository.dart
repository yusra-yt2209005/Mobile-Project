import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';

abstract class PackageRepository {
  Future<List<LearningPackage>> getTeacherPackages(String teacherEmail);

  Future<Map<String, dynamic>> getPackageWithRelations(String packageId);

  Future<void> createPackageWithRelations({
    required LearningPackage package,
    required List<Map<String, dynamic>> wordsWithRelations,
  });

  Future<void> updatePackageWithRelations({
    required LearningPackage package,
    required List<Map<String, dynamic>> wordsWithRelations,
  });

  Future<void> deletePackageWithRelations(String packageId);

  Future<bool> canEditPackage(String packageId, String teacherEmail);

  Future<LearningPackage?> getPackageById(String packageId);

  Stream<List<LearningPackage>> getPackages();

  Future<List<LearningPackage>> searchPackages(String query);

  Future<void> addPackage(LearningPackage package);

  Future<void> updatePackage(LearningPackage package);
  Future<void> deletePackage(LearningPackage package);
}
