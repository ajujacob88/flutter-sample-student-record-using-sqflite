import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/utils/helper_functions.dart';

class StudentSearchDelegate extends SearchDelegate<List<Student>> {
  StudentSearchDelegate(this.studentsList);

  final List<Student> studentsList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search text
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, studentsList); // Return to main list on back press
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement logic to filter studentsList based on _searchText
    final filteredStudents = studentsList
        .where((student) =>
            student.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredStudents.isEmpty) {
      return Center(
        child: Text('No students found for "$query"'),
      );
    }
    return _buildStudentListView(filteredStudents);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedStudents = query.isEmpty
        ? studentsList
        : studentsList
            .where((student) =>
                student.name!.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return _buildStudentListView(suggestedStudents);
  }

  Widget _buildStudentListView(List<Student> students) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: students.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(students[index].name!),
            subtitle: Text(students[index].place!),
            leading: students[index].profilePic != null
                ? GestureDetector(
                    onTap: () {
                      showProfilePictureDialog(
                          context, students[index].profilePic!);
                    },
                    child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            MemoryImage(students[index].profilePic!)),
                  )
                : const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.account_circle_rounded),
                    // Adjust the radius as needed
                  ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => ViewStudentsDetailsScreen(
                        studentDetail: students[index],
                      )),
                ),
              );
            });
      },
    );
  }
}
