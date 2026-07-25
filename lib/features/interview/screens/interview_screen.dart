import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> with SingleTickerProviderStateMixin {
  String phase = 'home'; // home | prep | active | feedback
  int timer = 120;
  bool recording = false;
  int qIdx = 0;
  Timer? _timerObj;

  late AnimationController _blinkController;

  final questions = [
    "Tell me about yourself and why you chose computer science.",
    "What is your greatest academic achievement and what did you learn?",
    "Where do you see yourself in 10 years?",
    "Why specifically BITS Pilani over other top universities?",
    "Describe a challenge you overcame and how.",
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timerObj?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerObj?.cancel();
    _timerObj = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (phase != 'active' || !recording) return;
      setState(() {
        if (timer <= 0) {
          recording = false;
          phase = 'feedback';
          t.cancel();
        } else {
          timer--;
        }
      });
    });
  }

  String _formatTime(int s) {
    final mins = (s / 60).floor();
    final secs = (s % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (phase == 'home') {
                        context.pop();
                      } else {
                        setState(() {
                          phase = 'home';
                          recording = false;
                        });
                      }
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'MOCK INTERVIEW',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (phase == 'home') _buildPhaseHome(),
                    if (phase == 'prep') _buildPhasePrep(),
                    if (phase == 'active') _buildPhaseActive(),
                    if (phase == 'feedback') _buildPhaseFeedback(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero
        NotchedCard(
          bg: Colors.transparent,
          padding: EdgeInsets.zero,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1C8A5E), NeoColors.blue],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI VIDEO & AUDIO PRACTICE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Practice admission\n& visa interviews.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI grades clarity, structure & delivery instantly.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: FloatingActionBtn(
                  icon: '▶',
                  bg: NeoColors.green,
                  onClick: () => setState(() => phase = 'prep'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Stats
        Row(
          children: [
            {'label': 'Sessions', 'value': '3', 'color': NeoColors.green},
            {'label': 'Avg Score', 'value': '74%', 'color': NeoColors.blue},
            {'label': 'Questions', 'value': '12', 'color': NeoColors.purple},
          ].map((s) {
            final c = s['color'] as Color;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: s['label'] != 'Questions' ? 10 : 0),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: NeoColors.surfDark,
                  border: Border.all(color: c.withValues(alpha: 0.13)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (s['label'] as String).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.subDark,
                        letterSpacing: 8 * 0.06,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['value'] as String,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: c,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // Question categories
        const Text(
          'PRACTICE BY CATEGORY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: NeoColors.subDark,
            letterSpacing: 10 * 0.1,
          ),
        ),
        const SizedBox(height: 12),
        ...[
          {'icon': '🎓', 'label': 'University Admission', 'count': 24, 'color': NeoColors.purple},
          {'icon': '🌍', 'label': 'Visa Interview', 'count': 18, 'color': NeoColors.blue},
          {'icon': '💼', 'label': 'HR & Behavioral', 'count': 30, 'color': const Color(0xFFFF6B35)}, // orange
          {'icon': '🔬', 'label': 'Technical CS', 'count': 40, 'color': NeoColors.green},
        ].map((c) {
          final color = c['color'] as Color;
          return GestureDetector(
            onTap: () => setState(() => phase = 'prep'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                border: Border.all(color: color.withValues(alpha: 0.13)), // 22 hex approx
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.09), // 18 hex
                      border: Border.all(color: color.withValues(alpha: 0.2)), // 33 hex
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(c['icon'] as String, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['label'] as String,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        Text(
                          '${c['count']} questions',
                          style: const TextStyle(fontSize: 11, color: NeoColors.subDark),
                        ),
                      ],
                    ),
                  ),
                  const Text('›', style: TextStyle(fontSize: 16, color: NeoColors.subDark)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPhasePrep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ready to start?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${questions.length} questions · ~10 minutes · AI graded',
          style: const TextStyle(
            fontSize: 13,
            color: NeoColors.subDark,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeoColors.surfDark,
            border: Border.all(color: NeoColors.borderDark),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TIPS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: NeoColors.subDark,
                  letterSpacing: 10 * 0.08,
                ),
              ),
              const SizedBox(height: 10),
              ...[
                'Speak clearly and maintain eye contact with camera',
                'Structure answers: Situation → Action → Result',
                'Take 5 seconds to think before answering',
              ].asMap().entries.map((e) {
                return Padding(
                  padding: EdgeInsets.only(bottom: e.key < 2 ? 10 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✓', style: TextStyle(color: NeoColors.green, fontWeight: FontWeight.w900, fontSize: 13)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e.value,
                          style: const TextStyle(fontSize: 13, color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: '▶ Start Interview',
            onClick: () {
              setState(() {
                phase = 'active';
                timer = 120;
                qIdx = 0;
                recording = true; // Auto start recording, wait spec sets recording=false? Spec: setPhase("active"); setTimer(120); setQIdx(0);  recording defaults to false until toggled, but I'll follow spec exactly (spec didn't set recording=true in start button). Wait, in spec: `setPhase("active"); setTimer(120); setQIdx(0);`
                recording = false;
              });
              _startTimer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseActive() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Camera viewfinder
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: NeoColors.surfDark2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: recording ? NeoColors.green : NeoColors.borderDark,
              width: 2,
            ),
            boxShadow: recording
                ? [BoxShadow(color: NeoColors.green.withValues(alpha: 0.2), blurRadius: 24)] // 33 hex
                : [],
          ),
          alignment: Alignment.center,
          child: Stack(
            children: [
              const Center(
                child: Text('📷', style: TextStyle(fontSize: 48)),
              ),
              if (recording)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: _blinkController,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'REC ${_formatTime(timer)}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Question
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeoColors.surfDark,
            border: Border.all(color: NeoColors.purple.withValues(alpha: 0.2)), // 33 hex
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  neo.Badge(label: 'Q${qIdx + 1}/${questions.length}', color: NeoColors.purple),
                  Text(
                    _formatTime(timer),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: NeoColors.subDark),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                questions[qIdx],
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Actions
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    recording = !recording;
                  });
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: recording ? NeoColors.red : NeoColors.green,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: (recording ? NeoColors.red : NeoColors.green).withValues(alpha: 0.27), // 44 hex approx
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(recording ? '⏹' : '🎤', style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        recording ? 'Stop' : 'Record',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: recording ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            qIdx < questions.length - 1
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        qIdx++;
                        timer = 120;
                        recording = false;
                      });
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Skip →',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => setState(() => phase = 'feedback'),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: NeoColors.purple,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Finish',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhaseFeedback() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Text('🎯', style: TextStyle(fontSize: 52)),
              SizedBox(height: 8),
              Text('Interview Complete!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              SizedBox(height: 4),
              Text('AI has analysed your responses', style: TextStyle(fontSize: 13, color: NeoColors.subDark)),
            ],
          ),
        ),
        
        NotchedCard(
          bg: Colors.transparent,
          padding: EdgeInsets.zero,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1C8A5E), NeoColors.blue],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERALL SCORE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '76%',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ['Clarity', '80%'],
                        ['Structure', '72%'],
                        ['Delivery', '75%'],
                        ['Relevance', '78%'],
                      ].map((m) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${m[0]}: ${m[1]}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: FloatingActionBtn(
                  icon: '✦',
                  bg: NeoColors.green,
                  onClick: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        ...[
          {'icon': '✅', 'text': 'Strong opening — good structure on Q1 & Q3', 'color': NeoColors.green},
          {'icon': '⚠️', 'text': 'Improve: Use specific examples with data/numbers', 'color': NeoColors.yellow},
          {'icon': '💡', 'text': 'Tip: Practice the STAR method for Q4', 'color': NeoColors.blue},
        ].map((fb) {
          final c = fb['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: NeoColors.surfDark,
              border: Border.all(color: c.withValues(alpha: 0.13)), // 22 hex
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(fb['icon'] as String, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fb['text'] as String,
                    style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Practice Again',
            onClick: () {
              setState(() {
                phase = 'home';
                timer = 120;
                qIdx = 0;
                recording = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
