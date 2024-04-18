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
      selectedDate =
          DateTime.parse(widget.initialDateSaved!); // Parse initial date string
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
    print(
        'debug check 111 current dat is ${widget.initialDateSaved}, age is ${widget.initialAgeSaved}');
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
/*
    if (picked != null) {
      setState(() {
        //dobController.text = picked.toString(); // Display selected date
        dobController.text = DateFormat('dd-MM-yyyy')
            .format(picked); // Display selected date in dd-MM-yyyy format
      });
    }

    if (picked != null && picked != selectedDate) {
      setState(
        () {
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
          // widget.onDateSelected(selectedDate.toString(), age);

          widget.onDateSelected(DateFormat('dd-MM-yyyy').format(picked), age);
          widget.onClear(dobController, ageController);
        },
      );
    }*/
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
                //   initialValue: widget.initialDateSaved,
                //initialValue: 'gh',
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
            //initialValue: widget.initialAgeSaved.toString(),
            // initialValue: '50',
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



/*
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
    selectedDate = DateTime.now();
  }

  void _selectDate(BuildContext context) async {
    print(
        'debug check 111 current dat is ${widget.initialDateSaved}, age is ${widget.initialAgeSaved}');
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
      setState(
        () {
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
          // widget.onDateSelected(selectedDate.toString(), age);

          widget.onDateSelected(DateFormat('dd-MM-yyyy').format(picked), age);
          widget.onClear(dobController, ageController);
        },
      );
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
                //    initialValue: widget.initialDate2,
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
            initialValue: widget.initialAgeSaved.toString(),
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
*/