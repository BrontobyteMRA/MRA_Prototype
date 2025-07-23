import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meter_readings.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE readings(id INTEGER PRIMARY KEY, assignment_id INTEGER, current_reading TEXT, notes TEXT, sync_status INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertReading(Map<String, dynamic> reading) async {
    final db = await database;
    return await db.insert('readings', reading);
  }

  Future<List<Map<String, dynamic>>> getUnsyncedReadings() async {
    final db = await database;
    return await db.query('readings', where: 'sync_status = ?', whereArgs: [0]);
  }

  Future<int> updateSyncStatus(int id) async {
    final db = await database;
    return await db.update('readings', {'sync_status': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
