import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton yapısı
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Veritabanı başlatma
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'araclar.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE araclar(id INTEGER PRIMARY KEY AUTOINCREMENT, marka TEXT, model TEXT, plaka TEXT)',
        );
      },
      version: 1,
    );
  }

  // Araç ekleme
  Future<void> insertArac(Map<String, dynamic> arac) async {
    final db = await database;
    await db.insert(
      'araclar',
      arac,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Araçları alma
  Future<List<Map<String, dynamic>>> getAraclar() async {
    final db = await database;
    return db.query('araclar');
  }

  // Araç güncelleme
  Future<void> updateArac(int id, Map<String, dynamic> arac) async {
    final db = await database;
    await db.update(
      'araclar',
      arac,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Araç silme
  Future<void> deleteArac(int id) async {
    final db = await database;
    await db.delete(
      'araclar',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
