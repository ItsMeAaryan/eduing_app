import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sop_model.dart';

final sopProvider = StateNotifierProvider<SopNotifier, UserSop>((ref) {
  return SopNotifier();
});

class SopNotifier extends StateNotifier<UserSop> {
  SopNotifier() : super(_initialData());

  static UserSop _initialData() {
    return const UserSop(
      id: 'sop_1',
      universityName: 'Stanford University Variant',
      lastUpdated: '10 mins ago',
      completionPercentage: 0.75,
      wordCount: 850,
      paragraphCount: 6,
      estimatedReadingTimeMinutes: 4,
      aiSopScore: 82,
      sections: [
        SopSection(title: 'Introduction', isCompleted: true, content: 'Ever since I was young...'),
        SopSection(title: 'Academic Background', isCompleted: true, content: 'During my undergraduate studies...'),
        SopSection(title: 'Projects', isCompleted: true, content: 'I developed several applications...'),
        SopSection(title: 'Research', isCompleted: false, content: ''),
        SopSection(title: 'Career Goals', isCompleted: true, content: 'My ultimate goal is...'),
        SopSection(title: 'Why This University', isCompleted: true, content: 'Stanford offers...'),
        SopSection(title: 'Why This Course', isCompleted: false, content: ''),
        SopSection(title: 'Leadership', isCompleted: false, content: ''),
        SopSection(title: 'Achievements', isCompleted: true, content: 'I won the national coding competition...'),
        SopSection(title: 'Conclusion', isCompleted: false, content: ''),
      ],
      review: AISopReview(
        overallScore: 82,
        grammar: 95,
        clarity: 88,
        structure: 80,
        storytelling: 75,
        originality: 82,
        researchDepth: 60,
        goalAlignment: 90,
        universityAlignment: 85,
        professionalTone: 88,
        recommendations: [
          AISopRecommendation(text: 'Strengthen your introduction to hook the reader immediately.', priority: 'High', estimatedImprovement: '+5% Storytelling', isCompleted: false),
          AISopRecommendation(text: 'Expand research experience with concrete outcomes.', priority: 'Medium', estimatedImprovement: '+10% Research Depth', isCompleted: false),
          AISopRecommendation(text: 'Highlight leadership impact in your academic clubs.', priority: 'Medium', estimatedImprovement: '+8% Leadership', isCompleted: false),
          AISopRecommendation(text: 'Reduce repetitive phrases in the Projects section.', priority: 'Low', estimatedImprovement: '+2% Clarity', isCompleted: true),
        ],
        strengths: [
          'Clear career vision and goal alignment.',
          'Strong academics detailed well.',
          'Excellent project portfolio.',
          'Professional tone maintained throughout.',
        ],
      ),
    );
  }
}
