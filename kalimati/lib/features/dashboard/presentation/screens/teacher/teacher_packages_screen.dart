// contains teacher profile + list of their created packages
import 'package:flutter/material.dart';

class TeacherPackagesScreen extends StatelessWidget {
  const TeacherPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Packages')),
      body: const Center(child: Text('Profile and packages will appear here')),
    );
  }
}
