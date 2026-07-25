import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class SOPScreen extends StatefulWidget {
  final int initialStep;
  const SOPScreen({super.key, this.initialStep = 1});

  @override
  State<SOPScreen> createState() => _SOPScreenState();
}

class _SOPScreenState extends State<SOPScreen> {
  late int step;
  String uni = 'BITS Pilani';
  final String course = 'B.Tech CSE';
  String body = '';
  bool loading = false;
  bool generated = false;

  final TextEditingController _bodyController = TextEditingController();

  final String sampleSOP = '''I am a highly motivated student with a deep passion for computer science and artificial intelligence. Growing up in an environment that valued innovation, I developed an early interest in programming and problem-solving.

During my high school years, I consistently ranked in the top 1% of my class, achieving a JEE score that reflects both my dedication and aptitude for engineering. Beyond academics, I led my school's robotics team to the national finals.

BITS Pilani's unique dual-degree program and emphasis on practical industry exposure align perfectly with my goal of becoming an AI researcher who bridges the gap between theoretical advances and real-world impact.''';

  @override
  void initState() {
    super.initState();
    step = widget.initialStep;
    _bodyController.text = body;
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  void _generate() {
    setState(() {
      loading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          loading = false;
          generated = true;
          body = sampleSOP;
          _bodyController.text = sampleSOP;
          step = 3;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['University', 'Questionnaire', 'Generated', 'Review'];

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
                      if (step > 1 && step < 4) {
                        setState(() => step--);
                      } else {
                        context.pop();
                      }
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'SOP BUILDER',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  neo.Badge(label: 'STEP $step/4', color: NeoColors.purple),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: Row(
                children: List.generate(steps.length, (i) {
                  final isDone = i < step;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      margin: EdgeInsets.only(right: i < steps.length - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isDone ? NeoColors.green : NeoColors.borderDark,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: isDone
                            ? [BoxShadow(color: NeoColors.green.withValues(alpha: 0.4), blurRadius: 8)]
                            : [],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (step == 1) _buildStep1(),
                    if (step == 2) _buildStep2(),
                    if (step == 3 && generated) _buildStep3(),
                    if (step == 4) _buildStep4(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final unis = ['BITS Pilani', 'IIT Bombay', 'Delhi University', 'VIT Vellore'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose university.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'AI will tailor your SOP for the specific program.',
          style: TextStyle(
            fontSize: 13,
            color: NeoColors.subDark,
          ),
        ),
        const SizedBox(height: 24),
        ...unis.map((u) {
          final isSelected = uni == u;
          return GestureDetector(
            onTap: () => setState(() => uni = u),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? NeoColors.green : NeoColors.borderDark,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: NeoColors.green.withValues(alpha: 0.13), blurRadius: 16)] // 22 hex
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? NeoColors.green.withValues(alpha: 0.13) : NeoColors.surfDark2, // 22 hex
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? NeoColors.green : NeoColors.borderDark),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🏛', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    u,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? NeoColors.green : Colors.white,
                    ),
                  ),
                  if (isSelected)
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('✓', style: TextStyle(color: NeoColors.green, fontSize: 18)),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Continue →',
            onClick: () => setState(() => step = 2),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final questions = [
      {'q': 'Why this university and course?', 'ph': 'What draws you to BITS Pilani CSE...'},
      {'q': 'Your biggest academic achievement?', 'ph': 'JEE rank, projects, competitions...'},
      {'q': 'Career goal in 10 years?', 'ph': 'AI researcher, startup founder, engineer...'},
      {'q': 'Extra-curriculars or leadership?', 'ph': 'Robotics team, coding club, sports...'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell AI about you.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Answer a few questions to generate a personalised SOP.',
          style: TextStyle(
            fontSize: 13,
            color: NeoColors.subDark,
          ),
        ),
        const SizedBox(height: 24),
        ...questions.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['q']!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: NeoColors.subDark,
                    letterSpacing: 11 * 0.06,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: NeoColors.surfDark,
                    border: Border.all(color: NeoColors.borderDark, width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.5),
                    decoration: InputDecoration(
                      hintText: item['ph'],
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: loading ? 'Generating...' : '✦ Generate SOP',
            onClick: loading ? () {} : _generate,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final metrics = [
      {'l': 'Clarity', 'v': '92%', 'c': NeoColors.green},
      {'l': 'Relevance', 'v': '85%', 'c': NeoColors.blue},
      {'l': 'Tone', 'v': '88%', 'c': NeoColors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: NeoColors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text('✦', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SOP Generated', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('AI-crafted for $uni · $course', style: const TextStyle(fontSize: 11, color: NeoColors.subDark)),
                ],
              ),
            ),
            const neo.Badge(label: '88% MATCH', color: NeoColors.green),
          ],
        ),
        const SizedBox(height: 16),

        // Score bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: NeoColors.surfDark,
            border: Border.all(color: NeoColors.borderDark),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quality Score', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white60)),
                  Text('88/100', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: NeoColors.green)),
                ],
              ),
              const SizedBox(height: 8),
              const ProgressBar(value: 88, color: NeoColors.green, height: 5),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: metrics.map((m) {
                  final c = m['c'] as Color;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.09), // 18 hex approx
                      border: Border.all(color: c.withValues(alpha: 0.2)), // 33 hex
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${m['l']}: ${m['v']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // SOP Text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeoColors.surfDark,
            border: Border.all(color: NeoColors.borderDark),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _bodyController,
            maxLines: null,
            minLines: 8,
            style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.7),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (val) => body = val,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: GreenBtn(
                label: '✦ Improve',
                small: true,
                onClick: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GreenBtn(
                label: '📋 Copy',
                small: true,
                onClick: () {
                  Clipboard.setData(ClipboardData(text: body));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GreenBtn(
                label: 'Save →',
                small: true,
                onClick: () => setState(() => step = 4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'SOP Saved!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Your SOP for $uni has been saved to your vault.',
            style: const TextStyle(fontSize: 14, color: NeoColors.subDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GreenBtn(
            label: 'Back to Copilot',
            onClick: () => context.go('/copilot'),
          ),
        ],
      ),
    );
  }
}
