import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class DatabaseHelperr {
  DatabaseHelperr._privateConstructorr();

  static final DatabaseHelperr _instance =
      DatabaseHelperr._privateConstructorr();

  factory DatabaseHelperr() => _instance;

  static Database? _db;

  static const String _dbName = 'students.db';
  //static const String _tableName = 'students';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE Students (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,  place TEXT NOT NULL, gender TEXT NOT NULL, dob TEXT NOT NULL, age INTEGER NOT NULL, profilePic BLOB)''');
      },
    );
  }

// Insert a student into the database
  Future<int> insertStudent(Map<String, dynamic> row) async {
    final dbClient = await db;
    // return await dbClient!.insert('Student', row);
    //rawinsert

    return await dbClient!.rawInsert(
      'INSERT INTO Students(name, place, gender, dob, age, profilePic) VALUES(?, ?, ?, ?, ?, ?)',
      [
        row['name'],
        row['place'],
        row['gender'],
        row['dob'],
        row['age'],
        row['profilePic'],
      ],
    );
  }

  // Read a student into the database
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final dbClient = await db;
    //return await dbClient!.query('Students');

    //raw query
    return await dbClient!.rawQuery('SELECT * FROM Students');
  }
}
