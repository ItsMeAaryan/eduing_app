import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onNavigateToLogin;

  const ForgotPasswordScreen({
    super.key,
    required this.onNavigateToLogin,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.text),
          onPressed: widget.onNavigateToLogin,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 80 + MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo + headline
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [NeoColors.red, NeoColors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: NeoColors.red.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        "🔑",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Text(
                      "ACCOUNT RECOVERY",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.red,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Reset your\npassword.",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: t.text,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Enter your email and we'll send you a link to reset your password.",
                      style: TextStyle(
                        fontSize: 14,
                        color: t.sub,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Inputs
              NeoInput(
                label: "Email",
                placeholder: "you@example.com",
                controller: _emailController,
              ),

              const SizedBox(height: 20),

              // Notched send button
              NotchedCard(
                bg: NeoColors.red,
                notchPos: "br",
                notchSize: 52,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Send Link",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Check your inbox",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -31),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FloatingActionBtn(
                      icon: "→",
                      bg: t.surf,
                      size: 52,
                      onClick: () {
                        // reset logic
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remembered it? ",
                    style: TextStyle(fontSize: 13, color: t.sub),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToLogin,
                    child: const Text(
                      "Sign in →",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
