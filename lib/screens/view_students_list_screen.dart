import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
//import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/search_delegates/student_search_delegate.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';
import 'package:sample_student_record_using_sqflite/widgets/confirmation_dialog.dart';
import 'dart:async';
import 'package:sample_student_record_using_sqflite/widgets/student_delete_undo_sheet.dart';

import 'package:sample_student_record_using_sqflite/services/student_service.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  bool _isLoading = false; // New state variable

  //since the database functions are defined in student service as static methods, this functions can be assessed directly with classname and dot, not by creating object(because the functions are written as static, means that Static methods are associated with the class itself rather than instances of the class. They can be accessed directly using the class name followed by a dot (.).)
  // final StudentService stdserv = StudentService();
// final DatabaseHelperr databaseHelper = DatabaseHelperr();
  late List<Student> studentsList = [];
  Set<int> selectedStudents = {};
  bool _isMultipleSelection = false;

  Future<void> fetchStudents() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      // final students = await databaseHelper.getAllStudents();
      //final students = await stdserv.getAllStudents();
      final students = await StudentService.getAllStudents();
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
      //  Show confirmation dialog (optional)
      //AlertDialog is written as a widget named as confirmationdialog
      final confirmed = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete ${student.name}',
          onCancel: (context) => Navigator.pop(context, false),
          onConfirm: (context) => Navigator.pop(context, true),
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
        undoTimer = Timer(
          const Duration(seconds: 7),
          () {
            // Dismiss bottom sheet on undo
            // Navigator.pop(context);
            // Delete from database after 10 seconds
            //  _performActualDelete(student.id!);
          },
        );
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
    // final deletedCount = await databaseHelper.deleteStudent(studentId);
    final deletedCount = await StudentService.deleteStudent(studentId);
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

    // return WillPopScope(
    //   onWillPop: () async {
    //     if (_isMultipleSelection) {
    //       setState(() {
    //         _isMultipleSelection = false;
    //         selectedStudents.clear();
    //       });
    //       return false; // Block back button press while in multi-selection mode
    //     }
    //     return true; // Allow back button press otherwise
    //   },

    return PopScope(
      canPop: _isMultipleSelection ? false : true,
      onPopInvoked: (_) {
        _handleTapOutside();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Students List'),
          actions: [
            _isMultipleSelection
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  )
                : IconButton(
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
                      final student = studentsList[index];
                      final isSelected = selectedStudents.contains(student.id!);
                      return Dismissible(
                        key: UniqueKey(), // Unique key for each student item
                        background: Container(
                          color: Color.fromARGB(48, 244, 67, 54),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _handleDeleteStudent(
                            studentsList[index], direction),
                        child: GestureDetector(
                          // Handle both taps (single selection) and long press (multi-selection toggle)
                          onTap: () {
                            // if (_isMultipleSelection)
                            //   _handleLongPress(student.id!);
                            _handleTapOutside();
                          },

                          onLongPress: () => _handleLongPress(student.id!),
                          child: Container(
                            color: isSelected
                                ? Color.fromARGB(18, 129, 20, 238)
                                : Colors.transparent,
                            // Change background color on selection
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
                                if (_isMultipleSelection) {
                                  return _handleLongPress(student.id!);
                                } else {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          ViewStudentsDetailsScreen(
                                            studentDetail: studentsList[index],
                                          )),
                                    ),
                                  )
                                      .then((updatedStudent) {
                                    if (updatedStudent != null) {
                                      print(
                                          'debug check 1 updated student issssssss $updatedStudent');

                                      // Update your student list with the edited data
                                      setState(() {
                                        // Find the index of the student to update
                                        int indexToUpdate =
                                            studentsList.indexWhere((student) =>
                                                student.id ==
                                                updatedStudent.id);
                                        if (indexToUpdate != -1) {
                                          studentsList[indexToUpdate] =
                                              updatedStudent;
                                        }
                                      });
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _handleLongPress(int studentId) async {
    // await Vibration.vibrate(
    //     duration: 50); // Vibrate for 50 milliseconds on long press
    setState(() {
      _isMultipleSelection = true;
      if (selectedStudents.contains(studentId)) {
        selectedStudents.remove(studentId);
      } else {
        selectedStudents.add(studentId);
      }
    });
  }

  void _handleTapOutside() async {
    // await Vibration.vibrate(
    //     duration: 50); // Vibrate for 50 milliseconds on long press
    print('gebugg checkkkkkkkkkkkk handle tap outsideeeeeeeeeeeeeee');
    setState(() {
      _isMultipleSelection = false;

      // selectedStudents.removeAll(selectedStudents);
      selectedStudents.clear();
    });
  }
}




/*
import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
//import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/search_delegates/student_search_delegate.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';
import 'package:sample_student_record_using_sqflite/widgets/confirmation_dialog.dart';
import 'dart:async';
import 'package:sample_student_record_using_sqflite/widgets/student_delete_undo_sheet.dart';

import 'package:sample_student_record_using_sqflite/services/student_service.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  bool _isLoading = false; // New state variable

  //since the database functions are defined in student service as static methods, this functions can be assessed directly with classname and dot, not by creating object(because the functions are written as static, means that Static methods are associated with the class itself rather than instances of the class. They can be accessed directly using the class name followed by a dot (.).)
  // final StudentService stdserv = StudentService();
// final DatabaseHelperr databaseHelper = DatabaseHelperr();
  late List<Student> studentsList = [];
  Set<int> selectedStudents = {};
  bool _isMultipleSelection = false;

  Future<void> fetchStudents() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      // final students = await databaseHelper.getAllStudents();
      //final students = await stdserv.getAllStudents();
      final students = await StudentService.getAllStudents();
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
      //  Show confirmation dialog (optional)
      //AlertDialog is written as a widget named as confirmationdialog
      final confirmed = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete ${student.name}',
          onCancel: (context) => Navigator.pop(context, false),
          onConfirm: (context) => Navigator.pop(context, true),
        ),

        // final confirmed = await showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: const Text('Confirm Delete'),
        //     content: Text('Are you sure you want to delete ${student.name}'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context, false),
        //         child: const Text('Cancel'),
        //       ),
        //       TextButton(
        //         onPressed: () => Navigator.pop(context, true),
        //         child: const Text('Delete'),
        //       ),
        //     ],
        //   ),
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
        undoTimer = Timer(
          const Duration(seconds: 7),
          () {
            // Dismiss bottom sheet on undo
            // Navigator.pop(context);
            // Delete from database after 10 seconds
            //  _performActualDelete(student.id!);
          },
        );
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
    // final deletedCount = await databaseHelper.deleteStudent(studentId);
    final deletedCount = await StudentService.deleteStudent(studentId);
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
          _isMultipleSelection
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                )
              : IconButton(
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
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: studentsList.length,
                  itemBuilder: (context, index) {
                    final student = studentsList[index];
                    final isSelected = selectedStudents.contains(student.id!);

                    return GestureDetector(
                      // Handle both taps (single selection) and long press (multi-selection toggle)
                      onTap: () {
                        if (_isMultipleSelection) _handleLongPress(student.id!);
                      },
                      onLongPress: () => _handleLongPress(student.id!),
                      child: Container(
                        color: isSelected
                            ? Color.fromARGB(18, 129, 20, 238)
                            : Colors.transparent,
                        // Change background color on selection
                        child: ListTile(
                          title: Text(student.name!),
                          subtitle: Text(student.place!),
                          leading: student.profilePic != null
                              ? GestureDetector(
                                  onTap: () {
                                    showProfilePictureDialog(
                                        context, student.profilePic!);
                                  },
                                  child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          MemoryImage(student.profilePic!)),
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.account_circle_rounded),
                                ),
                          // Apply visual feedback based on selection state (optional)
                          selected: isSelected, // For ListTile visual feedback
                          // You can also change text color, background color etc.
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _handleLongPress(int studentId) async {
    // await Vibration.vibrate(
    //     duration: 50); // Vibrate for 50 milliseconds on long press
    setState(() {
      _isMultipleSelection = true;
      if (selectedStudents.contains(studentId)) {
        selectedStudents.remove(studentId);
      } else {
        selectedStudents.add(studentId);
      }
    });
  }
}

*/



/*
import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
//import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
import 'package:sample_student_record_using_sqflite/search_delegates/student_search_delegate.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';
import 'package:sample_student_record_using_sqflite/widgets/confirmation_dialog.dart';
import 'dart:async';
import 'package:sample_student_record_using_sqflite/widgets/student_delete_undo_sheet.dart';

import 'package:sample_student_record_using_sqflite/services/student_service.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  bool _isLoading = false; // New state variable

  //since the database functions are defined in student service as static methods, this functions can be assessed directly with classname and dot, not by creating object(because the functions are written as static, means that Static methods are associated with the class itself rather than instances of the class. They can be accessed directly using the class name followed by a dot (.).)
  // final StudentService stdserv = StudentService();
// final DatabaseHelperr databaseHelper = DatabaseHelperr();
  late List<Student> studentsList = [];
  Set<int> selectedStudents = {};
  bool _isMultipleSelection = false;

  Future<void> fetchStudents() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      // final students = await databaseHelper.getAllStudents();
      //final students = await stdserv.getAllStudents();
      final students = await StudentService.getAllStudents();
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
      //  Show confirmation dialog (optional)
      //AlertDialog is written as a widget named as confirmationdialog
      final confirmed = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete ${student.name}',
          onCancel: (context) => Navigator.pop(context, false),
          onConfirm: (context) => Navigator.pop(context, true),
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
        undoTimer = Timer(
          const Duration(seconds: 7),
          () {
            // Dismiss bottom sheet on undo
            // Navigator.pop(context);
            // Delete from database after 10 seconds
            //  _performActualDelete(student.id!);
          },
        );
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
    // final deletedCount = await databaseHelper.deleteStudent(studentId);
    final deletedCount = await StudentService.deleteStudent(studentId);
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
        actions: [
          _isMultipleSelection
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                )
              : IconButton(
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
                    final student = studentsList[index];
                    final isSelected = selectedStudents.contains(student.id!);
                    return Dismissible(
                      key: UniqueKey(), // Unique key for each student item
                      background: Container(
                        color: Color.fromARGB(48, 244, 67, 54),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) =>
                          _handleDeleteStudent(studentsList[index], direction),
                      child: GestureDetector(
                        // Handle both taps (single selection) and long press (multi-selection toggle)
                        onTap: () {
                          // if (_isMultipleSelection)
                          //   _handleLongPress(student.id!);
                          _handleTapOutside();
                        },
                       
                        onLongPress: () => _handleLongPress(student.id!),
                        child: Container(
                          color: isSelected
                              ? Color.fromARGB(18, 129, 20, 238)
                              : Colors.transparent,
                          // Change background color on selection
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
                              if (_isMultipleSelection) {
                                return _handleLongPress(student.id!);
                              } else {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        ViewStudentsDetailsScreen(
                                          studentDetail: studentsList[index],
                                        )),
                                  ),
                                )
                                    .then((updatedStudent) {
                                  if (updatedStudent != null) {
                                    print(
                                        'debug check 1 updated student issssssss $updatedStudent');

                                    // Update your student list with the edited data
                                    setState(() {
                                      // Find the index of the student to update
                                      int indexToUpdate =
                                          studentsList.indexWhere((student) =>
                                              student.id == updatedStudent.id);
                                      if (indexToUpdate != -1) {
                                        studentsList[indexToUpdate] =
                                            updatedStudent;
                                      }
                                    });
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _handleLongPress(int studentId) async {
    // await Vibration.vibrate(
    //     duration: 50); // Vibrate for 50 milliseconds on long press
    setState(() {
      _isMultipleSelection = true;
      if (selectedStudents.contains(studentId)) {
        selectedStudents.remove(studentId);
      } else {
        selectedStudents.add(studentId);
      }
    });
  }

  void _handleTapOutside() async {
    // await Vibration.vibrate(
    //     duration: 50); // Vibrate for 50 milliseconds on long press
    print('gebugg checkkkkkkkkkkkk handle tap outsideeeeeeeeeeeeeee');
    setState(() {
      _isMultipleSelection = false;

      selectedStudents.removeAll(selectedStudents);
    });
  }
}



*/