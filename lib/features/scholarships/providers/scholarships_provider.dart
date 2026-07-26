import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scholarship_model.dart';

final scholarshipsProvider =
    NotifierProvider<ScholarshipsNotifier, ScholarshipDashboardData>(() {
  return ScholarshipsNotifier();
});

class ScholarshipsNotifier extends Notifier<ScholarshipDashboardData> {
  @override
  ScholarshipDashboardData build() {
    return _initialData();
  }

  static ScholarshipDashboardData _initialData() {
    return const ScholarshipDashboardData(
      totalAvailable: 124,
      savedCount: 3,
      appliedCount: 1,
      upcomingDeadlines: 2,
      estimatedFunding: '\$45,000',
      scholarships: [
        Scholarship(
          id: 'schol_1',
          name: 'Global Excellence Scholarship',
          organization: 'Stanford University',
          logoUrl: 'https://via.placeholder.com/150',
          fundingAmount: '\$50,000 / year',
          coverage: 'Full Tuition',
          deadline: '15 Nov 2025',
          country: 'USA',
          degree: 'Bachelors',
          description:
              'Awarded to top international students demonstrating exceptional academic merit and leadership potential.',
          benefits: [
            'Full tuition coverage',
            'Mentorship program',
            'Networking events'
          ],
          coveredExpenses: ['Tuition', 'Health Insurance'],
          requiredDocuments: ['SOP', '2 LORs', 'Academic Transcripts'],
          selectionProcess: 'Initial screening followed by an interview round.',
          pastStatistics: 'Acceptance Rate: 2.5%\nAverage GPA: 3.9/4.0',
          aiMatchScore: 92,
          difficulty: 'High',
          isSaved: true,
          eligibilityAnalysis: AIEligibilityAnalysis(
            eligibilityPercentage: 95,
            successProbability: 35,
            fundingScore: 100,
            strengths: ['High GPA', 'Strong Leadership Background'],
            weaknesses: ['Lack of international research'],
            requiredImprovements: ['Publish a research paper before applying'],
          ),
        ),
        Scholarship(
          id: 'schol_2',
          name: 'STEM Innovators Grant',
          organization: 'Tech Foundation',
          logoUrl: 'https://via.placeholder.com/150',
          fundingAmount: '\$15,000',
          coverage: 'Partial',
          deadline: '30 Dec 2025',
          country: 'Global',
          degree: 'Bachelors',
          description:
              'Aimed at students pursuing degrees in Science, Technology, Engineering, or Mathematics with innovative project portfolios.',
          benefits: ['One-time grant', 'Access to exclusive tech workshops'],
          coveredExpenses: ['Equipment', 'Partial Tuition'],
          requiredDocuments: ['Project Portfolio', 'Resume', 'SOP'],
          selectionProcess: 'Portfolio review by industry experts.',
          pastStatistics: 'Acceptance Rate: 15%',
          aiMatchScore: 88,
          difficulty: 'Medium',
          isSaved: false,
          eligibilityAnalysis: AIEligibilityAnalysis(
            eligibilityPercentage: 100,
            successProbability: 60,
            fundingScore: 60,
            strengths: ['Excellent Project Portfolio', 'CS Major'],
            weaknesses: ['Need clearer long-term vision in SOP'],
            requiredImprovements: [
              'Revise SOP to focus on community impact of projects'
            ],
          ),
        ),
      ],
      fundingRecommendations: [
        AIFundingRecommendation(
          id: 'rec_1',
          type: 'Highest ROI',
          scholarshipName: 'Global Excellence Scholarship',
          reasoning:
              'Matches your top-tier academic profile and covers full tuition.',
          estimatedSavings: '\$200,000 over 4 years',
          priority: 'High',
        ),
        AIFundingRecommendation(
          id: 'rec_2',
          type: 'Safest Option',
          scholarshipName: 'STEM Innovators Grant',
          reasoning: 'Your project portfolio makes you highly competitive.',
          estimatedSavings: '\$15,000',
          priority: 'Medium',
        ),
      ],
    );
  }

  void toggleSaveStatus(String id) {
    final updatedScholarships = state.scholarships.map((s) {
      if (s.id == id) {
        return Scholarship(
          id: s.id,
          name: s.name,
          organization: s.organization,
          logoUrl: s.logoUrl,
          fundingAmount: s.fundingAmount,
          coverage: s.coverage,
          deadline: s.deadline,
          country: s.country,
          degree: s.degree,
          description: s.description,
          benefits: s.benefits,
          coveredExpenses: s.coveredExpenses,
          requiredDocuments: s.requiredDocuments,
          selectionProcess: s.selectionProcess,
          pastStatistics: s.pastStatistics,
          aiMatchScore: s.aiMatchScore,
          difficulty: s.difficulty,
          eligibilityAnalysis: s.eligibilityAnalysis,
          isSaved: !s.isSaved,
          isApplied: s.isApplied,
        );
      }
      return s;
    }).toList();

    state = ScholarshipDashboardData(
      totalAvailable: state.totalAvailable,
      savedCount: updatedScholarships.where((s) => s.isSaved).length,
      appliedCount: state.appliedCount,
      upcomingDeadlines: state.upcomingDeadlines,
      estimatedFunding: state.estimatedFunding,
      scholarships: updatedScholarships,
      fundingRecommendations: state.fundingRecommendations,
    );
  }
}
