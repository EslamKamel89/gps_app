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
import 'package:gps_app/features/auth/cubits/vendor_register_cubit.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_register_params/vendor_register_params.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/operating_hour_picker.dart';
import 'package:gps_app/features/auth/presentation/widgets/role_toggle.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/auth/presentation/widgets/vendor_type_select.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _restaurantNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _restaurantAddressCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  SelectedStateAndDistrict _stateAndDistrict = SelectedStateAndDistrict();
  UploadedImage? _profileImage;
  VendorType? vendorType;
  OperatingTimeModel? _operatingTimeModel;
  bool _obscure = true;
  final bool _loading = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _mobileCtrl.dispose();
    _restaurantNameCtrl.dispose();
    _restaurantAddressCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profileImage == null) {
      showSnackbar('Validation Error', "Please select profile image", true);
      return;
    }
    if (_stateAndDistrict.selectedDistrict == null || _stateAndDistrict.selectedState == null) {
      showSnackbar('Validation Error', "You have to select the state and district", true);
      return;
    }

    VendorRegisterParams param = VendorRegisterParams(
      fullName: _fullNameCtrl.text,
      userName: _usernameCtrl.text,
      email: _emailCtrl.text,
      mobile: _mobileCtrl.text,
      password: _passwordCtrl.text,
      stateId: _stateAndDistrict.selectedState?.id,
      districtId: _stateAndDistrict.selectedDistrict?.id,
      imageId: _profileImage?.id,
      address: _restaurantAddressCtrl.text,
      vendorName: _restaurantNameCtrl.text,
      seatingCapacity: int.parse(_capacityCtrl.text),
      userType: _vendorTypeValue(),
      operatingHours: _operatingTimeModel,
    );
    pr(param, "param");
    context.read<VendorRegisterCubit>().register(param: param);
  }

  void _navigateOnRegisterSuccess() {
    if (vendorType == VendorType.restaurant) {
      Navigator.of(context).pushNamed(AppRoutesNames.restaurantOnboardingBranchesScreen);
    } else if (vendorType == VendorType.farm) {
      Navigator.of(context).pushNamed(AppRoutesNames.farmOnboardingProductsScreen);
    } else if (vendorType == VendorType.store) {
      Navigator.of(context).pushNamed(AppRoutesNames.storeOnboardingProductsScreen);
    } else {
      showSnackbar('Error', 'Please select your business type', true);
    }
  }

  String _vendorTypeName() {
    if (vendorType == VendorType.restaurant) {
      return 'Restaurant';
    } else if (vendorType == VendorType.farm) {
      return 'Farm';
    } else if (vendorType == VendorType.store) {
      return 'Store';
    } else {
      return 'Vendor';
    }
  }

  String _vendorTypeValue() {
    if (vendorType == VendorType.restaurant) {
      return 'restaurant';
    } else if (vendorType == VendorType.farm) {
      return 'farm';
    } else if (vendorType == VendorType.store) {
      return 'store';
    } else {
      return 'restaurant';
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
                  const PinLeafLogo(
                    size: 120,
                  ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.9, 0.9)),
                  GPSGaps.h16,
                  Center(
                    child: GpsShortDescription(description: '${_vendorTypeName()} Register'),
                  ).animate().fadeIn(duration: 240.ms).slideY(begin: .08),
                  GPSGaps.h12,
                  RoleToggle(),
                  GPSGaps.h24,

                  VendorTypeSelect(
                    onSelect: (type) {
                      setState(() {
                        vendorType = type;
                      });
                    },
                  ),
                  GPSGaps.h12,
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
                  GpsLabeledField(
                    label: '${_vendorTypeName()} Name',
                    child: TextFormField(
                      controller: _restaurantNameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter restaurant name'),
                      validator:
                          (input) => validator(
                            input: input,
                            label: '${_vendorTypeName()} Name',
                            isRequired: true,
                          ),
                    ),
                  ).animate().fadeIn(duration: 200.ms),

                  GPSGaps.h16,

                  // Full name
                  GpsLabeledField(
                    label: 'Owner Full Name',
                    child: TextFormField(
                      controller: _fullNameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your full name'),
                      validator:
                          (input) =>
                              validator(input: input, label: 'Owner Full Name', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 210.ms),

                  GPSGaps.h16,

                  // Username
                  GpsLabeledField(
                    label: 'Username',
                    child: TextFormField(
                      controller: _usernameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Choose a username'),
                      validator:
                          (input) => validator(input: input, label: 'User Name', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 220.ms),

                  GPSGaps.h16,
                  GpsLabeledField(
                    label: 'Operating hours',
                    child: OperatingHoursPicker(
                      initialValue: OperatingTimeModel(
                        mon: ['08:00', '20:00'],
                        tue: ['08:00', '20:00'],
                        wed: ['08:00', '20:00'],
                        thu: ['08:00', '21:00'],
                        fri: ['08:00', '21:00'],
                        sat: ['09:00', '21:00'],
                        sun: ['09:00', '19:00'],
                      ),
                      onChanged: (val) {
                        pr(val.toString());
                        _operatingTimeModel = val;
                      },
                      buttonText: 'Pick Operating Time',
                      icon: Icons.storefront,
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
                          (input) => validator(input: input, label: 'Email', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 230.ms),

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
                      validator:
                          (input) => validator(input: input, label: 'Password', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 240.ms),

                  GPSGaps.h16,
                  GpsLabeledField(label: 'Select State and District'),
                  GPSGaps.h8,
                  StateDistrictProvider(
                    onSelect: (SelectedStateAndDistrict s) {
                      _stateAndDistrict = s;
                    },
                  ),
                  GPSGaps.h16,

                  // Cuisine Type
                  // GpsLabeledField(
                  //   label: 'Cuisine Type',
                  //   child: DropdownButtonFormField<String>(
                  //     value: _cuisineTypeCtrl.text.isEmpty ? null : _cuisineTypeCtrl.text,
                  //     items:
                  //         _cuisineTypes
                  //             .map(
                  //               (cuisine) =>
                  //                   DropdownMenuItem<String>(value: cuisine, child: Text(cuisine)),
                  //             )
                  //             .toList(),
                  //     onChanged: (v) => setState(() => _cuisineTypeCtrl.text = v ?? ''),
                  //     decoration: _inputDecoration('Select cuisine type'),
                  //     icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  //   ),
                  // ).animate().fadeIn(duration: 250.ms),
                  // GPSGaps.h16,

                  // // Price Range
                  // GpsLabeledField(
                  //   label: 'Price Range',
                  //   child: DropdownButtonFormField<String>(
                  //     value: _priceRange,
                  //     items:
                  //         _priceRanges
                  //             .map(
                  //               (range) =>
                  //                   DropdownMenuItem<String>(value: range, child: Text(range)),
                  //             )
                  //             .toList(),
                  //     onChanged: (v) => setState(() => _priceRange = v),
                  //     decoration: _inputDecoration('Select price range'),
                  //     icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  //   ),
                  // ).animate().fadeIn(duration: 260.ms),
                  // GPSGaps.h16,
                  GpsLabeledField(
                    label: '${_vendorTypeName()} Address',
                    child: TextFormField(
                      controller: _restaurantAddressCtrl,
                      textInputAction: TextInputAction.next,
                      maxLines: 2,
                      decoration: _inputDecoration('Enter full address'),
                      validator:
                          (input) => validator(input: input, label: 'Address', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 270.ms),

                  // GPSGaps.h16,
                  GPSGaps.h16,

                  // Mobile
                  GpsLabeledField(
                    label: 'Mobile',
                    child: TextFormField(
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your mobile number'),
                      validator:
                          (input) => validator(input: input, label: 'Mobile', isRequired: true),
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  GPSGaps.h16,

                  // Capacity
                  GpsLabeledField(
                    label: 'Seating Capacity',
                    child: TextFormField(
                      controller: _capacityCtrl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter seating capacity'),
                    ),
                  ).animate().fadeIn(duration: 310.ms),

                  GPSGaps.h16,

                  // // Service Options
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Service Options',
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w600,
                  //         color: GPSColors.mutedText,
                  //       ),
                  //     ),
                  //     GPSGaps.h8,
                  //     Row(
                  //       children: [
                  //         // Delivery
                  //         Expanded(
                  //           child: FilterChip(
                  //             label: const Text('Delivery'),
                  //             selected: _hasDelivery,
                  //             onSelected: (selected) => setState(() => _hasDelivery = selected),
                  //             checkmarkColor: Colors.white,
                  //             selectedColor: GPSColors.primary,
                  //             labelStyle: TextStyle(
                  //               color: _hasDelivery ? Colors.white : GPSColors.mutedText,
                  //             ),
                  //           ),
                  //         ),
                  //         GPSGaps.w8,
                  //         // Takeaway
                  //         Expanded(
                  //           child: FilterChip(
                  //             label: const Text('Takeaway'),
                  //             selected: _hasTakeaway,
                  //             onSelected: (selected) => setState(() => _hasTakeaway = selected),
                  //             checkmarkColor: Colors.white,
                  //             selectedColor: GPSColors.primary,
                  //             labelStyle: TextStyle(
                  //               color: _hasTakeaway ? Colors.white : GPSColors.mutedText,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ).animate().fadeIn(duration: 330.ms),
                  GPSGaps.h20,

                  // Register button
                  BlocConsumer<VendorRegisterCubit, ApiResponseModel<UserModel>>(
                    listener: (context, state) {
                      if (state.response == ResponseEnum.success && state.data != null) {
                        _navigateOnRegisterSuccess();
                      }
                    },
                    builder: (context, state) {
                      Widget child;
                      if (state.response == ResponseEnum.loading) {
                        child = const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
                          onPressed: state.response == ResponseEnum.loading ? null : _onRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GPSColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: child,
                        ),
                      );
                    },
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
