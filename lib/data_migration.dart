import 'package:sqflite/sqflite.dart';

// Define the initial database schema.
// final String createTableSql = '''
//   CREATE TABLE users (
//     id INTEGER PRIMARY KEY,
//     name TEXT,
//     email TEXT
//   )
// ''';
// Define the new database schema with an additional 'age' column.
final String createTableSqlV2 = '''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    age INTEGER
  )
''';
Future<void> migrateDatabase(Database db) async {
  // Create a new table with the updated schema.
  await db.execute(createTableSqlV2);

  // Copy data from the old table to the new table.
  await db.execute('''
    INSERT INTO users (name, email)
    SELECT name, email FROM old_users
  ''');

  // Drop the old table.
  await db.execute('DROP TABLE Old_table');
  int currentVersion = 1; // Get the current database version.
  int newVersion = 2; // The new database version.

if (currentVersion < newVersion) {
  // Perform the data migration.
  final db = await openDatabase("Server[@Name='DESKTOP-22DV33T']/Database[@Name='example']/Table[@Name='Old_table' and @Schema='dbo'].db");
  await migrateDatabase(db);

  // Update the database version.
  await db.update('meta', {'version': newVersion});
}
}


