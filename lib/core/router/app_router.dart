import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/universities/screens/compare_universities_screen.dart';
import '../../features/universities/screens/universities_screen.dart';
import '../../features/universities/screens/university_details_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../features/applications/screens/application_details_screen.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/documents/screens/document_preview_screen.dart';
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
import '../../features/copilot/screens/copilot_home_screen.dart';
import '../../features/copilot/screens/chat_screen.dart';
import '../../features/copilot/screens/copilot_settings_screen.dart';
import '../../features/planner/screens/planner_dashboard_screen.dart';
import '../../features/profile/screens/profile_dashboard_screen.dart';
import '../../features/settings/screens/settings_dashboard_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../shared/widgets/main_layout.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
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
            path: '/ai',
            builder: (context, state) => const CopilotHomeScreen(),
          ),
          GoRoute(
            path: '/ai/chat',
            builder: (context, state) => const CopilotChatScreen(),
          ),
          GoRoute(
            path: '/ai/settings',
            builder: (context, state) => const CopilotSettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileDashboardScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsDashboardScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerDashboardScreen(),
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
