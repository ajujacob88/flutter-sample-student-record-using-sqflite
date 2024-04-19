import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
//import 'dart:io';
import 'package:sample_student_record_using_sqflite/widgets/custom_date_and_age_picker.dart';
import 'package:sample_student_record_using_sqflite/widgets/image_upload.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/services/student_service.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key, this.initialStudent, this.isEditt});

  // final List<Student> studentsList;

  final Student? initialStudent; // Optional initial student for editing
  final bool? isEditt;

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
  Uint8List? _initialImageBytes;

  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  GlobalKey<FormFieldState<String>> newKeyForDropDownButton =
      GlobalKey<FormFieldState<String>>();

  bool _isEdit = false; // Flag to indicate edit mode

  @override
  void initState() {
    super.initState();
    if (widget.initialStudent != null) {
      _isEdit = true;
      // Pre-fill data for editing
      nameController.text = widget.initialStudent!.name ?? '';
      placeController.text = widget.initialStudent!.place ?? '';
      selectedGender = widget.initialStudent!.gender;
      _selectedDob = widget.initialStudent!.dob ?? '';
      _selectedAge = widget.initialStudent!.age;
      _initialImageBytes = widget.initialStudent!.profilePic;
    }
  }

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

  Future<void> _updateStudent(Student student) async {
    await StudentService.editStudentDetails(student);
  }

  void _handleSubmit() {
    Student student = Student(
      name: nameController.text,
      place: placeController.text,
      gender: selectedGender,
      dob: _selectedDob,
      age: _selectedAge,
      profilePic: _imageBytes,
    );

    //addStudent(student);

    if (_isEdit) {
      student.id = widget.initialStudent!.id;
      print('debug check1111');
      print('syudent id is ${student.id}');
      _updateStudent(student);
      // addStudent(student);
    } else {
      addStudent(student);
    }

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
      appBar: AppBar(title: Text(_isEdit ? 'Edit Student' : 'Add Students')),
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
                  value: _isEdit ? widget.initialStudent!.gender : null,
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
                  initialDateSaved: _isEdit
                      ? _selectedDob
                      : null, // Pass date only in edit mode
                  initialAgeSaved: _isEdit
                      ? _selectedAge
                      : null, // Pass age only in edit mode
                ),
                const SizedBox(
                  height: 26,
                ),
                ImageUpload(
                  //  forClearImage: forClearImage2,
                  onSelectImage: handleImageSelected,
                  initialImageBytes: _isEdit ? _initialImageBytes : null,
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

                      _isEdit
                          ? Navigator.of(context).pop()
                          : Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => AddStudentsScreen()));
                      _handleSubmit();
                      // _formKey.currentState!.reset(); // Reset the form

                      // _autovalidationflag = false;
                    }
                  },
                  child: Text(_isEdit ? 'Update' : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





/*
import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:sample_student_record_using_sqflite/db/database_helper.dart';
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
*/