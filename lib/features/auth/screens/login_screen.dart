import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/glow_input.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _pass = '';
  bool _loading = false;
  bool _showPass = false;

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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Back
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 32),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/'),
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
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text60,
                            letterSpacing: 13 * 0.04, // 0.04em
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.only(bottom: 32),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.33,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // Headline
                  const Text(
                    'Welcome\nback.',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                      letterSpacing: -1,
                      height: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue your admission journey.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text60,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Social
                  if (Theme.of(context).platform == TargetPlatform.iOS) ...[
                    const GreenButton(label: 'Continue with Apple', icon: '🍎'),
                    const SizedBox(height: 10),
                  ],
                  GhostButton(
                    label: 'Continue with Google',
                    icon: 'G',
                    onClick: () {
                      ref.read(authControllerProvider.notifier).signInWithGoogle();
                    },
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: AppColors.border)),
                      const SizedBox(width: 12),
                      const Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text30,
                          letterSpacing: 11 * 0.08, // 0.08em
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Container(height: 1, color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email
                  GlowInput(
                    label: 'EMAIL',
                    placeholder: 'you@example.com',
                    value: _email,
                    onChange: (v) => setState(() => _email = v),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // Password
                  GlowInput(
                    label: 'PASSWORD',
                    placeholder: '••••••••',
                    value: _pass,
                    onChange: (v) => setState(() => _pass = v),
                    obscureText: !_showPass,
                    right: GestureDetector(
                      onTap: () => setState(() => _showPass = !_showPass),
                      child: Text(
                        _showPass ? '🙈' : '👁',
                        style: const TextStyle(fontSize: 14, color: AppColors.text60),
                      ),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 28),
                      child: GestureDetector(
                        onTap: () {}, // onNavigate("forgot")
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom buttons
                  GreenButton(
                    label: 'Sign in',
                    loading: _loading,
                    disabled: _email.isEmpty || _pass.isEmpty,
                    onClick: () {
                      setState(() => _loading = true);
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (context.mounted) {
                          setState(() => _loading = false);
                          context.go('/otp');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text60,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          const TextSpan(text: 'No account? '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text(
                                'Create one →',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
