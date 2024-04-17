import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/search_delegates/student_search_delegate.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  // String _searchText = ''; // New state variable for search text

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
      // print('Error fetching students: $error');
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

  void _handleDeleteStudent(Student student, DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      // User swiped left
      // 1. Show confirmation dialog (optional)
      final confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${student.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        setState(() {});
        return;
      } // User cancelled deletion

      // 2. Call your data access layer to delete the student
      final deletedCount = await databaseHelper.deleteStudent(student.id!);
      try {
        if (deletedCount == 0 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Student not found.'),
            ),
          );
        } else {
          // Update the studentsList state if the student is removed
          setState(() {
            studentsList.remove(student);
          });
        }
      } catch (error) {
        // Handle database errors or other unforeseen exceptions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred while deleting the student.'),
            ),
          );
        }
        print('Error deleting student: $error'); // Log for debugging
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('st list is $studentsList ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: StudentSearchDelegate(studentsList),
              );
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
                    return Dismissible(
                      key: UniqueKey(), // Unique key for each student item
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) =>
                          _handleDeleteStudent(studentsList[index], direction),
                      child: ListTile(
                          title: Text(studentsList[index].name!),
                          subtitle: Text(studentsList[index].place!),
                          leading: studentsList[index].profilePic != null
                              ? GestureDetector(
                                  onTap: () {
                                    showProfilePictureDialog(context,
                                        studentsList[index].profilePic!);
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
                                builder: ((context) =>
                                    ViewStudentsDetailsScreen(
                                      studentDetail: studentsList[index],
                                    )),
                              ),
                            );
                          }),
                    );
                  },
                ),
    );
  }
}
