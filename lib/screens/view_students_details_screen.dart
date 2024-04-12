import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';

class ViewStudentsDetailsScreen extends StatelessWidget {
  const ViewStudentsDetailsScreen({super.key, required this.studentDetail});

  final Student studentDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studentDetail.name ?? 'Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (studentDetail.profilePic != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(studentDetail.profilePic!),
                ),
              ),
            const SizedBox(height: 20),
            Text('Name: ${studentDetail.name ?? 'N/A'}'),
            Text('Place: ${studentDetail.place ?? 'N/A'}'),
            Text('Gender: ${studentDetail.gender ?? 'N/A'}'),
            Text('Date of Birth: ${studentDetail.dob ?? 'N/A'}'),
            Text('Age: ${studentDetail.age ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
