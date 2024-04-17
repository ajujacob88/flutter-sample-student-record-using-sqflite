import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/search_delegates/student_search_delegate.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';
import 'dart:async';

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

  Future<void> _handleDeleteStudent(
      Student student, DismissDirection direction) async {
    Student? deletedStudent; // To store deleted student for undo
    bool isStudentDeleted = false;
    Timer? undoTimer;

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
      }
      int deletedStudentIndex = studentsList.indexOf(student);
      deletedStudent = student; // Store deleted student for undo
      setState(() {
        // Remove from list immediately
        studentsList.removeWhere((s) => s.id == student.id);
        // studentsList.remove(student);
        isStudentDeleted = true;
        undoTimer = Timer(const Duration(seconds: 7), () {
          // Dismiss bottom sheet on undo
          // Navigator.pop(context);
          // Delete from database after 10 seconds
          //  _performActualDelete(student.id!);
        });
      });
      if (mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) => StudentDeleteUndoSheet(
            student: student,
            onUndoDelete: () {
              // Handle undo logic (cancel timer and add student back to list)
              undoTimer?.cancel();
              // Dismiss bottom sheet on undo
              Navigator.pop(context, true);

              setState(() {
                isStudentDeleted = false;
                // Add student back to list
                //studentsList.add(deletedStudent!);
                //  studentsList.insert(studentsList.indexOf(student), student);
                studentsList.insert(deletedStudentIndex, deletedStudent!);

                deletedStudent = null;
              });
            },
          ),
        ).then(
          (_) {
            print('debug chck 1 value is $isStudentDeleted');
            if (isStudentDeleted != false) {
              _performActualDelete(student.id!.toInt());
            }
          },
        );
      }
    }
  }

  void _performActualDelete(int studentId) async {
    // database operation here
    final deletedCount = await databaseHelper.deleteStudent(studentId);

    try {
      if (deletedCount == 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student not found.'),
          ),
        );
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
      // print('Error deleting student: $error'); // Log for debugging
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

class StudentDeleteUndoSheet extends StatelessWidget {
  final Student student;
  final Function onUndoDelete;

  const StudentDeleteUndoSheet({
    super.key,
    required this.student,
    required this.onUndoDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Adjust height as needed
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Student "${student.name}" deleted.'),
            TextButton(
              onPressed: () {
                onUndoDelete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Student "${student.name}" restored.'),
                  ),
                );
              }, //onUndoDelete,
              child: Text(
                'Undo',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
