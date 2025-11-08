// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kalimati/core/navigations/app_router.dart';
import 'package:kalimati/core/data/database/database_provider.dart';
import 'package:kalimati/core/data/database/database_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use a container so we can read providers before runApp
  final container = ProviderContainer();

  try {
    // Build/open the Floor DB
    final db = await container.read(databaseProvider.future);

    // Seed packages once if DB is empty
    await DatabaseSeeder.seedDatabase(db);

    debugPrint('[MAIN] DB ready & seeded');
  } catch (e) {
    debugPrint('[MAIN] DB init error: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If your AppRouter is a class with .router instance (as in your code)
    final appRouter = AppRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kalimati',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      routerConfig: appRouter.router,
    );
  }
}