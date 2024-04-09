import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class ViewStudentsListScreen extends StatelessWidget {
  const ViewStudentsListScreen({super.key, required this.studentsList});

  final void Function(List<Student> studentLists) studentsList;

  // studentsList(List<Student> stlist){

  // }

  @override
  Widget build(BuildContext context) {
    print('st list is $studentsList, ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
      ),
      body: ListView.builder(
        itemCount: studentsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(studentsList[index].name!),
            subtitle: Text(studentsList[index].place!),
            leading: Image.memory(studentsList[index].profilePic!),
          );
        },
      ),
    );
  }
}
