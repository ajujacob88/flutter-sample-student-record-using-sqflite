import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateAndAgePicker extends StatefulWidget {
  const CustomDateAndAgePicker({
    super.key,
    required this.onDateSelected,
    required this.onClear,
    this.initialDateSaved,
    this.initialAgeSaved,
  });

  final Function(String dob, int age) onDateSelected;

  final Function(
    TextEditingController dobControl,
    TextEditingController ageControl,
  ) onClear;

  final String? initialDateSaved; //  parameter for pre-selected date
  final int? initialAgeSaved; //  parameter for pre-selected age

  @override
  State<CustomDateAndAgePicker> createState() => _CustomDateAndAgePickerState();
}

class _CustomDateAndAgePickerState extends State<CustomDateAndAgePicker> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  late DateTime selectedDate;
  int age = 0;

  @override
  void initState() {
    super.initState();
    // Check for initial values and pre-fill if available
    if (widget.initialDateSaved != null) {
      // Parse initial date string
      // print('debug checkkkk before parsing ${widget.initialDateSaved!}');
      // selectedDate = DateTime.parse(widget.initialDateSaved!);

      // Specify your expected format
      final DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime? parsedDate;
      try {
        parsedDate = format.parse(widget.initialDateSaved!);
      } catch (e) {
        // Handle parsing exception (optional)
        print("Error parsing date: $e");
        selectedDate = DateTime.now();
      }

      if (parsedDate != null) {
        selectedDate = parsedDate;
        // ... rest of your code
      } else {
        // Handle cases where parsing fails (optional)
        print("Error parsing date: ");
        selectedDate = DateTime.now();
      }

      //  print('debug checkkkk after pasrsing ${selectedDate}');
      dobController.text = widget.initialDateSaved!;
      calculateAge(selectedDate); // Calculate age based on initial date
    } else {
      selectedDate = DateTime.now();
    }
  }

  void calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    age = now.year -
        birthDate.year -
        ((now.month > birthDate.month ||
                (now.month == birthDate.month && now.day >= birthDate.day))
            ? 0
            : 1);
    ageController.text = age.toString();
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
        selectedDate = picked;
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
        calculateAge(selectedDate);
        widget.onDateSelected(DateFormat('dd-MM-yyyy').format(picked), age);
        widget.onClear(dobController, ageController);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the date of birth';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
    );
  }
}
