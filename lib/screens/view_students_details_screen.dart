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

  // Widget _buildEditForm() {
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       children: [
  //         TextFormField(
  //           initialValue: _editedStudent.name,
  //           decoration: const InputDecoration(labelText: 'Name'),
  //           validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
  //           onSaved: (value) => _editedStudent.name = value,
  //         ),
  //         TextFormField(
  //           initialValue: _editedStudent.place,
  //           decoration: const InputDecoration(labelText: 'Place'),
  //           validator: (value) =>
  //               value!.isEmpty ? 'Please enter a place' : null,
  //           onSaved: (value) => _editedStudent.place = value,
  //         ),
  //         Row(
  //           children: [
  //             const Text('Date of Birth:'),
  //             const SizedBox(width: 10),
  //             TextButton(
  //               onPressed: () async {
  //                 final pickedDate = await showDatePicker(
  //                   context: context,
  //                   // initialDate: _editedStudent.dob ?? DateTime.now(),
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(1900),
  //                   lastDate: DateTime.now(),
  //                 );
  //                 if (pickedDate != null) {
  //                   setState(() {
  //                     _editedStudent.dob = pickedDate.toString();
  //                   });
  //                 }
  //               },
  //               child: Text(
  //                 //  DateFormat('yMMMMd').format(_editedStudent.dob ?? DateTime.now()),
  //                 DateFormat('yMMMMd').format(DateTime.now()),
  //                 style: const TextStyle(fontSize: 16),
  //               ),
  //             ),
  //           ],
  //         ),
  //         DropdownButtonFormField<String>(
  //           value: _editedStudent.gender,
  //           items: const [
  //             DropdownMenuItem(value: 'Male', child: Text('Male')),
  //             DropdownMenuItem(value: 'Female', child: Text('Female')),
  //             DropdownMenuItem(value: 'Other', child: Text('Other')),
  //           ],
  //           onChanged: (value) =>
  //               setState(() => _editedStudent.gender = value!),
  //           validator: (value) => value == null ? 'Please select gender' : null,
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (_formKey.currentState!.validate()) {
  //               _formKey.currentState!
  //                   .save(); // Save form data to _editedStudent
  //               final updatedStudentId =
  //                   await StudentService.editStudentDetails(_editedStudent);
  //               if (updatedStudentId != 0) {
  //                 // Update successful
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                       content: Text('Student updated successfully')),
  //                 );
  //                 // Update state to reflect changes (optional)
  //                 setState(() {
  //                   widget.studentDetail.name = _editedStudent.name;
  //                   widget.studentDetail.place = _editedStudent.place;
  //                   widget.studentDetail.dob = _editedStudent.dob;
  //                   widget.studentDetail.gender = _editedStudent.gender;
  //                 });
  //               } else {
  //                 // Update failed (e.g., database error)
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                       content:
  //                           Text('An error occurred while updating student')),
  //                 );
  //               }
  //             }
  //           },
  //           child: const Text('Update'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Add a button to enable/disable edit form
            // ElevatedButton(
            //   onPressed: () => setState(() => _isEditEnabled = !_isEditEnabled),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _isEditEnabled
            //           ? const Icon(Icons.edit_off)
            //           : const Icon(Icons.edit),
            //       const SizedBox(width: 5),
            //       Text(_isEditEnabled ? 'Disable Editing' : 'Enable Editing'),
            //     ],
            //   ),
            // ),
            // // Conditionally display the edit form
            // if (_isEditEnabled) _buildEditForm(),

            ElevatedButton(
              onPressed: () async {
                // Navigate to AddStudentScreen with student details for editing
                final updatedStudent = await Navigator.push(
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Student updated successfully')),
                  );
                  // Update UI with changes if needed
                  setState(() {
                    widget.studentDetail.name = updatedStudent.name;
                    widget.studentDetail.place = updatedStudent.place;
                    widget.studentDetail.dob = updatedStudent.dob;
                    widget.studentDetail.gender = updatedStudent.gender;
                    widget.studentDetail.age = updatedStudent.age;
                    widget.studentDetail.profilePic = updatedStudent.profilePic;
                  });
                }
              },
              child: const Text('Edit Details'),
            ),
          ],
        ),
      ),
    );
  }
}
