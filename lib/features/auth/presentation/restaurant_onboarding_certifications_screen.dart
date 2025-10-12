// features/vendor_onboarding/screens/vendor_onboarding_certifications_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/cubits/create_restaurant_certifications/create_restaurant_certificates_cubit.dart';
import 'package:gps_app/features/auth/models/certificate_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/certificate_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantOnboardingCertificationsScreen extends StatefulWidget {
  const RestaurantOnboardingCertificationsScreen({super.key});

  @override
  State<RestaurantOnboardingCertificationsScreen> createState() =>
      _RestaurantOnboardingCertificationsScreenState();
}

class _RestaurantOnboardingCertificationsScreenState
    extends State<RestaurantOnboardingCertificationsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: BlocConsumer<
        CreateRestaurantCertificatesCubit,
        CreateRestaurantCertificatesState
      >(
        listener: (context, state) {
          if (state.certificatesResponse.response == ResponseEnum.success) {
            Navigator.of(
              context,
            ).pushNamed(AppRoutesNames.categorySelectionScreen);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateRestaurantCertificatesCubit>();
          return Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Step 3 of 3',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: GPSColors.mutedText),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            '📄 Add Your Certifications & Proofs',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          GPSGaps.h8,
                          Text(
                            'Upload licenses, permits, or certifications that verify your business or farm practices.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: GPSColors.mutedText,
                              height: 1.4,
                            ),
                          ),
                          GPSGaps.h24,

                          // Proof Cards
                          ...state.certificates.map((certificate) {
                            return CertificateCard(
                              certificate: certificate,
                              onDelete:
                                  () => cubit.removeCertificate(
                                    param: certificate,
                                  ),
                            );
                          }),

                          // Add Another Proof
                          GPSGaps.h12,
                          AddButton(
                            label: 'Add Another Proof',
                            onTap:
                                () => cubit.addCertificate(
                                  param: CertificateParam(),
                                ),
                          ),
                          GPSGaps.h24,
                        ],
                      ),
                    ),
                  ),

                  // Footer Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Spacer(),
                        Builder(
                          builder: (context) {
                            return cubit.state.certificatesResponse.response ==
                                    ResponseEnum.loading
                                ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    cubit.createCertificate();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GPSColors.accent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text('Next →'),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
            ),
          );
        },
      ),
    );
  }
}
