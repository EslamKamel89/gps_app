import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/presentation/widgets/role_toggle.dart';
import 'package:gps_app/features/design/screens/user/register/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  bool _obscure = true;
  final bool _loading = false;

  // Sample real-ish data for dependent dropdowns
  final Map<String, List<String>> _countryCities = const {
    'United States': ['New York', 'Los Angeles', 'Austin', 'Miami'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal'],
    // 'Egypt': ['Cairo', 'Alexandria', 'Giza'],
  };

  String? _selectedCountry;
  String? _selectedCity;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  void _onCountryChanged(String? country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null; // reset city when country changes
    });
  }

  Future<void> _onRegister() async {
    Navigator.of(context).pushReplacementNamed(AppRoutesNames.dietSelectionScreen);
  }

  @override
  Widget build(BuildContext context) {
    final cities =
        _selectedCountry == null
            ? const <String>[]
            : _countryCities[_selectedCountry] ?? const <String>[];

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
                  const PinLeafLogo(
                    size: 120,
                  ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.9, 0.9)),
                  GPSGaps.h16,
                  Center(
                    child: GpsShortDescription(),
                  ).animate().fadeIn(duration: 240.ms).slideY(begin: .08),
                  GPSGaps.h12,
                  RoleToggle(isInLoginScreen: false),
                  GPSGaps.h24,

                  ImageUploadField(
                    multiple: false,
                    // maxCount: 6,
                    resource: UploadResource.user,
                    initial: const [],
                    onChanged: (images) {
                      pr(images, 'images');
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Text('Tap to upload your profile image'),
                    ),
                  ),

                  GPSGaps.h12,
                  // Full name
                  GpsLabeledField(
                    label: 'Full name',
                    child: TextFormField(
                      controller: _fullNameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your full name'),
                    ),
                  ),

                  GPSGaps.h16,

                  // Username
                  GpsLabeledField(
                    label: 'Username',
                    child: TextFormField(
                      controller: _usernameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Choose a username'),
                    ),
                  ),

                  GPSGaps.h16,

                  // Email
                  GpsLabeledField(
                    label: 'Email',
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your email'),
                    ),
                  ),

                  GPSGaps.h16,

                  // Password
                  GpsLabeledField(
                    label: 'Password',
                    child: TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Create a password').copyWith(
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

                  // GPSGaps.h16,
                  AnimatedSwitcher(
                    duration: 250.ms,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child:
                        _selectedCountry == null
                            ? const SizedBox.shrink()
                            : Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: GpsLabeledField(
                                key: const ValueKey('city-field'),
                                label: 'City',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCity,
                                  items:
                                      cities
                                          .map(
                                            (city) => DropdownMenuItem<String>(
                                              value: city,
                                              child: Text(city),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) => setState(() => _selectedCity = v),
                                  decoration: _inputDecoration('Select your city'),
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                ),
                              ),
                            ),
                  ).animate().fadeIn(duration: 220.ms),

                  GPSGaps.h16,
                  GpsLabeledField(
                    label: 'Country',
                    child: DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      items:
                          _countryCities.keys
                              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                              .toList(),
                      onChanged: _onCountryChanged,
                      decoration: _inputDecoration('Select your country'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),

                  GPSGaps.h16,

                  // Mobile
                  GpsLabeledField(
                    label: 'Mobile',
                    child: TextFormField(
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Enter your mobile number'),
                    ),
                  ),

                  GPSGaps.h20,

                  // Register button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onRegister,
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
                              : const Text(
                                'Create Account',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                    ),
                  ).animate().fadeIn(duration: 280.ms, delay: 90.ms).slideY(begin: .08),

                  GPSGaps.h16,

                  // Already have account? Sign in
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: GPSColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap =
                                      () => Navigator.of(
                                        context,
                                      ).pushReplacementNamed(AppRoutesNames.loginScreen),
                          ),
                        ],
                      ),
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
