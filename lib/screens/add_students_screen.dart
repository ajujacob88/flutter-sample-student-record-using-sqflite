import 'package:flutter/material.dart';

//import 'dart:io';
import 'package:sample_student_record_using_sqflite/widgets/custom_date_and _age_picker.dart';
import 'package:sample_student_record_using_sqflite/widgets/image_upload.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  String? selectedGender;

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
                decoration: const InputDecoration(labelText: 'Name'),
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
                    selectedGender = value.toString();
                  }),
              const SizedBox(
                height: 16,
              ),
              const CustomDateAndAgePicker(),
              const SizedBox(
                height: 26,
              ),
              const ImageUpload(),
              const SizedBox(
                height: 26,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
