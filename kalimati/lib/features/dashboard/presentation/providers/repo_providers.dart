import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/data/database/database_provider.dart';
import 'package:kalimati/features/dashboard/data/repository/package_repo_local_db.dart';
import 'package:kalimati/features/dashboard/domain/contracts/package_repository.dart';

final packageRepoProvider = FutureProvider<PackageRepository>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return PackageRepoLocalDb(db);
});

// // Return interface types, not concrete implementations
// final bookRepoProvider = FutureProvider<BookRepository>((ref) async {
//   final database = await ref.watch(databaseProvider.future);
//   return BookRepoLocalDB(database.bookDao);
// });
