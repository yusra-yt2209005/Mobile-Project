import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';
import 'app_database.dart';

// Seeds the local SQLite DB with JSON data from assets/packages.json
class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      // Check if database is already seeded and packages already exist
      final packageCount = await database.packageDao.getAllPackages();

      if (packageCount.isNotEmpty) {
        return; // Already seeded, skip
      }

      // Seed Packages
      await _seedPackages(database);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedPackages(AppDatabase database) async {
    // Load JSON file
    final jsonString = await rootBundle.loadString('assets/packages.json');

    // Parse JSON
    final List<dynamic> jsonData = json.decode(jsonString);

    // Convert to Packages objects
    final packages = jsonData
        .map((json) => LearningPackage.fromJson(json))
        .toList();

    // Insert into database
    await database.packageDao.insertPackages(packages);
  }

  // Utility method to clear database (useful for testing)
  static Future<void> clearDatabase(AppDatabase database) async {
    await database.packageDao.deleteAllPackages();
  }
}
