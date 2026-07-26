import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class DocUploadScreen extends StatefulWidget {
  const DocUploadScreen({super.key});

  @override
  State<DocUploadScreen> createState() => _DocUploadScreenState();
}

class _DocUploadScreenState extends State<DocUploadScreen> with SingleTickerProviderStateMixin {
  int _phase = 1; // 1: pick, 2: scan, 3: crop, 4: processing, 5: done
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  final List<Map<String, dynamic>> _docTypes = [
    {"name": "Passport", "icon": "🛂"},
    {"name": "Transcript", "icon": "📄"},
    {"name": "ID Card", "icon": "🪪"},
    {"name": "Other", "icon": "📁"},
  ];

  final List<Map<String, dynamic>> _methods = [
    {"name": "Camera", "icon": Icons.camera_alt, "desc": "Scan document instantly"},
    {"name": "Gallery", "icon": Icons.photo_library, "desc": "Pick from camera roll"},
    {"name": "Files", "icon": Icons.folder, "desc": "Browse PDF / DOCX"},
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scanAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _nextPhase() {
    if (_phase == 1) {
      setState(() => _phase = 2);
      _scanController.repeat(reverse: true);
    } else if (_phase == 2) {
      _scanController.stop();
      setState(() => _phase = 3);
    } else if (_phase == 3) {
      setState(() => _phase = 4);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _phase = 5);
      });
    } else if (_phase == 5) {
      context.pop();
    }
  }

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
                      if (_phase > 1 && _phase < 4) {
                        setState(() => _phase--);
                      } else if (_phase == 5 || _phase == 1) {
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
                  Expanded(
                    child: Text(
                      _phase == 1 ? 'UPLOAD DOCUMENT' : _phase == 2 ? 'SCAN DOCUMENT' : _phase == 3 ? 'CROP & ADJUST' : _phase == 4 ? 'PROCESSING AI' : 'QUALITY REPORT',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_phase == 1) _buildPhase1(),
                    if (_phase == 2) _buildPhase2(),
                    if (_phase == 3) _buildPhase3(),
                    if (_phase == 4) _buildPhase4(),
                    if (_phase == 5) _buildPhase5(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Select Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: _docTypes.length,
          itemBuilder: (context, index) {
            final doc = _docTypes[index];
            return Container(
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.borderDark),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(doc['icon'], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(doc['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        const Text('Upload Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 16),
        ..._methods.map((m) => GestureDetector(
          onTap: _nextPhase,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeoColors.surfDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NeoColors.borderDark),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: NeoColors.surfDark2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(m['icon'], color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(m['desc'], style: const TextStyle(fontSize: 12, color: Colors.white60)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPhase2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Scan Document', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Align your document within the frame.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),
        
        Center(
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: NeoColors.surfDark2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NeoColors.green, width: 2),
              boxShadow: [
                BoxShadow(color: NeoColors.green.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Stack(
              children: [
                // Corner Guides
                Positioned(top: 10, left: 10, child: _buildCornerGuide(Alignment.topLeft)),
                Positioned(top: 10, right: 10, child: _buildCornerGuide(Alignment.topRight)),
                Positioned(bottom: 10, left: 10, child: _buildCornerGuide(Alignment.bottomLeft)),
                Positioned(bottom: 10, right: 10, child: _buildCornerGuide(Alignment.bottomRight)),

                // Animated Scan Line
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 220 * _scanAnimation.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: NeoColors.green,
                          boxShadow: [
                            BoxShadow(color: NeoColors.green.withValues(alpha: 0.8), blurRadius: 8, spreadRadius: 2),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Features
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureChip('Auto-crop', true),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('|', style: TextStyle(color: Colors.white30))),
            _buildFeatureChip('OCR', true),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('|', style: TextStyle(color: Colors.white30))),
            _buildFeatureChip('Quality Check', true),
          ],
        ),

        const SizedBox(height: 48),
        Center(
          child: GestureDetector(
            onTap: _nextPhase,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerGuide(Alignment align) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: (align == Alignment.topLeft || align == Alignment.topRight) ? const BorderSide(color: NeoColors.green, width: 3) : BorderSide.none,
          bottom: (align == Alignment.bottomLeft || align == Alignment.bottomRight) ? const BorderSide(color: NeoColors.green, width: 3) : BorderSide.none,
          left: (align == Alignment.topLeft || align == Alignment.bottomLeft) ? const BorderSide(color: NeoColors.green, width: 3) : BorderSide.none,
          right: (align == Alignment.topRight || align == Alignment.bottomRight) ? const BorderSide(color: NeoColors.green, width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool active) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white60)),
        const SizedBox(width: 4),
        if (active) const Icon(Icons.check_circle, color: NeoColors.green, size: 14),
      ],
    );
  }

  Widget _buildPhase3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Adjust Bounds', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Drag the corners to crop exactly.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),

        Center(
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: NeoColors.surfDark2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2, style: BorderStyle.solid), // Should be dashed, keeping simple
                    ),
                  ),
                ),
                // Draggable corners (mocked static)
                Positioned(top: 20, left: 20, child: _buildHandle()),
                Positioned(top: 20, right: 20, child: _buildHandle()),
                Positioned(bottom: 20, left: 20, child: _buildHandle()),
                Positioned(bottom: 20, right: 20, child: _buildHandle()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _phase = 2),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: NeoColors.surfDark,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: NeoColors.borderDark),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Retake', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GreenBtn(
                label: 'Confirm',
                onClick: _nextPhase,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: NeoColors.blue, width: 4),
      ),
    );
  }

  Widget _buildPhase4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        // Pulsing AI Icon
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 1.2),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, val, child) {
            return Transform.scale(
              scale: val,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: NeoColors.purple.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: NeoColors.purple),
                  boxShadow: [
                    BoxShadow(color: NeoColors.purple.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('✦', style: TextStyle(fontSize: 40, color: NeoColors.purple)),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        const Text('AI is analyzing...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 24),
        
        _buildProcessingStep('Enhancing quality', true),
        _buildProcessingStep('Extracting text (OCR)', true),
        _buildProcessingStep('Verifying format', false),
        _buildProcessingStep('Finalizing', false),
      ],
    );
  }

  Widget _buildProcessingStep(String title, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: done ? NeoColors.green : NeoColors.surfDark2,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: done ? const Icon(Icons.check, color: Colors.black, size: 12) : const SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white30)),
          ),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: done ? Colors.white : Colors.white30)),
        ],
      ),
    );
  }

  Widget _buildPhase5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Scan Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: NeoColors.green, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Your document passed all quality checks.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),

        NotchedCard(
          bg: NeoColors.surfDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('QUALITY SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('92', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: NeoColors.green, height: 1)),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 4),
                    child: Text('/100', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white30)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: NeoColors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Excellent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: NeoColors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: NeoColors.borderDark),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetric('Clarity', 'High', NeoColors.green),
                  _buildMetric('Lighting', 'Good', NeoColors.green),
                  _buildMetric('Corners', 'Visible', NeoColors.green),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Save Document',
            onClick: () => context.pop(),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _phase = 2),
            child: const Text('Rescan', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        neo.Badge(label: value, color: color),
      ],
    );
  }
}
