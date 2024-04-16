import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  //final List<Student> studentsList;
  bool _isLoading = false; // New state variable

  final DatabaseHelperr databaseHelper = DatabaseHelperr();
  late List<Student> studentsList = [];

  Future<void> fetchStudents() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      final students = await databaseHelper.getAllStudents();
      setState(() {
        studentsList = students;
        _isLoading = false; // Set loading state to false after fetching
      });
    } catch (error) {
      print('Error fetching students: $error');
      // Display an error message to the user (e.g., using a SnackBar)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while fetching students.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    //print('st list is $studentsList ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement your search functionality here
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show progress indicator while loading
          : studentsList.isEmpty
              ? const Center(
                  child: Text(
                      'List is empty')) // Show "List is empty" if no students found

              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: studentsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(studentsList[index].name!),
                        subtitle: Text(studentsList[index].place!),
                        leading: studentsList[index].profilePic != null
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(
                                                  studentsList[index]
                                                      .profilePic!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: MemoryImage(
                                        studentsList[index].profilePic!)),
                              )
                            : const CircleAvatar(
                                radius: 25,
                                child: Icon(Icons.account_circle_rounded),
                                // Adjust the radius as needed
                              ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => ViewStudentsDetailsScreen(
                                    studentDetail: studentsList[index],
                                  )),
                            ),
                          );
                        });
                  },
                ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';

class ViewStudentsListScreen extends StatelessWidget {
  ViewStudentsListScreen({super.key, required this.studentsList});

  final List<Student> studentsList;

  // final DatabaseHelperr _databaseHelper = DatabaseHelperr();
  // Future<List<Student>> _getStudents() async {
  //   final students = await _databaseHelper.getAllStudents();
  //   return students.map((student) => Student.fromMap(student)).toList();
  // }

  // Future<void> _getStudents() async {
  //   final students = await _databaseHelper.getAllStudents();
  //   var studentsList2 =
  //       students.map((student) => Student.fromMap(student)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    //print('st list is $studentsList ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: studentsList.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(studentsList[index].name!),
              subtitle: Text(studentsList[index].place!),
              // leading: Image.memory(studentsList[index].profilePic!),
              // leading: studentsList[index].profilePic != null
              //     ? Image.memory(studentsList[index].profilePic!)
              //     : const Icon(Icons
              //         .account_circle), // Placeholder icon when profile pic is null

              // leading: studentsList[index].profilePic != null
              //     ? CircleAvatar(
              //         backgroundImage:
              //             MemoryImage(studentsList[index].profilePic!),
              //         radius: 25, // Adjust the radius as needed
              //       )
              //     : const CircleAvatar(
              //         child: const Icon(Icons.account_circle_rounded),
              //         radius: 25, // Adjust the radius as needed
              //       ),

              leading: studentsList[index].profilePic != null
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        studentsList[index].profilePic!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              MemoryImage(studentsList[index].profilePic!)),
                    )
                  : const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.account_circle_rounded),
                      // Adjust the radius as needed
                    ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => ViewStudentsDetailsScreen(
                          studentDetail: studentsList[index],
                        )),
                  ),
                );
              });
        },
      ),
    );
  }
}
*/
