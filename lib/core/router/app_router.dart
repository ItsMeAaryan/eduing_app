import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/home/screens/dashboard_screen.dart';
import '../../features/discover/screens/discover_screen.dart';
import '../../features/universities/screens/compare_universities_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../features/applications/screens/application_details_screen.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/sop/screens/sop_screen.dart';
import '../../features/sop/screens/sop_preview_screen.dart';
import '../../features/sop/screens/ai_sop_review_screen.dart';
import '../../features/interview/screens/interview_screen.dart';
import '../../features/interview/screens/question_practice_screen.dart';
import '../../features/interview/screens/mock_interview_screen.dart';
import '../../features/interview/screens/interview_report_screen.dart';
import '../../features/interview/models/interview_model.dart';
import '../../features/scholarships/screens/scholarships_screen.dart';
import '../../features/scholarships/screens/scholarship_details_screen.dart';
import '../../features/scholarships/screens/scholarship_comparison_screen.dart';
import '../../features/copilot/screens/copilot_screen.dart';
import '../../features/copilot/screens/copilot_chat_screen.dart';
import '../../features/copilot/screens/copilot_settings_screen.dart';
import '../../features/planner/screens/planner_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/account_screens.dart';
import '../../features/profile/screens/profile_section_screen.dart';
import '../../features/discover/screens/uni_detail_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../shared/widgets/main_layout.dart';
import '../../features/profile/screens/profile_setup_screen.dart';
import '../../features/planner/screens/planner_calendar_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static SharedPreferences? prefs;

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable:
        GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final authRoutes = ['/', '/login', '/register', '/otp', '/onboarding', '/forgot-password'];
      final isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (user == null && !isAuthRoute) {
        // Allow unauthenticated users (guests) to view main app routes
        final mainRoutes = ['/home', '/discover', '/universities', '/applications', '/copilot', '/planner', '/sop', '/profile'];
        if (!mainRoutes.contains(state.matchedLocation) && !state.matchedLocation.startsWith('/application/')) {
          return '/';
        }
      }
      if (user != null && isAuthRoute && state.matchedLocation != '/onboarding') {
        return '/home';
      }
      
      if (state.matchedLocation == '/onboarding') {
        final bool onboardingCompleted = prefs?.getBool('onboarding_completed') ?? false;
        if (onboardingCompleted) {
          return '/home';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OTPScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(
          onNavigateToLogin: () => context.go('/login'),
        ),
      ),
      // Dashboard out of ShellRoute to prevent duplicate bottom nav
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
      // New requested routes for vault, resume, sop
      GoRoute(
        path: '/sop',
        builder: (context, state) => const SOPScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // removed path: '/' since it is now splash out of ShellRoute
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
          GoRoute(
            path: '/universities',
            builder: (context, state) => const DiscoverScreen(), // As requested: /universities -> DiscoverScreen
          ),
          GoRoute(
            path: '/applications',
            builder: (context, state) => const ApplicationsScreen(),
          ),
          GoRoute(
            path: '/application/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ApplicationDetailsScreen(applicationId: id);
            },
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsScreen(),
          ),
          GoRoute(
            path: '/sop/builder',
            builder: (context, state) => const SOPScreen(),
          ),
          GoRoute(
            path: '/sop/preview',
            builder: (context, state) => const SopPreviewScreen(),
          ),
          GoRoute(
            path: '/sop/review',
            builder: (context, state) => const AISopReviewScreen(),
          ),
          GoRoute(
            path: '/interview',
            builder: (context, state) => const InterviewScreen(),
          ),
          GoRoute(
            path: '/interview/practice',
            builder: (context, state) {
              final question = state.extra as InterviewQuestion;
              return QuestionPracticeScreen(question: question);
            },
          ),
          GoRoute(
            path: '/interview/mock',
            builder: (context, state) => const MockInterviewScreen(),
          ),
          GoRoute(
            path: '/interview/report',
            builder: (context, state) => const InterviewReportScreen(),
          ),
          GoRoute(
            path: '/scholarships',
            builder: (context, state) => const ScholarshipsScreen(),
          ),
          GoRoute(
            path: '/scholarships/compare',
            builder: (context, state) => const ScholarshipComparisonScreen(),
          ),
          GoRoute(
            path: '/scholarship/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ScholarshipDetailsScreen(scholarshipId: id);
            },
          ),
          GoRoute(
            path: '/copilot',
            builder: (context, state) => const CopilotScreen(),
          ),
          GoRoute(
            path: '/copilot/chat',
            builder: (context, state) => const CopilotChatScreen(),
          ),
          GoRoute(
            path: '/copilot/settings',
            builder: (context, state) => const CopilotSettingsScreen(),
          ),
          GoRoute(
            path: '/ai',
            redirect: (context, state) => '/copilot',
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile/setup',
            builder: (context, state) => const ProfileSetupScreen(),
          ),
          GoRoute(
            path: '/planner/calendar',
            builder: (context, state) => const PlannerCalendarScreen(),
          ),
          GoRoute(
            path: '/settings',
            redirect: (context, state) => '/settings/notifications',
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerScreen(),
          ),
          GoRoute(
            path: '/profile/:section(personal|academic|guardian|address|exams|category)',
            builder: (context, state) => ProfileSectionScreen(sectionId: state.pathParameters['section']!),
          ),
          GoRoute(
            path: '/settings/security',
            builder: (context, state) => const SecurityScreen(),
          ),
          GoRoute(
            path: '/settings/notifications',
            builder: (context, state) => const NotificationPrefsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/university/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UniDetailScreen(universityId: id);
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
