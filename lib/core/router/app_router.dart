import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/universities/screens/compare_universities_screen.dart';
import '../../features/universities/screens/universities_screen.dart';
import '../../features/universities/screens/university_details_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../shared/widgets/main_layout.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/universities',
            builder: (context, state) => const UniversitiesScreen(),
          ),
          // Add placeholder routes here
          GoRoute(
            path: '/applications',
            builder: (context, state) => const ApplicationsScreen(),
          ),
          GoRoute(
            path: '/ai',
            builder: (context, state) => const PlaceholderScreen(title: 'AI Copilot'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
          ),
        ],
      ),
      GoRoute(
        path: '/university/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UniversityDetailsScreen(universityId: id);
        },
      ),
      GoRoute(
        path: '/compare',
        builder: (context, state) {
          final ids = state.extra as List<String>? ?? ['1', '2'];
          return CompareUniversitiesScreen(universityIds: ids);
        },
      ),
    ],
  );
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}
