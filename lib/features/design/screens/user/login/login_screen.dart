import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/login/widgets/labeled_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  final bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    Navigator.of(context).pushNamed(AppRoutesNames.dietSelectionScreen);
    // if (!(_formKey.currentState?.validate() ?? false)) return;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PinLeafLogo(size: 140),
                  GPSGaps.h24,
                  Center(child: GpsShortDescription()),
                  GPSGaps.h24,

                  LabeledField(
                    label: 'Email or Username',
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your email or username'),
                    ),
                  ),

                  GPSGaps.h16,

                  LabeledField(
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
                    ),
                  ),

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
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed(AppRoutesNames.registerScreen);
                                },
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
                          recognizer: TapGestureRecognizer()..onTap = () {},
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
