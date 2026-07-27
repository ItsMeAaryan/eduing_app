import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
import '../../../core/widgets/glow_input.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  // Keep this for compatibility with existing router usage
  final VoidCallback? onNavigateToLogin;

  const ForgotPasswordScreen({super.key, this.onNavigateToLogin});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  String _email = '';
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _sendReset() async {
    if (_email.isEmpty) return;
    await ref.read(authControllerProvider.notifier).sendPasswordReset(_email.trim());
    if (mounted && !ref.read(authControllerProvider).hasError) {
      setState(() => _sent = true);
    }
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

    final isLoading = ref.watch(authControllerProvider).isLoading;

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
                      // ── Content ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Back
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6, bottom: 32),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (widget.onNavigateToLogin != null) {
                                        widget.onNavigateToLogin!();
                                      } else {
                                        context.go('/login');
                                      }
                                    },
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
                                    'ACCOUNT RECOVERY',
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
                                widthFactor: 0.66,
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
                              'Reset your\npassword.',
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
                              "Enter your email and we'll send you a link to reset your password.",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.text60,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),

                            if (_sent) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAccent.withValues(
                                      alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.primaryAccent
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        color: AppColors.primaryAccent,
                                        size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Reset link sent to $_email',
                                        style: const TextStyle(
                                          color: AppColors.primaryAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              GlowInput(
                                label: 'EMAIL ADDRESS',
                                placeholder: 'you@example.com',
                                value: _email,
                                onChange: (v) => setState(() => _email = v),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const Spacer(),

                      // ── Bottom button ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          children: [
                            GreenButton(
                              label: _sent ? 'Resend Link' : 'Send Reset Link',
                              loading: isLoading,
                              disabled: _email.isEmpty,
                              onClick: _sendReset,
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                if (widget.onNavigateToLogin != null) {
                                  widget.onNavigateToLogin!();
                                } else {
                                  context.go('/login');
                                }
                              },
                              child: const Text(
                                'Back to Sign in →',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text60,
                                  fontWeight: FontWeight.w600,
                                ),
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
