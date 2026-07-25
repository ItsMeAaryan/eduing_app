import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String from; // 'ai' or 'user'
  final String text;

  const ChatMessage({required this.from, required this.text});
}

class CopilotChatState {
  final List<ChatMessage> messages;

  const CopilotChatState({this.messages = const []});

  CopilotChatState copyWith({List<ChatMessage>? messages}) {
    return CopilotChatState(messages: messages ?? this.messages);
  }
}

class CopilotChatNotifier extends StateNotifier<CopilotChatState> {
  CopilotChatNotifier()
      : super(const CopilotChatState(
          messages: [
            ChatMessage(from: 'ai', text: 'Hey Aaryan 👋 I\'m your AI admission strategist. What do you need help with today?'),
            ChatMessage(from: 'user', text: 'What are my chances at BITS Pilani CSE?'),
            ChatMessage(from: 'ai', text: 'Based on your profile — JEE score, 12th marks, and extracurriculars — I estimate a 78% admission probability for BITS Pilani CSE. Your rank needs to be under 2,500 for Pilani campus. Want me to break down what you can improve?'),
          ],
        ));

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    state = state.copyWith(messages: [
      ...state.messages,
      ChatMessage(from: 'user', text: text),
      const ChatMessage(from: 'ai', text: 'Analysing your question...'),
    ]);
  }
}

final copilotChatProvider = StateNotifierProvider<CopilotChatNotifier, CopilotChatState>((ref) {
  return CopilotChatNotifier();
});
