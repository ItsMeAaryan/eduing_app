import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/ai/gemini_service.dart';
import '../../../core/ai/exceptions/gemini_exception.dart';
import '../../../core/ai/prompts/chat_prompt.dart';

class ChatContext {
  final String name;
  final double jeePercentile;
  final double percentage;
  final String board;
  final String category;
  final int readinessScore;
  final List<String> activeApplications;
  final List<String> upcomingDeadlines;

  const ChatContext({
    required this.name,
    required this.jeePercentile,
    required this.percentage,
    required this.board,
    required this.category,
    required this.readinessScore,
    required this.activeApplications,
    required this.upcomingDeadlines,
  });
}

class ChatMessageData {
  final String text;
  final bool isUser;

  const ChatMessageData({required this.text, required this.isUser});
}

class CopilotChatService {
  final GeminiService _geminiService;

  CopilotChatService(this._geminiService);

  Future<Either<GeminiException, String>> sendMessage(
    String message,
    ChatContext context,
    List<ChatMessageData> history,
  ) async {
    final systemPrompt = ChatPrompt.generatePrompt(
      name: context.name,
      jeePercentile: context.jeePercentile,
      percentage: context.percentage,
      board: context.board,
      category: context.category,
      readinessScore: context.readinessScore,
      applications: context.activeApplications.join(', '),
      deadlines: context.upcomingDeadlines.join(', '),
    );

    // Prepare history
    final historyContents = history.map((msg) {
      return Content(msg.isUser ? 'user' : 'model', [TextPart(msg.text)]);
    }).toList();

    // Start chat with history
    final chatSession = _geminiService.startChat(
      modelType: GeminiModelType.flash, // Using flash for fast chat
      history: historyContents,
    );

    // The generative ai package doesn't have a direct way to set system prompt on an existing ChatSession
    // in older versions, but typically it is passed to the GenerativeModel.
    // For this implementation, we will prepend the system prompt to the user's message if history is empty,
    // or as a separate system instruction. 
    // Since we use the gemini service startChat wrapper, we pass the message.
    
    // As a workaround for system prompts, we'll prepend it contextually to the first message
    String finalMessage = message;
    if (history.isEmpty) {
      finalMessage = 'System context: $systemPrompt\n\nUser: $message';
    }

    return _geminiService.sendMessage(
      chat: chatSession,
      message: finalMessage,
    );
  }
}
