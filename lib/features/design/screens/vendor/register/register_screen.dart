import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/role_toggle.dart';
import 'package:gps_app/features/design/screens/vendor/register/widgets/vendor_type_select.dart';
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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _restaurantNameCtrl = TextEditingController();
  final _restaurantAddressCtrl = TextEditingController();
  final _cuisineTypeCtrl = TextEditingController();
  final _openingHoursCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  VendorType? vendorType;

  bool _obscure = true;
  final bool _loading = false;
  bool _hasDelivery = true;
  bool _hasTakeaway = true;
  String? _priceRange;

  // Sample real-ish data for dependent dropdowns
  final Map<String, List<String>> _countryCities = const {
    'United States': ['New York', 'Los Angeles', 'Austin', 'Miami'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal'],
  };

  final List<String> _cuisineTypes = const [
    'Italian',
    'Mexican',
    'Chinese',
    'Indian',
    'American',
    'Japanese',
    'Mediterranean',
    'Thai',
    'French',
    'Other',
  ];

  final List<String> _priceRanges = const ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  String? _selectedCountry;
  String? _selectedCity;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _mobileCtrl.dispose();
    _restaurantNameCtrl.dispose();
    _restaurantAddressCtrl.dispose();
    _cuisineTypeCtrl.dispose();
    _openingHoursCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  void _onCountryChanged(String? country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null; // reset city when country changes
    });
  }

  Future<void> _onRegister() async {
    if (vendorType == VendorType.restaurant) {
      Navigator.of(
        context,
      ).pushNamed(AppRoutesNames.restaurantOnboardingBranchesScreen);
    } else if (vendorType == VendorType.farm) {
      Navigator.of(
        context,
      ).pushNamed(AppRoutesNames.farmOnboardingProductsScreen);
    } else if (vendorType == VendorType.store) {
      Navigator.of(
        context,
      ).pushNamed(AppRoutesNames.storeOnboardingProductsScreen);
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
                  const PinLeafLogo(size: 120)
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  GPSGaps.h16,
                  Center(
                    child: GpsShortDescription(
                      description: '${_vendorTypeName()} Register',
                    ),
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
                  GpsLabeledField(
                    label: '${_vendorTypeName()} Name',
                    child: TextFormField(
                      controller: _restaurantNameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter restaurant name'),
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
                    ),
                  ).animate().fadeIn(duration: 220.ms),

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
                  ).animate().fadeIn(duration: 230.ms),

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
                    ),
                  ).animate().fadeIn(duration: 240.ms),

                  GPSGaps.h16,

                  // Cuisine Type
                  GpsLabeledField(
                    label: 'Cuisine Type',
                    child: DropdownButtonFormField<String>(
                      value:
                          _cuisineTypeCtrl.text.isEmpty
                              ? null
                              : _cuisineTypeCtrl.text,
                      items:
                          _cuisineTypes
                              .map(
                                (cuisine) => DropdownMenuItem<String>(
                                  value: cuisine,
                                  child: Text(cuisine),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (v) =>
                              setState(() => _cuisineTypeCtrl.text = v ?? ''),
                      decoration: _inputDecoration('Select cuisine type'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ).animate().fadeIn(duration: 250.ms),

                  GPSGaps.h16,

                  // Price Range
                  GpsLabeledField(
                    label: 'Price Range',
                    child: DropdownButtonFormField<String>(
                      value: _priceRange,
                      items:
                          _priceRanges
                              .map(
                                (range) => DropdownMenuItem<String>(
                                  value: range,
                                  child: Text(range),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _priceRange = v),
                      decoration: _inputDecoration('Select price range'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ).animate().fadeIn(duration: 260.ms),

                  GPSGaps.h16,

                  GpsLabeledField(
                    label: '${_vendorTypeName()} Address',
                    child: TextFormField(
                      controller: _restaurantAddressCtrl,
                      textInputAction: TextInputAction.next,
                      maxLines: 2,
                      decoration: _inputDecoration('Enter full address'),
                    ),
                  ).animate().fadeIn(duration: 270.ms),

                  GPSGaps.h16,

                  // Country
                  GpsLabeledField(
                    label: 'Country',
                    child: DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      items:
                          _countryCities.keys
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(c),
                                ),
                              )
                              .toList(),
                      onChanged: _onCountryChanged,
                      decoration: _inputDecoration('Select your country'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ).animate().fadeIn(duration: 280.ms),

                  // City (conditional)
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
                                  onChanged:
                                      (v) => setState(() => _selectedCity = v),
                                  decoration: _inputDecoration(
                                    'Select your city',
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ),
                              ),
                            ),
                  ).animate().fadeIn(duration: 290.ms),

                  GPSGaps.h16,

                  // Mobile
                  GpsLabeledField(
                    label: 'Mobile',
                    child: TextFormField(
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Enter your mobile number'),
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

                  // Opening Hours
                  GpsLabeledField(
                    label: 'Opening Hours',
                    child: TextFormField(
                      controller: _openingHoursCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('e.g., 9:00 AM - 10:00 PM'),
                    ),
                  ).animate().fadeIn(duration: 320.ms),

                  GPSGaps.h16,

                  // Service Options
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Options',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: GPSColors.mutedText,
                        ),
                      ),
                      GPSGaps.h8,
                      Row(
                        children: [
                          // Delivery
                          Expanded(
                            child: FilterChip(
                              label: const Text('Delivery'),
                              selected: _hasDelivery,
                              onSelected:
                                  (selected) =>
                                      setState(() => _hasDelivery = selected),
                              checkmarkColor: Colors.white,
                              selectedColor: GPSColors.primary,
                              labelStyle: TextStyle(
                                color:
                                    _hasDelivery
                                        ? Colors.white
                                        : GPSColors.mutedText,
                              ),
                            ),
                          ),
                          GPSGaps.w8,
                          // Takeaway
                          Expanded(
                            child: FilterChip(
                              label: const Text('Takeaway'),
                              selected: _hasTakeaway,
                              onSelected:
                                  (selected) =>
                                      setState(() => _hasTakeaway = selected),
                              checkmarkColor: Colors.white,
                              selectedColor: GPSColors.primary,
                              labelStyle: TextStyle(
                                color:
                                    _hasTakeaway
                                        ? Colors.white
                                        : GPSColors.mutedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(duration: 330.ms),

                  GPSGaps.h20,

                  // Register button
                  SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GPSColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
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
                                  : Text(
                                    'Create ${_vendorTypeName()} Account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 340.ms, delay: 90.ms)
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
