class Student {
  String? name;
  String? place;
  String? gender;
  String? dob;
  int? age;
  String? imagePath;

  Student({
    required this.name,
    required this.place,
    required this.gender,
    required this.dob,
    required this.age,
    this.imagePath,
  });
}
