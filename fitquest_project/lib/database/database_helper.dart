import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitquest.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE challenges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        goal INTEGER NOT NULL,
        progress INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> createChallenge(Map<String, dynamic> challenge) async {
    final db = await database;
    return await db.insert('challenges', challenge);
  }

  Future<List<Map<String, dynamic>>> getAllChallenges() async {
    final db = await database;
    return await db.query('challenges', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getChallenge(int id) async {
    final db = await database;
    final result = await db.query('challenges', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateChallenge(int id, Map<String, dynamic> challenge) async {
    final db = await database;
    return await db.update('challenges', challenge, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteChallenge(int id) async {
    final db = await database;
    return await db.delete('challenges', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}