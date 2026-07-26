import 'models/user_profile.dart';

class Course {
  final String name;
  final double required12thPercentage;
  final double jeeCutoffRank; // using percentile as proxy for rank simplicity

  const Course({
    required this.name,
    required this.required12thPercentage,
    required this.jeeCutoffRank,
  });
}

class UniversityMatchService {
  int computeMatchScore(UserProfile profile, dynamic university, Course course) {
    // Scoring (0-100)
    int score = 0;

    // 1. Eligibility met (max 40)
    bool isEligible = true;
    if (profile.percentage < course.required12thPercentage) {
      isEligible = false;
    }
    
    if (!isEligible) {
      return 0; // if not eligible -> 0 overall
    }
    score += 40;

    // 2. JEE rank vs cutoff closeness (max 30)
    // Here we use percentile directly instead of rank for calculation simplicity
    // A higher percentile is better, cutoff percentile is minimum required.
    double difference = profile.jeePercentile - course.jeeCutoffRank;
    if (difference >= 0) {
      score += 30; // Exceeds or meets cutoff
    } else {
      // If below cutoff, check how close it is (percentage diff)
      double percentDiff = (difference.abs() / course.jeeCutoffRank) * 100;
      if (percentDiff <= 10) {
        score += 30;
      } else if (percentDiff <= 25) {
        score += 20;
      } else if (percentDiff <= 50) {
        score += 10;
      }
    }

    // 3. 12th % vs requirement (max 15)
    double percDiff = profile.percentage - course.required12thPercentage;
    if (percDiff >= 10) {
      score += 15;
    } else if (percDiff >= 5) {
      score += 10;
    } else if (percDiff >= 0) {
      score += 5;
    }

    // 4. Category seat availability (max 10)
    // Assuming some stub logic based on category
    if (profile.category != 'General') {
      score += 10; // Extra points if category seats available
    } else {
      score += 5;
    }

    // 5. Preference match (max 5)
    // Stub preference match
    score += 5;

    return score.clamp(0, 100);
  }
}
