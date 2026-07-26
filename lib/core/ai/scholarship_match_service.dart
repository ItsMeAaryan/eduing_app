import 'models/user_profile.dart';

class Scholarship {
  final String name;
  final double maxIncome;
  final double minPercentage;
  final List<String> eligibleCategories;
  final String targetCourse;
  final String genderEligibility; // "Any", "Female", "Male"

  const Scholarship({
    required this.name,
    required this.maxIncome,
    required this.minPercentage,
    required this.eligibleCategories,
    required this.targetCourse,
    required this.genderEligibility,
  });
}

class ScholarshipMatchService {
  int computeScholarshipMatch(UserProfile profile, Scholarship scholarship, double familyIncome, String gender, String intendedCourse) {
    int score = 0;

    // 1. Income eligibility (max 30)
    if (familyIncome <= scholarship.maxIncome) {
      score += 30;
    }

    // 2. Academic score match (max 25)
    if (profile.percentage >= scholarship.minPercentage) {
      score += 25;
    } else if (profile.percentage >= scholarship.minPercentage - 5) {
      score += 10;
    }

    // 3. Category match (max 20)
    if (scholarship.eligibleCategories.contains('All') || 
        scholarship.eligibleCategories.contains(profile.category)) {
      score += 20;
    }

    // 4. Course match (max 15)
    if (scholarship.targetCourse == 'Any' || 
        scholarship.targetCourse.toLowerCase() == intendedCourse.toLowerCase()) {
      score += 15;
    }

    // 5. Gender eligibility (max 10)
    if (scholarship.genderEligibility == 'Any' || 
        scholarship.genderEligibility.toLowerCase() == gender.toLowerCase()) {
      score += 10;
    }

    return score.clamp(0, 100);
  }
}
