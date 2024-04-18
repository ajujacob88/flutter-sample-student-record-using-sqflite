import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class StudentService {
  static final DatabaseHelperr _dbHelper = DatabaseHelperr();

// Insert a student into the database
  static Future<int> insertStudent(Map<String, dynamic> row) async {
    final dbClient = await _dbHelper.db;
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

  static Future<List<Student>> getAllStudents() async {
    final dbClient = await _dbHelper.db;
    //final List<Map<String, dynamic>> maps = await dbClient!.query('students');

    final List<Map<String, dynamic>> maps =
        await dbClient!.rawQuery('SELECT * FROM Students');
    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i]['id'],
        name: maps[i]['name'],
        place: maps[i]['place'],
        gender: maps[i]['gender'],
        dob: maps[i]['dob'],
        age: maps[i]['age'],
        profilePic: maps[i]['profilePic'],
      );
    });
  }

  static Future<int> deleteStudent(int id) async {
    final dbClient = await _dbHelper.db;
    // return await dbClient!.delete('students', where: 'id = ?', whereArgs: [id],);

    //using raw query
    //return await dbClient!.rawDelete('DELETE FROM students WHERE id = ?', [id]);
    //done error handling

    try {
      return await dbClient!
          .rawDelete('DELETE FROM students WHERE id = ?', [id]);
    } catch (error) {
      print('Error deleting student: $error');
      return 0; // Indicate no rows deleted on error
    }
  }
}
