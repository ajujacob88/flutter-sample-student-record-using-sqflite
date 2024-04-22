import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:sample_student_record_using_sqflite/services/student_service.dart';
import 'package:sample_student_record_using_sqflite/screens/add_students_screen.dart';

class ViewStudentsDetailsScreen extends StatefulWidget {
  const ViewStudentsDetailsScreen({super.key, required this.studentDetail});

  final Student studentDetail;

  @override
  State<ViewStudentsDetailsScreen> createState() =>
      _ViewStudentsDetailsScreenState();
}

class _ViewStudentsDetailsScreenState extends State<ViewStudentsDetailsScreen> {
//  final _formKey = GlobalKey<FormState>(); // Form key for validation
//  late Student _editedStudent = widget.studentDetail; // Copy of student data
//  bool _isEditEnabled = false; // Flag to enable/disable edit form

  bool _detailsUpdated = false;

  Student? updatedStudent;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        Navigator.pop(context, updatedStudent);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.studentDetail.name ?? 'Student Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.studentDetail.profilePic != null)
                GestureDetector(
                  onTap: () {
                    showProfilePictureDialog(
                        context, widget.studentDetail.profilePic!);
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          MemoryImage(widget.studentDetail.profilePic!),
                    ),
                  ),
                )
              else
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text('Name: ${widget.studentDetail.name ?? 'N/A'}'),
              Text('Place: ${widget.studentDetail.place ?? 'N/A'}'),
              Text('Gender: ${widget.studentDetail.gender ?? 'N/A'}'),
              Text('Date of Birth: ${widget.studentDetail.dob ?? 'N/A'}'),
              Text('Age: ${widget.studentDetail.age ?? 'N/A'}'),
              // Text('id is: ${widget.studentDetail.id ?? 'N/A'}'),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  // Navigate to AddStudentScreen with student details for editing
                  updatedStudent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudentsScreen(
                        initialStudent: widget.studentDetail,
                        isEditt: true, // Flag for editing mode
                      ),
                    ),
                  );
                  if (updatedStudent != null) {
                    // Update successful (handle the updated student data)
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Student updated successfully'),
                    //     duration: Duration(seconds: 2),
                    //   ),
                    // );
                    // Update UI with changes if needed
                    setState(
                      () {
                        widget.studentDetail.name = updatedStudent!.name;
                        widget.studentDetail.place = updatedStudent!.place;
                        widget.studentDetail.dob = updatedStudent!.dob;
                        widget.studentDetail.gender = updatedStudent!.gender;
                        widget.studentDetail.age = updatedStudent!.age;
                        widget.studentDetail.profilePic =
                            updatedStudent!.profilePic;
                      },
                    );

                    // Pass the updated student back to the list screen
                    //   Navigator.pop(context, updatedStudent);
                    // Pass the updated student back to the list screen
                    _detailsUpdated = true;
                  }
                },
                child: const Text('Edit Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
