import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import 'dart:math';

class StudentIDScreen extends StatefulWidget {
  const StudentIDScreen({super.key});

  @override
  State<StudentIDScreen> createState() => _StudentIDScreenState();
}

class _StudentIDScreenState extends State<StudentIDScreen> {
  bool _isFront = true;

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
                  const Expanded(
                    child: Text(
                      'STUDENT ID',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderAction(Icons.download),
                      const SizedBox(width: 8),
                      _buildHeaderAction(Icons.share),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    // Toggle
                    Container(
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildToggleBtn('Front', true)),
                          Expanded(child: _buildToggleBtn('Back', false)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ID Card
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
                        return AnimatedBuilder(
                          animation: rotateAnim,
                          child: child,
                          builder: (context, child) {
                            final isUnder = (ValueKey(_isFront) != child!.key);
                            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                            tilt *= isUnder ? -1.0 : 1.0;
                            final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
                            return Transform(
                              transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                        );
                      },
                      child: _isFront ? _buildFront(key: const ValueKey(true)) : _buildBack(key: const ValueKey(false)),
                    ),
                    const SizedBox(height: 48),

                    // Share Row
                    const Text('SHARE VIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildShareBtn(Icons.chat, NeoColors.green),
                        const SizedBox(width: 16),
                        _buildShareBtn(Icons.email, NeoColors.blue),
                        const SizedBox(width: 16),
                        _buildShareBtn(Icons.link, NeoColors.purple),
                        const SizedBox(width: 16),
                        _buildShareBtn(Icons.bookmark, NeoColors.yellow),
                      ],
                    ),
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

  Widget _buildToggleBtn(String label, bool isFrontBtn) {
    final active = _isFront == isFrontBtn;
    return GestureDetector(
      onTap: () => setState(() => _isFront = isFrontBtn),
      child: Container(
        decoration: BoxDecoration(
          color: active ? NeoColors.surfDark2 : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: active ? [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, spreadRadius: 1),
          ] : [],
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: active ? Colors.white : Colors.white60)),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: NeoColors.surfDark,
        shape: BoxShape.circle,
        border: Border.all(color: NeoColors.borderDark),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildShareBtn(IconData icon, Color color) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildFront({Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        color: NeoColors.surfDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NeoColors.borderDark),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // Gradient Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
              gradient: LinearGradient(
                colors: [NeoColors.purple, NeoColors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withValues(alpha: 0.2), width: 3),
                  ),
                  alignment: Alignment.center,
                  child: const Text('👱', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ALEX JOHNSON', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      SizedBox(height: 2),
                      Text('MS Computer Science', style: TextStyle(fontSize: 13, color: Colors.white)),
                      SizedBox(height: 6),
                      neo.Badge(label: 'Batch 2024', color: NeoColors.yellow),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Details List
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildDetailRow('ID NUMBER', 'EDU-2024-8991X'),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: NeoColors.borderDark, height: 1)),
                _buildDetailRow('UNIVERSITY', 'Stanford University'),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: NeoColors.borderDark, height: 1)),
                _buildDetailRow('VALID UNTIL', 'Dec 2026'),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: NeoColors.borderDark, height: 1)),
                _buildDetailRow('STATUS', 'Active (Verified)', color: NeoColors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color ?? Colors.white)),
      ],
    );
  }

  Widget _buildBack({Key? key}) {
    // 7x7 QR Grid Data
    final Set<int> blackCorners = {0, 1, 7, 8, 5, 6, 12, 13, 35, 36, 42, 43, 40, 41, 47, 48};

    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: NeoColors.surfDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NeoColors.borderDark),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Text('SCAN TO VERIFY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 200,
              width: 200,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: 49,
                itemBuilder: (context, index) {
                  bool isBlack = blackCorners.contains(index);
                  if (!isBlack) {
                    // deterministic pseudo-random for other blocks
                    isBlack = (index * 7 + 13) % 2 == 0;
                  }
                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isBlack ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('This is a digitally issued secure student credential. If found, please return to the issuing authority.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white30, height: 1.5),
          ),
        ],
      ),
    );
  }
}
