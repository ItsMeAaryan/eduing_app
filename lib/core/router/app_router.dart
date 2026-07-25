import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/home/screens/dashboard_screen.dart';
import '../../features/discover/screens/discover_screen.dart';
import '../../features/universities/screens/compare_universities_screen.dart';
import '../../features/universities/screens/university_details_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../features/applications/screens/application_details_screen.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/documents/screens/document_preview_screen.dart';
import '../../features/vault/screens/vault_screen.dart';
import '../../features/resume/screens/resume_dashboard_screen.dart';
import '../../features/resume/screens/resume_preview_screen.dart';
import '../../features/resume/screens/ai_resume_review_screen.dart';
import '../../features/sop/screens/sop_dashboard_screen.dart';
import '../../features/sop/screens/sop_preview_screen.dart';
import '../../features/sop/screens/ai_sop_review_screen.dart';
import '../../features/interview/screens/interview_dashboard_screen.dart';
import '../../features/interview/screens/question_practice_screen.dart';
import '../../features/interview/screens/mock_interview_screen.dart';
import '../../features/interview/screens/interview_report_screen.dart';
import '../../features/interview/models/interview_model.dart';
import '../../features/scholarships/screens/scholarships_hub_screen.dart';
import '../../features/scholarships/screens/scholarship_details_screen.dart';
import '../../features/scholarships/screens/scholarship_comparison_screen.dart';
import '../../features/copilot/screens/copilot_screen.dart';
import '../../features/copilot/screens/copilot_chat_screen.dart';
import '../../features/copilot/screens/copilot_settings_screen.dart';
import '../../features/planner/screens/planner_dashboard_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_dashboard_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../shared/widgets/main_layout.dart';

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

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable:
        GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final authRoutes = ['/splash', '/login', '/register', '/otp', '/onboarding', '/forgot-password'];
      final isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (user == null && !isAuthRoute) {
        return '/splash';
      }
      if (user != null && isAuthRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
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
        path: '/vault',
        builder: (context, state) => const VaultScreen(),
      ),
      GoRoute(
        path: '/resume',
        builder: (context, state) => const ResumeDashboardScreen(),
      ),
      GoRoute(
        path: '/sop',
        builder: (context, state) => const SopDashboardScreen(),
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
          GoRoute(
            path: '/',
            redirect: (context, state) => '/home',
          ),
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
            path: '/document/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DocumentPreviewScreen(documentId: id);
            },
          ),
          GoRoute(
            path: '/resume/builder',
            builder: (context, state) => const ResumeDashboardScreen(),
          ),
          GoRoute(
            path: '/resume/preview',
            builder: (context, state) => const ResumePreviewScreen(),
          ),
          GoRoute(
            path: '/resume/review',
            builder: (context, state) => const AIResumeReviewScreen(),
          ),
          GoRoute(
            path: '/sop/builder',
            builder: (context, state) => const SopDashboardScreen(),
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
            builder: (context, state) => const InterviewDashboardScreen(),
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
            builder: (context, state) => const ScholarshipsHubScreen(),
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
            path: '/settings',
            builder: (context, state) => const SettingsDashboardScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerDashboardScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
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
