import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Add Details'),
          ),
          const SizedBox(
            width: 26,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Details'),
          )
        ],
      )),
    );
  }
}
