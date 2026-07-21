import 'models/ai_responses.dart';

abstract class AIService {
  Future<String> chat(String message);
  Stream<String> streamChat(String message);
  void resetChat();
  
  Future<ResumeReview> analyzeResume(String resumeText);
  Future<SOPReview> analyzeSOP(String sopText);
  Future<DocumentAnalysis> analyzeDocument(String documentText);
  Future<InterviewFeedback> evaluateInterview(String question, String answer);
  Future<List<ScholarshipRecommendation>> recommendScholarships(Map<String, dynamic> profile);
  Future<List<UniversityRecommendation>> recommendUniversities(Map<String, dynamic> profile);
}
