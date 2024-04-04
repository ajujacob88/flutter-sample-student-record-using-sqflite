import 'package:flutter/material.dart';
//import 'dart:io';
import 'package:sample_student_record_using_sqflite/widgets/custom_date_and_age_picker.dart';
import 'package:sample_student_record_using_sqflite/widgets/image_upload.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  // final GlobalKey<FormState> _formKey =      GlobalKey<FormState>(); // Create a GlobalKey

  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  String? selectedGender;

  String _selectedDob = '';
  int? _selectedAge;

  void handleDateSelected(String dob, int age) {
    print('Date of Birth: $dob, Age: $age');
    _selectedDob = dob;
    _selectedAge = age;
  }

  void _handleSubmit() {
    String name = nameController.text;
    String place = placeController.text;
    String gender = selectedGender ?? '';

    // Check if any field is empty
    if (name.isEmpty ||
        place.isEmpty ||
        gender.isEmpty ||
        _selectedDob.isEmpty) {
      // Show a snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2), // Optional duration
        ),
      );
      return;
    }
    Student student = Student(
        name: nameController.text,
        place: placeController.text,
        gender: selectedGender,
        dob: _selectedDob,
        age: _selectedAge);

    print('Student: $student, name = ${student.name}, dob= ${student.dob}');

    // Show a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted successfully'),
        duration: Duration(seconds: 2), // Optional duration
      ),
    );

    void clearDates() {
      // Access the CustomDateAndAgePicker widget's state
      final state =
          context.findAncestorStateOfType<_CustomDateAndAgePickerState>();
      if (state != null) {
        state.clearDate();
      }
    }

    // final form = _formKey.currentState;
    // if (form != null) {
    //   form.reset();
    //   FocusScope.of(context).unfocus(); // Remove focus from any fields
    //   setState(() {}); // Optional: Force a visual update
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 10),
          child: Form(
            //  key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        nameController.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: 'Place'),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                  hint: const Text('Select Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomDateAndAgePicker(
                  onDateSelected: handleDateSelected,
                  onClear: clearDates,
                ),
                const SizedBox(
                  height: 26,
                ),
                const ImageUpload(),
                const SizedBox(
                  height: 26,
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleSubmit();
                  },
                  // onPressed: () {
                  //   print(' gender is $selectedGender');
                  // },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
