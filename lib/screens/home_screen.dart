/*
import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/screens/add_students_screen.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_list_screen.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Map<String, dynamic>>? studentsList2;
  List<Student>? studentsList2;

  @override
  void initState() {
    super.initState();
    _getStudents();
  }

  Future<void> _getStudents() async {
    final databaseHelper = DatabaseHelperr();
    studentsList2 = await databaseHelper.getAllStudents();
    setState(() {}); // Update state to trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    List<Student> studentsList = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddStudentsScreen(
                      //  studentsList: studentsList2!,
                      ),
                ),
              );

              // Navigator.pushNamed(context, '/addDetails');
            },
            child: const Text('Add Students'),
          ),
          const SizedBox(
            width: 26,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ViewStudentsListScreen(
                    studentsList: studentsList2!,
                  ),
                ),
              );
            },
            child: const Text('View Students'),
          )
        ],
      )),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/screens/add_students_screen.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_list_screen.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  //final void Function(List<Student>) studentsList;

  //final List<Student> studentsList;

  @override
  Widget build(BuildContext context) {
    //   List<Student> studentsList = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddStudentsScreen(
                      //  studentsList: studentsList,
                      ),
                ),
              );

              // Navigator.pushNamed(context, '/addDetails');
            },
            child: const Text('Add Students'),
          ),
          const SizedBox(
            width: 26,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ViewStudentsListScreen(
                      //       studentsList: studentsList,
                      ),
                ),
              );
            },
            child: const Text('View Students'),
          )
        ],
      )),
    );
  }
}



/*


import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/screens/add_students_screen.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_list_screen.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  //final void Function(List<Student>) studentsList;

  //final List<Student> studentsList;

  @override
  Widget build(BuildContext context) {
    List<Student> studentsList = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddStudentsScreen(
                    studentsList: studentsList,
                  ),
                ),
              );

              // Navigator.pushNamed(context, '/addDetails');
            },
            child: const Text('Add Students'),
          ),
          const SizedBox(
            width: 26,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ViewStudentsListScreen(
                    studentsList: studentsList,
                  ),
                ),
              );
            },
            child: const Text('View Students'),
          )
        ],
      )),
    );
  }
}

*/