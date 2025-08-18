import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onLogin, this.onGoRegister, this.onGoReset});

  final Future<void> Function(String emailOrUser, String password)? onLogin;
  final VoidCallback? onGoRegister;
  final VoidCallback? onGoReset;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      if (widget.onLogin != null) {
        await widget.onLogin!(_emailCtrl.text.trim(), _passCtrl.text);
      } else {
        // default demo: show snackbar
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Logging in as ${_emailCtrl.text.trim()}')));
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Title
                  const _LogoTitle()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .2, curve: Curves.easeOutQuad),

                  GPSGaps.h24,

                  // Email/Username
                  _LabeledField(
                    label: 'Email or Username',
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your email or username'),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter email or username'
                                  : null,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: .12),

                  GPSGaps.h16,

                  // Password
                  _LabeledField(
                    label: 'Password',
                    child: TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: _inputDecoration('Enter your password').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: GPSColors.mutedText,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Please enter password' : null,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 80.ms).slideY(begin: .12),

                  GPSGaps.h20,

                  // Login button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GPSColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child:
                          _loading
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('Login', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ).animate().fadeIn(duration: 280.ms, delay: 120.ms).slideY(begin: .08),

                  GPSGaps.h24,

                  // Links: register & reset
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                      children: [
                        const TextSpan(text: "Don't have an account? Please "),
                        TextSpan(
                          text: 'register',
                          style: const TextStyle(
                            color: GPSColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = widget.onGoRegister,
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: .06),

                  GPSGaps.h12,

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                      children: [
                        const TextSpan(text: 'Forget '),
                        TextSpan(
                          text: 'password',
                          style: const TextStyle(
                            color: GPSColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = widget.onGoReset,
                        ),
                        const TextSpan(text: '?'),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: .06),

                  GPSGaps.h24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.primary, width: 1.6),
      ),
    );
  }
}

/// --------------------------- SUBWIDGETS -----------------------------------
class _LogoTitle extends StatelessWidget {
  const _LogoTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: GPSColors.cardSelected,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: const Icon(Icons.pin_drop_rounded, color: GPSColors.primary),
        ),
        GPSGaps.h12,
        Text(
          'Welcome back',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
        ),
        GPSGaps.h8,
        child,
      ],
    );
  }
}
