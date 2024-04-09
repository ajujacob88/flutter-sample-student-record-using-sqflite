import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/screens/add_students_screen.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_list_screen.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.studentsList});

  final void Function(List<Student>) studentsList;
  @override
  Widget build(BuildContext context) {
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
                    passingStudentsListt: studentsList,
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
