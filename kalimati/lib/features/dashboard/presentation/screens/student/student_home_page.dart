// contains list of all learning packages for all students
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  // this is temporary so no errors show up ; change later!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Packages')),
      body: const Center(
        child: Text('List of learning packages will appear here'),
      ),
    );
  }
}
