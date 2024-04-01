import 'package:flutter/material.dart';

class AddStudentsScreen extends StatelessWidget {
  AddStudentsScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Upload Profile Picture'),
            ),
            const SizedBox(
              height: 16,
            ),
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
                items: ['Male', 'Female', 'Other']
                    .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) {
                  selectedGender = value.toString();
                })
          ],
        ),
      ),
    );
  }
}
