import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/glow_input.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String _name = '';
  String _email = '';
  String _pass = '';
  bool _loading = false;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _triedSubmit = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 24),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/splash'),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.text,
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text60,
                            letterSpacing: 13 * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.only(bottom: 28),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.66,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        height: 1.1,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        TextSpan(text: 'Create account,\n', style: TextStyle(color: AppColors.text)),
                        TextSpan(text: 'start exploring.', style: TextStyle(color: AppColors.primaryAccent)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join thousands of students getting into top universities.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text60,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form
                      GlowInput(
                        label: 'FULL NAME',
                        placeholder: 'Aaryan Sharma',
                        value: _name,
                        onChange: (v) => setState(() => _name = v),
                      ),
                      GlowInput(
                        label: 'EMAIL',
                        placeholder: 'you@example.com',
                        value: _email,
                        onChange: (v) => setState(() => _email = v),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      GlowInput(
                        label: 'PASSWORD',
                        placeholder: 'Min. 8 characters',
                        value: _pass,
                        onChange: (v) => setState(() => _pass = v),
                        obscureText: _obscurePassword,
                        right: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),

                      // Password strength
                      if (_pass.isNotEmpty) ...[
                        const SizedBox(height: 8), // roughly marginTop:-6 from react, adjusted for flutter
                        Row(
                          children: List.generate(3, (i) {
                            final idx = i + 1;
                            final strength = _pass.length < 6 ? 1 : _pass.length < 10 ? 2 : 3;
                            final colors = [AppColors.red, AppColors.yellow, AppColors.primaryAccent];
                            
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 3,
                                margin: EdgeInsets.only(right: idx < 3 ? 4 : 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: idx <= strength ? colors[strength - 1] : AppColors.border,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 14),
                      ],
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                            activeColor: const Color(0xFF3DFF54),
                            checkColor: Colors.black,
                            side: BorderSide(
                              color: _triedSubmit && !_acceptedTerms ? AppColors.red : Colors.white30, 
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(color: Colors.white54, fontSize: 13),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(text: 'Terms of Service',
                                        style: TextStyle(color: Color(0xFF3DFF54), 
                                        decoration: TextDecoration.underline)),
                                      TextSpan(text: ' and '),
                                      TextSpan(text: 'Privacy Policy',
                                        style: TextStyle(color: Color(0xFF3DFF54),
                                        decoration: TextDecoration.underline)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 22,
                right: 22,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GreenButton(
                    label: 'Create Account',
                    loading: _loading,
                    disabled: _name.isEmpty || _email.isEmpty || _pass.length < 8 || !_acceptedTerms,
                    onClick: () {
                      setState(() => _triedSubmit = true);
                      if (!_acceptedTerms) return;
                      setState(() => _loading = true);
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (context.mounted) {
                          setState(() => _loading = false);
                          context.go('/otp');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  if (Theme.of(context).platform == TargetPlatform.iOS) ...[
                    const GhostButton(label: 'Continue with Apple', icon: '🍎'),
                    const SizedBox(height: 10),
                  ],
                  GhostButton(
                    label: 'Continue with Google',
                    icon: 'G',
                    onClick: () {
                      ref.read(authControllerProvider.notifier).signInWithGoogle();
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text60,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => context.go('/login'),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
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
