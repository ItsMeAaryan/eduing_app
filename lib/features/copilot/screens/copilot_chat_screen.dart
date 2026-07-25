import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';
import '../providers/copilot_chat_provider.dart';

class CopilotChatScreen extends ConsumerStatefulWidget {
  const CopilotChatScreen({super.key});

  @override
  ConsumerState<CopilotChatScreen> createState() => _CopilotChatScreenState();
}

class _CopilotChatScreenState extends ConsumerState<CopilotChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    ref.read(copilotChatProvider.notifier).sendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(copilotChatProvider);
    final suggestions = ["My chances?", "Improve SOP", "Best scholarships", "Interview tips"];

    return Scaffold(
      backgroundColor: Colors.black, // Fully black as per spec
      body: SafeArea(
        child: Column(
          children: [
            // BackHeader
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI COPILOT CHAT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 11 * 0.1,
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final m = state.messages[index];
                  final isUser = m.from == 'user';
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isUser)
                          Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              color: NeoColors.green,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('✦', style: TextStyle(fontSize: 13, color: Colors.black)),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? NeoColors.green : NeoColors.surfDark, // "#1A1A1A"
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isUser ? 18 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 18),
                              ),
                            ),
                            child: Text(
                              m.text,
                              style: TextStyle(
                                fontSize: 13,
                                color: isUser ? Colors.black : Colors.white,
                                fontWeight: isUser ? FontWeight.w700 : FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Suggestions
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: suggestions.map((s) {
                  return GestureDetector(
                    onTap: () {
                      _controller.text = s;
                      _send();
                    },
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Input bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: NeoColors.subDark, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: NeoColors.green,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
