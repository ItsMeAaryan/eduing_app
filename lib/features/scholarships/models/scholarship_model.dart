class Scholarship {
  final String id;
  final String name;
  final String organization;
  final String logoUrl;
  final String fundingAmount;
  final String coverage; // e.g. "Full Tuition", "Partial", "Living Expenses"
  final String deadline;
  final String country;
  final String degree; // e.g. "Bachelors", "Masters", "PhD"
  final String description;
  final List<String> benefits;
  final List<String> coveredExpenses;
  final List<String> requiredDocuments;
  final String selectionProcess;
  final String pastStatistics;
  final int aiMatchScore;
  final String difficulty; // e.g. "High", "Medium", "Low"
  final AIEligibilityAnalysis eligibilityAnalysis;
  final bool isSaved;
  final bool isApplied;

  const Scholarship({
    required this.id,
    required this.name,
    required this.organization,
    required this.logoUrl,
    required this.fundingAmount,
    required this.coverage,
    required this.deadline,
    required this.country,
    required this.degree,
    required this.description,
    required this.benefits,
    required this.coveredExpenses,
    required this.requiredDocuments,
    required this.selectionProcess,
    required this.pastStatistics,
    required this.aiMatchScore,
    required this.difficulty,
    required this.eligibilityAnalysis,
    this.isSaved = false,
    this.isApplied = false,
  });
}

class AIEligibilityAnalysis {
  final int eligibilityPercentage;
  final int successProbability;
  final int fundingScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> requiredImprovements;

  const AIEligibilityAnalysis({
    required this.eligibilityPercentage,
    required this.successProbability,
    required this.fundingScore,
    required this.strengths,
    required this.weaknesses,
    required this.requiredImprovements,
  });
}

class ScholarshipDashboardData {
  final int totalAvailable;
  final int savedCount;
  final int appliedCount;
  final int upcomingDeadlines;
  final String estimatedFunding;
  final List<Scholarship> scholarships;
  final List<AIFundingRecommendation> fundingRecommendations;

  const ScholarshipDashboardData({
    required this.totalAvailable,
    required this.savedCount,
    required this.appliedCount,
    required this.upcomingDeadlines,
    required this.estimatedFunding,
    required this.scholarships,
    required this.fundingRecommendations,
  });
}

class AIFundingRecommendation {
  final String id;
  final String type; // e.g. "Highest ROI", "Best Match", "Safest Option"
  final String scholarshipName;
  final String reasoning;
  final String estimatedSavings;
  final String priority;

  const AIFundingRecommendation({
    required this.id,
    required this.type,
    required this.scholarshipName,
    required this.reasoning,
    required this.estimatedSavings,
    required this.priority,
  });
}
