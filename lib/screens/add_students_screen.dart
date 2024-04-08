import 'dart:typed_data';

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

  // void forClearImage2(Function clearimg) {
  //   print('debug clling this clearIMG');
  //   clr = clearimg;
  //   print('clr is $clr');
  // }

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
        age: _selectedAge,
        imagePath: _imageBytes);

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
        'Student: $student, name = ${student.name}, dob= ${student.dob}, ${student.gender}, ${student.age}, ${student.imagePath}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 10),
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
                key: newKeyForDropDownButton,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .dividerColor), // Optional colored border on focus
                  ),
                ),
                hint: const Text(
                  'Select Gender',
                  style: TextStyle(
                    fontWeight: FontWeight.normal, // Match the font weight
                  ),
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
    );
  }
}
