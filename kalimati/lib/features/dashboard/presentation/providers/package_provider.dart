import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/features/dashboard/domain/contracts/package_repository.dart';
import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';
import 'package:kalimati/features/dashboard/presentation/providers/repo_providers.dart';
//import 'package:kalimati/features/dashboard/presentation/screens/student/student_home_page.dart';


class PackageData {
  List<LearningPackage> packages;
  LearningPackage? selectedPackage;

  PackageData({required this.packages, this.selectedPackage});
}

class PackageNotifier extends AsyncNotifier<PackageData> {
  late final PackageRepository packageRepo;

  @override
  Future<PackageData> build() async {
    // final db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final dbDao = db.categoryDao;
    // categoryRepo = CategoryRepoLocalDb(dbDao);
    // final db = await ref.read(categoryRepoProvider.future);

    packageRepo = await ref.read(packageRepoProvider.future);
    packageRepo.getPackages().listen((packages) {
      state = AsyncData(
        PackageData(
          packages: packages,
          selectedPackage: state.value?.selectedPackage,
        ),
      );
    });
    return PackageData(packages: []);
  }

  /// Adds a new category to the repository and updates state
  Future<void> addPackage(LearningPackage package) async {
    try {
      await packageRepo.addPackage(package);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing category in the repository and updates state
  Future<void> updatePackage(LearningPackage package) async {
    try {
      await packageRepo.updatePackage(package);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a category from the repository and updates state
  Future<void> deletePackage(LearningPackage package) async {
    try {
      await packageRepo.deletePackage(package);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the selected category in state
  void updateSelectedPackage(LearningPackage? package) {
    state = AsyncData(
      PackageData(
        packages: state.value?.packages ?? [],
        selectedPackage: package,
      ),
    );
  }

  /// Clears the selected category
  void clearSelectedPackage() {
    state = AsyncData(
      PackageData(packages: state.value?.packages ?? [], selectedPackage: null),
    );
  }

  /// Gets a category by its ID
  Future<LearningPackage?> getPackageById(String id) async {
    return await packageRepo.getPackageById(id);
  }
}

final PackageNotifierProvider =
    AsyncNotifierProvider<PackageNotifier, PackageData>(
      () => PackageNotifier(),
    );
