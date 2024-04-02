import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;

  late DateTime selectedDate;
  int age = 0;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        //dobController.text = picked.toString(); // Display selected date
        dobController.text = DateFormat('dd-MM-yyyy')
            .format(picked); // Display selected date in dd-MM-yyyy format
      });
    }

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Calculate age
        final now = DateTime.now();
        age = now.year -
            picked.year -
            ((now.month > picked.month ||
                    (now.month == picked.month && now.day >= picked.day))
                ? 0
                : 1);

        ageController.text = age.toString();
      });
    }
  }

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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: TextFormField(
                      readOnly: true,
                      controller: dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
