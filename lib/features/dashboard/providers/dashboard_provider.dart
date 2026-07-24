import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/dashboard_data.dart';

final userProfileProvider = Provider<UserProfile>((ref) {
  return UserProfile(
    name: 'Aaryan Sharma',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
  );
});

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return DashboardStats(
    applications: 18,
    offersReceived: 2,
    profileStrength: 85,
    scholarships: 6,
  );
});

final upcomingDeadlinesProvider = Provider<List<Deadline>>((ref) {
  return [
    Deadline(
      task: 'Passport Upload',
      date: 'Tomorrow',
      priority: 'Required',
      statusColor: 'error',
    ),
    Deadline(
      task: 'BITS Application',
      date: '22 Jul 2024',
      priority: 'In 2 days',
      statusColor: 'warning',
    ),
    Deadline(
      task: 'Interview Round',
      date: '25 Jul 2024',
      priority: 'In 5 days',
      statusColor: 'success',
    ),
    Deadline(
      task: 'Scholarship Form',
      date: '30 Jul 2024',
      priority: 'In 10 days',
      statusColor: 'info',
    ),
  ];
});

final recentApplicationsProvider = Provider<List<ApplicationStatus>>((ref) {
  return [
    ApplicationStatus(
      university: 'BITS Pilani',
      campus: 'Pilani Campus',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/BITS_Pilani-Logo.svg/1200px-BITS_Pilani-Logo.svg.png',
      aiMatch: 91,
      status: 'Applied',
    ),
    ApplicationStatus(
      university: 'IIT Bombay',
      campus: 'Computer Science',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/IIT_Bombay_logo.svg/1200px-IIT_Bombay_logo.svg.png',
      aiMatch: 89,
      status: 'Pending',
    ),
    ApplicationStatus(
      university: 'Delhi University',
      campus: 'B.Sc. (Hons) CS',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/b/b4/University_of_Delhi_coat_of_arms.svg/1200px-University_of_Delhi_coat_of_arms.svg.png',
      aiMatch: 75,
      status: 'Shortlisted',
    ),
  ];
});
