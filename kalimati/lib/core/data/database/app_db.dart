import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// This class is responsible for creating, opening, and giving access to the local SQLite database used by the Kalimati app.
// Other classes like PackageDao and UserDao will call [AppDb().db] to get the database connection and perform SQL operations.
class AppDb {
  // Ensures there is only one database instance open in the entire app.
  static final AppDb _instance = AppDb._internal();
  AppDb._internal();
  factory AppDb() => _instance;

  Database? _db; // Cached reference to the opened database

  // Returns an open database connection.
  // If the database is not yet created, this will create it and set up tables.
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initializes (creates or opens) the database file.
  // The database file will be stored in the device’s local storage under:
  // /data/data/<app>/databases/kalimati.db
  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'kalimati.db');

    // openDatabase automatically creates the file if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Called only ONCE: the first time the database is created.
        // Define your tables here.

        // Table for teacher-created learning packages
        await db.execute('''
          CREATE TABLE packages(
            packageId INTEGER PRIMARY KEY AUTOINCREMENT,
            json TEXT NOT NULL,                -- entire learning package as JSON
            updatedAt INTEGER NOT NULL         -- timestamp for sorting
          );
        ''');

        // Table for teacher login accounts
        await db.execute('''
          CREATE TABLE users(
            userId INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            role TEXT
          );
        ''');
      },
    );
  }

  // Optional: clears all data from the tables (for testing).
  Future<void> clearAll() async {
    final d = await db;
    await d.delete('packages');
    await d.delete('users');
  }
}
