import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
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
  void initState() {
    super.initState();
    // Pre-warm keyboard to reduce open animation lag
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

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
      backgroundColor: const Color(0xFF0A0A0A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ── Scrollable content ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      letterSpacing: 0.52,
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

                            // Email field
                            GlowInput(
                              label: 'EMAIL',
                              placeholder: 'you@example.com',
                              value: _email,
                              onChange: (v) => setState(() => _email = v),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),

                            // Password field
                            GlowInput(
                              label: 'PASSWORD',
                              placeholder: '••••••••',
                              value: _pass,
                              onChange: (v) => setState(() => _pass = v),
                              obscureText: !_showPass,
                              textInputAction: TextInputAction.done,
                              right: GestureDetector(
                                onTap: () => setState(() => _showPass = !_showPass),
                                child: Icon(
                                  _showPass ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                              ),
                            ),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 28),
                                child: GestureDetector(
                                  onTap: () => context.push('/forgot-password'),
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
                          ],
                        ),
                      ),

                      // ── Push buttons to bottom ──
                      const Spacer(),

                      // ── Bottom buttons ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          children: [
                            GreenButton(
                              label: 'Sign in',
                              loading: _loading,
                              disabled: _email.isEmpty || _pass.isEmpty,
                              onClick: () {
                                setState(() => _loading = true);
                                Future.delayed(const Duration(milliseconds: 1200), () {
                                  if (context.mounted) {
                                    setState(() => _loading = false);
                                    context.go('/home');
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            RichText(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
