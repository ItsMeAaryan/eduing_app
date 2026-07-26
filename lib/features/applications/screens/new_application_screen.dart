import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;

class NewApplicationScreen extends StatefulWidget {
  const NewApplicationScreen({super.key});

  @override
  State<NewApplicationScreen> createState() => _NewApplicationScreenState();
}

class _NewApplicationScreenState extends State<NewApplicationScreen> {
  int _step = 1;
  String? _uni;
  String? _course;
  String? _intake;

  final List<String> _steps = ["University", "Course", "Intake", "Confirm"];
  final List<String> _universities = ["Stanford University", "MIT", "BITS Pilani", "IIT Bombay"];
  final List<String> _courses = ["MS Computer Science", "MS Data Science", "MBA", "M.Tech Electrical"];
  final List<String> _intakes = ["Fall 2024", "Spring 2025", "Fall 2025"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
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
                      if (_step > 1) {
                        setState(() => _step--);
                      } else {
                        context.pop();
                      }
                    },
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
                  const Expanded(
                    child: Text(
                      'NEW APPLICATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NeoColors.purple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: NeoColors.purple.withValues(alpha: 0.3)),
                    ),
                    child: Text('STEP $_step/4', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.purple)),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
              child: Row(
                children: List.generate(_steps.length, (index) {
                  final isActiveOrDone = index < _step;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      margin: EdgeInsets.only(right: index < _steps.length - 1 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: isActiveOrDone ? NeoColors.green : NeoColors.borderDark,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: isActiveOrDone ? [
                          BoxShadow(color: NeoColors.green.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 0),
                        ] : [],
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_step == 1) ...[
                      const Text('Choose university.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 6),
                      const Text('Select the institution you want to apply to.', style: TextStyle(fontSize: 14, color: Colors.white60)),
                      const SizedBox(height: 24),
                      ..._universities.map((u) {
                        final isSelected = _uni == u;
                        return GestureDetector(
                          onTap: () => setState(() => _uni = u),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? NeoColors.green : NeoColors.borderDark,
                                width: 1.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(color: NeoColors.green.withValues(alpha: 0.15), blurRadius: 16),
                              ] : [],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected ? NeoColors.green.withValues(alpha: 0.2) : NeoColors.surfDark2,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isSelected ? NeoColors.green : NeoColors.borderDark),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('🏛', style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(u, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isSelected ? NeoColors.green : Colors.white)),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: NeoColors.green, size: 24),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GreenBtn(
                          label: 'Continue →',
                          disabled: _uni == null,
                          onClick: () => setState(() => _step = 2),
                        ),
                      ),
                    ],

                    if (_step == 2) ...[
                      const Text('Select course.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 6),
                      Text('Programs available at $_uni.', style: const TextStyle(fontSize: 14, color: Colors.white60)),
                      const SizedBox(height: 24),
                      ..._courses.map((c) {
                        final isSelected = _course == c;
                        return GestureDetector(
                          onTap: () => setState(() => _course = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? NeoColors.green : NeoColors.borderDark,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(c, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isSelected ? NeoColors.green : Colors.white)),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: NeoColors.green, size: 24),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GreenBtn(
                          label: 'Continue →',
                          disabled: _course == null,
                          onClick: () => setState(() => _step = 3),
                        ),
                      ),
                    ],

                    if (_step == 3) ...[
                      const Text('Choose intake.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 6),
                      const Text('When do you plan to start?', style: TextStyle(fontSize: 14, color: Colors.white60)),
                      const SizedBox(height: 24),
                      ..._intakes.map((i) {
                        final isSelected = _intake == i;
                        return GestureDetector(
                          onTap: () => setState(() => _intake = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? NeoColors.green : NeoColors.borderDark,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text('📅', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(i, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isSelected ? NeoColors.green : Colors.white)),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: NeoColors.green, size: 24),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GreenBtn(
                          label: 'Continue →',
                          disabled: _intake == null,
                          onClick: () => setState(() => _step = 4),
                        ),
                      ),
                    ],

                    if (_step == 4) ...[
                      const Text('Ready to apply?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 6),
                      const Text('Review your application details.', style: TextStyle(fontSize: 14, color: Colors.white60)),
                      const SizedBox(height: 24),
                      
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: NeoColors.borderDark),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow('University', _uni ?? '', '🏛'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: NeoColors.borderDark, height: 1),
                            ),
                            _buildSummaryRow('Course', _course ?? '', '🎓'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: NeoColors.borderDark, height: 1),
                            ),
                            _buildSummaryRow('Intake', _intake ?? '', '📅'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: NeoColors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.purple.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('✦', style: TextStyle(fontSize: 18, color: NeoColors.purple)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AI Auto-fill Ready', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                                  const SizedBox(height: 2),
                                  Text('Your profile data will be mapped to the form automatically.', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: GreenBtn(
                          label: 'Start Application',
                          onClick: () => context.pushReplacement('/applications/1'), // Example ID
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
