import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/interview_model.dart';

final interviewProvider = StateNotifierProvider<InterviewNotifier, InterviewDashboardData>((ref) {
  return InterviewNotifier();
});

class InterviewNotifier extends StateNotifier<InterviewDashboardData> {
  InterviewNotifier() : super(_initialData());

  static InterviewDashboardData _initialData() {
    return const InterviewDashboardData(
      overallReadiness: 78,
      confidenceScore: 82,
      communicationScore: 85,
      technicalScore: 70,
      behavioralScore: 88,
      universityFitScore: 90,
      completionPercentage: 0.45,
      questions: [
        InterviewQuestion(
          id: 'q1',
          category: 'General',
          question: 'Tell me about yourself.',
          hints: ['Focus on academic journey', 'Highlight key projects', 'Keep it under 2 minutes'],
          suggestedStructure: 'Past -> Present -> Future',
          sampleAnswer: 'I am a final-year CS student with a strong focus on AI...',
          preparationTips: ['Practice in front of a mirror', 'Record yourself'],
          isPracticed: true,
          isBookmarked: false,
        ),
        InterviewQuestion(
          id: 'q2',
          category: 'Behavioral',
          question: 'Describe a time you overcame a challenge.',
          hints: ['Use the STAR method', 'Focus on your specific actions', 'Highlight the positive outcome'],
          suggestedStructure: 'Situation -> Task -> Action -> Result',
          sampleAnswer: 'During my internship, our team faced a critical bug...',
          preparationTips: ['Have 2-3 versatile stories ready'],
          isPracticed: false,
          isBookmarked: true,
        ),
        InterviewQuestion(
          id: 'q3',
          category: 'Why This University',
          question: 'Why did you choose our program?',
          hints: ['Mention specific professors', 'Highlight unique curriculum elements', 'Align with your goals'],
          suggestedStructure: 'University Strength + Personal Goal Fit',
          sampleAnswer: 'The robotics lab led by Professor X perfectly aligns...',
          preparationTips: ['Research the faculty carefully'],
          isPracticed: false,
          isBookmarked: false,
        ),
      ],
      history: [
        InterviewSession(id: 's1', date: 'Oct 12, 2025', university: 'MIT Mock', duration: '25 mins', overallScore: 72, improvement: '+5%'),
        InterviewSession(id: 's2', date: 'Oct 20, 2025', university: 'Stanford Mock', duration: '30 mins', overallScore: 80, improvement: '+8%'),
      ],
    );
  }

  AIInterviewReport getLatestReport() {
    return const AIInterviewReport(
      overallScore: 85,
      confidence: 88,
      communication: 90,
      technicalKnowledge: 75,
      problemSolving: 82,
      leadership: 85,
      clarity: 92,
      vocabulary: 85,
      bodyLanguage: 80,
      eyeContact: 85,
      speakingPace: 90,
      recommendations: [
        AIInterviewRecommendation(text: 'Use more concrete examples in behavioral questions.', priority: 'High', estimatedImpact: '+10% Behavioral', isCompleted: false),
        AIInterviewRecommendation(text: 'Reduce filler words (um, like) during transitions.', priority: 'Medium', estimatedImpact: '+5% Communication', isCompleted: false),
        AIInterviewRecommendation(text: 'Expand project explanations with technical specifics.', priority: 'High', estimatedImpact: '+15% Technical', isCompleted: false),
      ],
      strengths: [
        'Excellent communication and clarity.',
        'Strong motivation for the chosen program.',
        'Maintained excellent eye contact and pacing.',
      ],
    );
  }
}
