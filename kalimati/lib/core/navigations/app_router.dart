import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../features/dashboard/presentation/screens/home/home_screen.dart';
import '../../features/dashboard/presentation/screens/teacher/login_screen.dart';
import '../../features/dashboard/presentation/screens/teacher/teacher_packages_screen.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/student_home_page.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: false,
    initialLocation: '/',
    routes: [
      // Home
      GoRoute(
        name: Routes.home,
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // Teacher login
      GoRoute(
        name: Routes.teacherLogin,
        path: '/teacher/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Teacher packages screen - the teacher dashboard (teacher profile+packages)
      GoRoute(
        name: Routes.teacherDashboard,
        path: '/teacher',
        builder: (context, state) => const TeacherPackagesScreen(),
      ),

      // Student home screen - shows list of student learning packages
      GoRoute(
        name: Routes.studentHomePage,
        path: '/student',
        builder: (context, state) => const StudentHomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text(state.error.toString())),
    ),
  );
}

abstract class Routes {
  static const home = 'home';
  static const teacherLogin = 'teacher-login';
  static const teacherDashboard = 'teacher-dashboard';
  static const studentHomePage = 'student-home-page';
}
