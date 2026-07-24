import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/auth_provider.dart';

enum AuthMode { login, register, forgotPassword }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthMode _mode = AuthMode.login;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);

    switch (_mode) {
      case AuthMode.login:
        controller.signInWithEmail(_emailController.text.trim(), _passwordController.text).then((_) {
          if (!mounted) return;
          if (ref.read(authControllerProvider).hasError) {
            _showError(ref.read(authControllerProvider).error.toString());
          } else {
            context.go('/');
          }
        });
        break;
      case AuthMode.register:
        controller.registerWithEmail(_emailController.text.trim(), _passwordController.text, _fullNameController.text.trim()).then((_) {
          if (!mounted) return;
          if (ref.read(authControllerProvider).hasError) {
            _showError(ref.read(authControllerProvider).error.toString());
          } else {
            _showSuccess('Account created! Please check your email for verification.');
            setState(() => _mode = AuthMode.login);
          }
        });
        break;
      case AuthMode.forgotPassword:
        controller.sendPasswordReset(_emailController.text.trim()).then((_) {
          if (!mounted) return;
          if (ref.read(authControllerProvider).hasError) {
            _showError(ref.read(authControllerProvider).error.toString());
          } else {
            _showSuccess('Password reset link sent to your email.');
            setState(() => _mode = AuthMode.login);
          }
        });
        break;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24, vertical: AppSpacing.p40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.p24),
                        decoration: BoxDecoration(
                          gradient: AppColors.aiGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
                          ],
                        ),
                        child: const Icon(Iconsax.book_1, size: 64, color: Colors.white),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    ),
                    const SizedBox(height: AppSpacing.p40),
                    Text(
                      _mode == AuthMode.login ? 'Welcome back'
                          : _mode == AuthMode.register ? 'Create an account'
                          : 'Reset Password',
                      style: AppTypography.display.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
                    const SizedBox(height: AppSpacing.p12),
                    Text(
                      _mode == AuthMode.login ? 'Sign in to access your dashboard'
                          : _mode == AuthMode.register ? 'Join EDUING today'
                          : 'Enter your email to receive a reset link',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: AppSpacing.p40),

                    SquircleCard(
                      padding: const EdgeInsets.all(AppSpacing.p32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (_mode == AuthMode.register) ...[
                              TextFormField(
                                controller: _fullNameController,
                                style: AppTypography.bodyMedium,
                                decoration: _inputDecoration('Full Name', Iconsax.user, isDark),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                              ),
                              const SizedBox(height: AppSpacing.p20),
                            ],

                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTypography.bodyMedium,
                              decoration: _inputDecoration('Email Address', Iconsax.sms, isDark),
                              validator: (v) => (v == null || !emailRegex.hasMatch(v.trim())) ? 'Enter a valid email' : null,
                            ),
                            const SizedBox(height: AppSpacing.p20),

                            if (_mode != AuthMode.forgotPassword) ...[
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: AppTypography.bodyMedium,
                                decoration: _inputDecoration(
                                  'Password',
                                  Iconsax.lock,
                                  isDark,
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye, color: AppColors.textSecondary),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                              ),
                              const SizedBox(height: AppSpacing.p20),
                            ],

                            if (_mode == AuthMode.register) ...[
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: AppTypography.bodyMedium,
                                decoration: _inputDecoration(
                                  'Confirm Password',
                                  Iconsax.lock,
                                  isDark,
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye, color: AppColors.textSecondary),
                                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                ),
                                validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                              ),
                              const SizedBox(height: AppSpacing.p20),
                            ],

                            if (_mode == AuthMode.login)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => setState(() => _mode = AuthMode.forgotPassword),
                                  child: Text('Forgot Password?', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                                ),
                              ),

                            const SizedBox(height: AppSpacing.p32),
                            
                            SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                text: _mode == AuthMode.login ? 'Sign In'
                                    : _mode == AuthMode.register ? 'Sign Up'
                                    : 'Send Reset Link',
                                isLoading: isLoading,
                                onPressed: _submit,
                              ),
                            ),

                            if (_mode == AuthMode.login) ...[
                              const SizedBox(height: AppSpacing.p24),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p16),
                                    child: Text('OR', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                                  ),
                                  Expanded(child: Divider(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5))),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.p24),
                              SizedBox(
                                width: double.infinity,
                                child: AppButton(
                                  text: 'Continue with Google',
                                  icon: Iconsax.global, // Using global as a placeholder for Google icon
                                  variant: AppButtonVariant.secondary,
                                  isLoading: isLoading,
                                  onPressed: () async {
                                    final repo = ref.read(authRepositoryProvider);
                                    try {
                                      final credential = await repo.signInWithGoogle();
                                      if (!context.mounted) return;
                                      if (credential != null) {
                                        context.go('/');
                                      }
                                    } catch (e) {
                                      if (context.mounted) _showError('Google Sign-In: $e');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ).animate().fade(delay: 300.ms).slideY(begin: 0.1),

                    const SizedBox(height: AppSpacing.p40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _mode == AuthMode.login ? 'Don\'t have an account?'
                              : _mode == AuthMode.register ? 'Already have an account?'
                              : 'Remember your password?',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = _mode == AuthMode.login ? AuthMode.register : AuthMode.login;
                            });
                          },
                          child: Text(
                            _mode == AuthMode.login ? 'Sign Up' : 'Sign In',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ).animate().fade(delay: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, bool isDark, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
