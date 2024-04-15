import 'dart:typed_data';

class Student {
  // static int _nextId = 1; // Starting ID value

  int? id;
  String? name;
  String? place;
  String? gender;
  String? dob;
  int? age;
  Uint8List? profilePic;

  Student({
    this.id,
    required this.name,
    required this.place,
    required this.gender,
    required this.dob,
    required this.age,
    this.profilePic,
  });
  // }) //: id = _nextId++;

  // Method to convert a Student instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'place': place,
      'gender': gender,
      'dob': dob,
      'age': age,
      'profilePic': profilePic,
    };
  }

  // Additional constructor for creating a Student instance from a map
  Student.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        place = map['place'],
        gender = map['gender'],
        dob = map['dob'],
        age = map['age'],
        profilePic = map['profilePic'];
}




/*
//for databse
// Additional constructor for creating a Student instance from a map
  Student.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        place = map['place'],
        gender = map['gender'],
        dob = map['dob'],
        age = map['age'],
        profilePic = map['profilePic'];

  // Method to convert a Student instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'place': place,
      'gender': gender,
      'dob': dob,
      'age': age,
      'profilePic': profilePic,
    };
  }
}
*/