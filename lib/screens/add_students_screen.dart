import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController imageController = TextEditingController();
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

  // Future<void> _uploadImage() async {

  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       imageController.text = pickedFile.path;
  //     });
  //   }
  // }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select image source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: const Text('Take Photo'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageController.text = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: Padding(
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      TextFormField(
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
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      // floatingLabelBehavior: FloatingLabelBehavior.never
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: imageController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Profile Pic',
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: OutlinedButton(
                    onPressed: _showImageSourceDialog,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the border radius here
                        ),
                      ),
                      side: const MaterialStatePropertyAll(
                        BorderSide(color: Color.fromARGB(255, 180, 177, 177)),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 125, 124, 124)),
                    ),
                    child: const Text('Upload'),
                  ),
                ),
                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: _uploadImage,
                //     child: const Text('Upload'),
                //   ),
                // ),
              ],
            ),
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
    );
  }
}
