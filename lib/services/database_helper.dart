// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:async';

// class DatabaseHelper {
//   static Database? _database;
//   static const String _dbName = 'meter_readings.db';
//   static const String _tableName = 'readings';

//   // Create the database and table
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   _initDatabase() async {
//     String path = join(await getDatabasesPath(), _dbName);
//     return await openDatabase(path, version: 1, onCreate: (db, version) {
//       db.execute(
//         '''CREATE TABLE $_tableName(
//           id INTEGER PRIMARY KEY AUTOINCREMENT, 
//           assignmentId INTEGER, 
//           currentReading TEXT,
//           consumption TEXT,
//           notes TEXT,
//           isSubmitted INTEGER)''',
//       );
//     });
//   }

//   // Insert a new reading
//   Future<void> insertReading(Map<String, dynamic> reading) async {
//     final db = await database;
//     await db.insert(
//       _tableName,
//       reading,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Get all unsynced readings
//   Future<List<Map<String, dynamic>>> getUnsyncedReadings() async {
//     final db = await database;
//     return await db.query(
//       _tableName,
//       where: 'isSubmitted = ?',
//       whereArgs: [0], // 0 indicates the reading is not submitted
//     );
//   }

//   // Mark reading as submitted
//   Future<void> markAsSubmitted(int id) async {
//     final db = await database;
//     await db.update(
//       _tableName,
//       {'isSubmitted': 1}, // 1 indicates the reading is submitted
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
