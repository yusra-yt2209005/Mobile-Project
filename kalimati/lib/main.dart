import 'package:flutter/material.dart';
import 'package:kalimati/core/data/database/app_database.dart';
import 'package:provider/provider.dart';


import 'package:kalimati/core/navigations/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDbFactory.build();
  await DatabaseSeeder.seedPackages(db);

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return Provider<AppDatabase>.value(
      value: db,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      ),
    );
  }
}
