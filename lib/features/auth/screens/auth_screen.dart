import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
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

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Iconsax.book_1, size: 64, color: AppColors.primary),
                    const SizedBox(height: 24),
                    Text(
                      _mode == AuthMode.login ? 'Welcome back'
                          : _mode == AuthMode.register ? 'Create an account'
                          : 'Reset Password',
                      style: AppTypography.headline,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _mode == AuthMode.login ? 'Sign in to access your dashboard'
                          : _mode == AuthMode.register ? 'Join EDUING today'
                          : 'Enter your email to receive a reset link',
                      style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    if (_mode == AuthMode.register) ...[
                      TextFormField(
                        controller: _fullNameController,
                        decoration: _inputDecoration('Full Name', Iconsax.user),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email Address', Iconsax.sms),
                      validator: (v) => (v == null || !emailRegex.hasMatch(v.trim())) ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),

                    if (_mode != AuthMode.forgotPassword) ...[
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          'Password',
                          Iconsax.lock,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye, color: AppColors.textSecondary),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (_mode == AuthMode.register) ...[
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: _inputDecoration(
                          'Confirm Password',
                          Iconsax.lock,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye, color: AppColors.textSecondary),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (_mode == AuthMode.login)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _mode = AuthMode.forgotPassword),
                          child: Text('Forgot Password?', style: AppTypography.label.copyWith(color: AppColors.primary)),
                        ),
                      ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              _mode == AuthMode.login ? 'Sign In'
                                  : _mode == AuthMode.register ? 'Sign Up'
                                  : 'Send Reset Link',
                              style: AppTypography.button.copyWith(color: Colors.white),
                            ),
                    ),

                    if (_mode == AuthMode.login) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
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
                        icon: const Icon(Iconsax.login, color: AppColors.primary),
                        label: Text('Continue with Google', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _mode == AuthMode.login ? 'Don\'t have an account?'
                              : _mode == AuthMode.register ? 'Already have an account?'
                              : 'Remember your password?',
                          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = _mode == AuthMode.login ? AuthMode.register : AuthMode.login;
                            });
                          },
                          child: Text(
                            _mode == AuthMode.login ? 'Sign Up' : 'Sign In',
                            style: AppTypography.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
