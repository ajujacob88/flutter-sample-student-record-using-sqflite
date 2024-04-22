import 'package:flutter/material.dart';
import 'package:sample_student_record_using_sqflite/screens/home_screen.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// final theme = ThemeData(
//   primaryColor: Color.fromARGB(255, 37, 180, 1),
//   textTheme: GoogleFonts.luxuriousRomanTextTheme(),
// );

// final theme = ThemeData(
//   primaryColor: Colors.blue,
//   textTheme: GoogleFonts.poppinsTextTheme().apply(
//     bodyColor: Colors.black, // Change this to your desired text color
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       textStyle: TextStyle(
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         fontSize: 16, // Example font size
//       ),
//     ),
//   ),
// );

// final theme = ThemeData(
//   colorScheme: ColorScheme.fromSeed(
//     brightness: Brightness.dark,
//     seedColor: Colors.black,
//   ),
//   fontFamily: 'Roboto',
// );

final selectedTheme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(16, 71, 1, 83),
    // Set your desired app bar color here
    // titleTextStyle: TextStyle(color: Colors.white),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Student Record App',
      // theme: selectedTheme.copyWith(
      //   appBarTheme: selectedTheme.appBarTheme.copyWith(
      //     titleTextStyle:
      //         TextStyle(color: const Color.fromARGB(255, 243, 201, 33)),
      //   ),
      // ),
      theme: selectedTheme,
      home: const HomeScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const HomeScreen(),
      //   '/addDetails': (context) => const AddStudentsScreen(),
      //   //'/viewDetails': (context) => const ViewDetailsScreen(),
      // },
    );
  }
}
