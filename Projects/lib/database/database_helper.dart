import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper
      ._init(); //instance of database helper


  static Database? _database;


  //Private constructor


  DataBaseHelper._init();


  // Getter for db
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }


  // Initialize db
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);


    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  // create db
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT,
      lastName TEXT,
      email TEXT UNIQUE NOT NULL,
      contact TEXT,
      dob TEXT,
      gender TEXT,
      country TEXT,
      password TEXT NOT NULL,
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP
    )
    ''');

  }


  // Insert
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }


  // Fetch
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }




}