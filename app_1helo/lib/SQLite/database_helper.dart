import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_data.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng
        await db.execute(
          '''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          phone TEXT NOT NULL,
          password TEXT NOT NULL,
          domain TEXT
        )
        ''',
        );

        // Thêm dữ liệu mặc định
        await db.insert('users', {
          'phone': '0869817646',
          'password': '123456',
          'domain': 'https://demo.nextco.vn/api'
        });

        await db.insert('users', {
          'phone': '0987654321',
          'password': 'password456',
          'domain': 'example.org'
        });
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateDomain(String phone, String domain) async {
    final db = await database;
    return await db.update(
      'users',
      {'domain': domain},
      where: 'phone = ?',
      whereArgs: [phone],
    );
  }
}
