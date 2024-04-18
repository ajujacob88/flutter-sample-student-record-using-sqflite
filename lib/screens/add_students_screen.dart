import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
//import 'dart:io';
import 'package:sample_student_record_using_sqflite/widgets/custom_date_and_age_picker.dart';
import 'package:sample_student_record_using_sqflite/widgets/image_upload.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/services/student_service.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({
    super.key,
  });

  // final List<Student> studentsList;

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  // final DatabaseHelperr _databaseHelper = DatabaseHelperr(); //the student database insert function is moved to student service and declared it as static, so we can directly access the functions by calling studentservice (dot)methodname, no need to create the object/instance

  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  String? selectedGender;

  String _selectedDob = '';
  int? _selectedAge;
  Uint8List? _imageBytes;
  Function? clearImg;

  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  GlobalKey<FormFieldState<String>> newKeyForDropDownButton =
      GlobalKey<FormFieldState<String>>();

  void handleDateSelected(String dob, int age) {
    print('Date of Birth: $dob, Age: $age');
    _selectedDob = dob;
    _selectedAge = age;
  }

  void handleDobControllers(
      TextEditingController dobControll, TextEditingController ageControll) {
    dobController = dobControll;
    ageController = ageControll;
  }

  void handleImageSelected(Uint8List? imageBytes,
      TextEditingController imageControll, Function clearImage) {
    _imageBytes = imageBytes;
    imageController = imageControll;
    clearImg = clearImage;
  }

  // List<Student> studentsList = [];

  // void addStudent(Student student) {
  //   widget.studentsList.add(student);

  // }

  Future<void> addStudent(Student student) async {
    await StudentService.insertStudent(student.toMap());
  }

  void _handleSubmit() {
    Student student = Student(
        name: nameController.text,
        place: placeController.text,
        gender: selectedGender,
        dob: _selectedDob,
        age: _selectedAge,
        profilePic: _imageBytes);

    addStudent(student);

    // Show a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted successfully'),
        duration: Duration(seconds: 2), // Optional duration
      ),
    );

    // now clear the controllers
    nameController.clear();
    placeController.clear();
    dobController.clear();
    ageController.clear();
    imageController.clear();

    _selectedDob = '';
    _selectedAge = null;

    //clearing the drop down button form field
    newKeyForDropDownButton.currentState!.reset();

    //clearing the image bytes
    if (clearImg != null) {
      clearImg!();
    }
    _imageBytes = null;

    clearImg = null;

    print(
        'Student: $student, name = ${student.name}, dob= ${student.dob}, ${student.gender}, ${student.age}, ${student.profilePic}');
  }

  final _formKey = GlobalKey<FormState>();
  var _hasError = false; // Flag to track validation state

  // var _autovalidationflag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 10),
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.disabled,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return value.length < 3
                        ? 'Name must be at least 3 to 30 characters long'
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // autovalidateMode: _autovalidationflag
                  //     ? AutovalidateMode.disabled
                  //     : AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 13,
                ),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: 'Place'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the place';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // autovalidateMode: _autovalidationflag
                  //     ? AutovalidateMode.disabled
                  //     : AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                  key: newKeyForDropDownButton,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .dividerColor), // Optional colored border on focus
                    ),
                  ),
                  hint: Text(
                    'Select Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: _hasError
                          ? const Color.fromARGB(255, 173, 49, 40)
                          : null,
                    ), // Match the font weight
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        _hasError = true;
                      });

                      return 'Please select the gender';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // autovalidateMode: _autovalidationflag
                  //     ? AutovalidateMode.disabled
                  //     : AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomDateAndAgePicker(
                  onDateSelected: handleDateSelected,
                  onClear: handleDobControllers,
                ),
                const SizedBox(
                  height: 26,
                ),
                ImageUpload(
                  //  forClearImage: forClearImage2,
                  onSelectImage: handleImageSelected,
                ),
                const SizedBox(
                  height: 26,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (ctx) => AddStudentsScreen(
                      //           studentsList: widget.studentsList,
                      //         )));
                      _handleSubmit();
                      // _formKey.currentState!.reset(); // Reset the form

                      // _autovalidationflag = false;
                    }
                  },
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
