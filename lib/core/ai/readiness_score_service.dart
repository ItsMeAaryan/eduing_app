import 'models/user_profile.dart';

class ReadinessResult {
  final int overallScore;
  final Map<String, int> breakdown;
  final List<String> weakAreas;
  final List<String> strongAreas;
  final String nextAction;

  const ReadinessResult({
    required this.overallScore,
    required this.breakdown,
    required this.weakAreas,
    required this.strongAreas,
    required this.nextAction,
  });
}

class ReadinessScoreService {
  Future<ReadinessResult> computeReadinessScore(UserProfile profile) async {
    int score = 0;
    final breakdown = <String, int>{};
    final weakAreas = <String>[];
    final strongAreas = <String>[];

    // 1. Profile Completeness (max 20)
    int profileScore = 0;
    if (profile.name.isNotEmpty) { profileScore += 4; }
    if (profile.email.isNotEmpty) { profileScore += 4; }
    if (profile.phone.isNotEmpty) { profileScore += 4; }
    if (profile.address.isNotEmpty) { profileScore += 4; }
    if (profile.guardian.isNotEmpty) { profileScore += 4; }
    score += profileScore;
    breakdown['profile_completeness'] = profileScore;
    if (profileScore < 20) {
      weakAreas.add('Incomplete Profile Information');
    } else {
      strongAreas.add('Complete Profile');
    }

    // 2. Academic Info (max 20)
    int academicScore = 0;
    if (profile.board.isNotEmpty) { academicScore += 5; }
    if (profile.percentage >= 60) {
      academicScore += 10;
    } else if (profile.percentage > 0) {
      academicScore += 5;
    }
    if (profile.graduationYear > 2000) { academicScore += 5; }
    score += academicScore;
    breakdown['academic_info'] = academicScore;
    if (academicScore < 15) {
      weakAreas.add('Academic Information');
    } else {
      strongAreas.add('Academic Records');
    }

    // 3. Entrance Exams (max 25)
    int examsScore = 0;
    if (profile.entranceExams.length == 1) {
      examsScore = 15;
    } else if (profile.entranceExams.length > 1) {
      examsScore = 25;
    }
    score += examsScore;
    breakdown['entrance_exams'] = examsScore;
    if (examsScore == 0) {
      weakAreas.add('No Entrance Exams Registered');
    } else {
      strongAreas.add('Entrance Exams');
    }

    // 4. Documents (max 25)
    int docsScore = (profile.verifiedDocuments.length * 5).clamp(0, 25);
    score += docsScore;
    breakdown['documents'] = docsScore;
    if (docsScore < 15) {
      weakAreas.add('Missing Verified Documents');
    } else {
      strongAreas.add('Verified Documents');
    }

    // 5. Applications Started (max 10)
    int appsScore = 0;
    if (profile.applicationsStarted == 1) {
      appsScore = 5;
    } else if (profile.applicationsStarted > 1) {
      appsScore = 10;
    }
    score += appsScore;
    breakdown['applications_started'] = appsScore;
    if (appsScore == 0) {
      weakAreas.add('No Applications Started');
    }

    String nextAction = 'Complete your profile';
    if (profileScore == 20) {
      if (docsScore < 15) {
        nextAction = 'Upload required documents';
      } else if (examsScore == 0) {
        nextAction = 'Register for entrance exams';
      } else if (appsScore == 0) {
        nextAction = 'Start your first application';
      } else {
        nextAction = 'Track your applications';
      }
    }

    return ReadinessResult(
      overallScore: score.clamp(0, 100),
      breakdown: breakdown,
      weakAreas: weakAreas,
      strongAreas: strongAreas,
      nextAction: nextAction,
    );
  }
}
