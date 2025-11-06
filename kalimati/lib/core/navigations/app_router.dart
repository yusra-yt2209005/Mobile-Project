import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/flashcards_screen.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/game_selection_screen.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/match_word_definition_screen.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/unscramble_words_screen.dart';
import 'package:kalimati/features/dashboard/domain/entities/user.dart';
import 'package:kalimati/features/dashboard/presentation/screens/teacher/teacher_profile_screen.dart';

// Screens
import '../../features/dashboard/presentation/screens/home/home_screen.dart';
import '../../features/dashboard/presentation/screens/teacher/login_screen.dart';
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

      GoRoute(
        name: Routes.teacherProfile,
        path: '/teacher/profile',
        builder: (context, state) {
          // Receive the User object via extra
          final user = state.extra as User;
          return TeacherProfileScreen(user: user);
        },
      ),

      //students
      GoRoute(
        name: Routes.studentHomePage,
        path: '/student',
        builder: (context, state) => const StudentHomePage(),
      ),

      // games selection screen- shows games for selected learning package
      GoRoute(
        name: Routes.gameSelectionScreen,
        path: '/student/package/games',
        builder: (context, state) {
          final title = (state.extra as String?) ?? '';
          return GameSelectionScreen(packageTitle: title);
        },
      ),

      // ------------- STUDENT GAMES -------------
      GoRoute(
        name: Routes.flashcards,
        path: '/student/games/flashcards',
        builder: (context, state) {
          final title = (state.extra as String?) ?? '';
          return FlashCardsScreen(packageTitle: title);
        },
      ),
      GoRoute(
        name: Routes.unscramble,
        path: '/student/games/unscramble',
        builder: (context, state) {
          final title = (state.extra as String?) ?? '';
          return UnscrambleWordsScreen(packageTitle: title);
        },
      ),
      GoRoute(
        name: Routes.match,
        path: '/student/games/match',
        builder: (context, state) {
          final title = (state.extra as String?) ?? '';
          return MatchWordDefinitionScreen(packageTitle: title);
        },
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
  static const teacherProfile = 'teacher-profile';

  static const studentHomePage = 'student-home-page';
  static const gameSelectionScreen = 'game-selection-screen';
  static const flashcards = 'flashcards';
  static const unscramble = 'unscramble';
  static const match = 'match';
}
