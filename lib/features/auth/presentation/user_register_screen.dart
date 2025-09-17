import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/cubits/user_register_cubit.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/user_register_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/role_toggle.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  UploadedImage? _profileImage;
  SelectedStateAndDistrict _stateAndDistrict = SelectedStateAndDistrict();
  bool _obscure = true;
  final bool _loading = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profileImage == null) {
      showSnackbar('Validation Error', "Please select profile image", true);
      return;
    }
    if (_stateAndDistrict.selectedDistrict == null ||
        _stateAndDistrict.selectedState == null) {
      showSnackbar(
        'Validation Error',
        "You have to select the state and district",
        true,
      );
      return;
    }
    UserRegisterParam param = UserRegisterParam(
      fullName: _fullNameCtrl.text,
      userName: _usernameCtrl.text,
      email: _emailCtrl.text,
      mobile: _mobileCtrl.text,
      password: _passwordCtrl.text,
      stateId: _stateAndDistrict.selectedState?.id,
      districtId: _stateAndDistrict.selectedDistrict?.id,
      imageId: _profileImage?.id,
    );
    pr(param, "param");
    context.read<UserRegisterCubit>().register(param: param);
    // return;
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
                  const PinLeafLogo(size: 120)
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  GPSGaps.h16,
                  Center(
                    child: GpsShortDescription(),
                  ).animate().fadeIn(duration: 240.ms).slideY(begin: .08),
                  GPSGaps.h12,
                  RoleToggle(),
                  GPSGaps.h24,

                  ImageUploadField(
                    multiple: false,
                    // maxCount: 6,
                    resource: UploadResource.user,
                    initial: const [],
                    onChanged: (images) {
                      if (images.isEmpty) return;
                      _profileImage = images[0];
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
                      validator:
                          (input) => validator(
                            input: input,
                            label: 'Full Name',
                            isRequired: true,
                          ),
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
                      validator:
                          (input) => validator(
                            input: input,
                            label: 'Username',
                            isRequired: true,
                          ),
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
                      validator:
                          (input) => validator(
                            input: input,
                            label: 'Email',
                            isRequired: true,
                            isEmail: true,
                          ),
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
                      decoration: _inputDecoration(
                        'Create a password',
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: GPSColors.mutedText,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator:
                          (input) => validator(
                            input: input,
                            label: 'Password',
                            isRequired: true,
                          ),
                    ),
                  ),

                  GPSGaps.h16,
                  GpsLabeledField(label: 'Select State and District'),
                  GPSGaps.h8,
                  StateDistrictProvider(
                    onSelect: (SelectedStateAndDistrict s) {
                      _stateAndDistrict = s;
                    },
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
                      validator:
                          (input) => validator(
                            input: input,
                            label: 'Mobile',
                            isRequired: true,
                          ),
                    ),
                  ),

                  GPSGaps.h20,

                  BlocConsumer<UserRegisterCubit, ApiResponseModel<UserModel>>(
                        listener: (context, state) {
                          if (state.response == ResponseEnum.success &&
                              state.data != null) {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutesNames.dietSelectionScreen,
                            );
                          }
                        },
                        builder: (context, state) {
                          Widget child;
                          if (state.response == ResponseEnum.loading) {
                            child = const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            child = const Text(
                              'Create Account',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            );
                          }
                          return SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  state.response == ResponseEnum.loading
                                      ? null
                                      : _onRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GPSColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      )
                      .animate()
                      .fadeIn(duration: 280.ms, delay: 90.ms)
                      .slideY(begin: .08),

                  GPSGaps.h16,

                  // Already have account? Sign in
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: GPSColors.mutedText,
                        ),
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
                                      ).pushReplacementNamed(
                                        AppRoutesNames.loginScreen,
                                      ),
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
