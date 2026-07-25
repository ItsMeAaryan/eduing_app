import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
import '../../../core/widgets/custom_numpad.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<String> _digits = ['4', '3', '9', '3']; // Pre-filled from design
  bool _loading = false;

  void _handleNum(String n) {
    final filled = _digits.where((d) => d.isNotEmpty).length;
    setState(() {
      if (n == 'del') {
        for (int i = 3; i >= 0; i--) {
          if (_digits[i].isNotEmpty) {
            _digits[i] = '';
            break;
          }
        }
      } else if (filled < 4) {
        for (int i = 0; i < 4; i++) {
          if (_digits[i].isEmpty) {
            _digits[i] = n;
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _digits.where((d) => d.isNotEmpty).length == 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false, // The numpad handles bottom safe area itself essentially
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 22, right: 22),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.text,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'VERIFICATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text60,
                      letterSpacing: 11 * 0.05, // 0.05em
                    ),
                  ),
                ],
              ),
            ),

            // Green progress bar
            Container(
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              color: AppColors.surface,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x883DFF54), // G.green88
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 24, left: 22, right: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter\nVerification\nCode',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.text60,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(text: 'we\'ve sent a code to\n'),
                          TextSpan(
                            text: 'aaryan@example.com',
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4 digit boxes
                    Row(
                      children: List.generate(4, (i) {
                        final d = _digits[i];
                        final isFilled = d.isNotEmpty;
                        
                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            margin: EdgeInsets.only(right: i < 3 ? 12 : 0),
                            decoration: BoxDecoration(
                              color: AppColors.surface, // Background always surface in reference
                              border: Border.all(
                                color: isFilled ? AppColors.primaryAccent : AppColors.border,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: isFilled
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryAccent.withValues(alpha: 0.26), // 44 hex
                                        blurRadius: 12,
                                      )
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.text30,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(text: 'Didn\'t get a code? '),
                          TextSpan(
                            text: 'Click to resend.',
                            style: TextStyle(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CTA
                    GreenButton(
                      label: 'Continue Verification',
                      loading: _loading,
                      disabled: !isComplete,
                      onClick: () {
                        setState(() => _loading = true);
                        Future.delayed(const Duration(milliseconds: 1200), () {
                          if (context.mounted) {
                            setState(() => _loading = false);
                            context.go('/onboarding');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Custom Numpad
            CustomNumpad(onKeyPress: _handleNum),
          ],
        ),
      ),
    );
  }
}
