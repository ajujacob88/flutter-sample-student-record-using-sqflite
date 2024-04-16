import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/models/student_data.dart';
import 'package:sample_student_record_using_sqflite/screens/view_students_details_screen.dart';
import 'package:sample_student_record_using_sqflite/db/database_helper.dart';

class ViewStudentsListScreen extends StatefulWidget {
  const ViewStudentsListScreen({super.key});

  @override
  State<ViewStudentsListScreen> createState() => _ViewStudentsListScreenState();
}

class _ViewStudentsListScreenState extends State<ViewStudentsListScreen> {
  // String _searchText = ''; // New state variable for search text

  //final List<Student> studentsList;
  bool _isLoading = false; // New state variable

  final DatabaseHelperr databaseHelper = DatabaseHelperr();
  late List<Student> studentsList = [];

  Future<void> fetchStudents() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      final students = await databaseHelper.getAllStudents();
      setState(() {
        studentsList = students;
        _isLoading = false; // Set loading state to false after fetching
      });
    } catch (error) {
      // print('Error fetching students: $error');
      // Display an error message to the user (e.g., using a SnackBar)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while fetching students.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    //print('st list is $studentsList ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MyCustomSearchDelegate(studentsList),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show progress indicator while loading
          : studentsList.isEmpty
              ? const Center(
                  child: Text(
                      'List is empty')) // Show "List is empty" if no students found

              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: studentsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(studentsList[index].name!),
                        subtitle: Text(studentsList[index].place!),
                        leading: studentsList[index].profilePic != null
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(
                                                  studentsList[index]
                                                      .profilePic!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: MemoryImage(
                                        studentsList[index].profilePic!)),
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
                                    studentDetail: studentsList[index],
                                  )),
                            ),
                          );
                        });
                  },
                ),
    );
  }
}

class MyCustomSearchDelegate extends SearchDelegate<List<Student>> {
  MyCustomSearchDelegate(this.studentsList);

  final List<Student> studentsList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search text
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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

    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(filteredStudents[index].name!),
            subtitle: Text(filteredStudents[index].place!),
            leading: filteredStudents[index].profilePic != null
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(
                                      filteredStudents[index].profilePic!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            MemoryImage(filteredStudents[index].profilePic!)),
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
                        studentDetail: filteredStudents[index],
                      )),
                ),
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // // Implement logic to display suggestions based on search text (optional)
    // return const Center(
    //   child: Text('Search suggestions'),
    // );

    final suggestedStudents = query.isEmpty
        ? studentsList
        : studentsList
            .where((student) =>
                student.name!.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: suggestedStudents.length,
      itemBuilder: (context, index) {
        // final student = suggestedStudents[index];
        return ListTile(
          title: Text(suggestedStudents[index].name!),
          subtitle: Text(suggestedStudents[index].place!),
          leading: suggestedStudents[index].profilePic != null
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(
                                    suggestedStudents[index].profilePic!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          MemoryImage(suggestedStudents[index].profilePic!)),
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
                      studentDetail: suggestedStudents[index],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
