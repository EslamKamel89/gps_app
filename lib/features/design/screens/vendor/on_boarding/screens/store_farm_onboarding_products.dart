// features/vendor_onboarding/screens/vendor_onboarding_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/auth/cubits/create_catalog_section_items/create_catalog_section_items_cubit.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/section_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StoreFarmOnboardingProductsScreen extends StatefulWidget {
  const StoreFarmOnboardingProductsScreen({super.key});

  @override
  State<StoreFarmOnboardingProductsScreen> createState() =>
      _StoreFarmOnboardingProductsScreenState();
}

class _StoreFarmOnboardingProductsScreenState extends State<StoreFarmOnboardingProductsScreen> {
  bool get _isNextEnabled {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  Text(
                    'Store',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                  ),
                ],
              ),
            ),

            BlocConsumer<CreateCatalogSectionItemsCubit, CreateCatalogSectionItemsState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                final cubit = context.read<CreateCatalogSectionItemsCubit>();
                return Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Your Categories',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        GPSGaps.h8,
                        Text(
                          "Let's build your store! Create categories and add your products to show customers what you offer",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.4),
                        ),
                        GPSGaps.h24,

                        ...state.sections.map((section) {
                          return SectionCard(
                            section: section,
                            onDelete: () => cubit.removeSection(sectionParam: section),
                          );
                        }),

                        GPSGaps.h12,
                        AddButton(
                          label: 'Add Another Category',
                          onTap:
                              () => cubit.addSection(
                                sectionParam: CatalogSectionParam(
                                  catalogItems: [CatalogItemParam()],
                                ),
                              ),
                        ),
                        GPSGaps.h24,
                      ],
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('← Previous'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        _isNextEnabled
                            ? () {
                              context.read<CreateCatalogSectionItemsCubit>().createCatalogSection();
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text("Proceeding to certifications...")),
                              // );
                              // Navigator.of(
                              //   context,
                              // ).pushNamed(AppRoutesNames.restaurantOnboardingCertificationsScreen);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Next →'),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
      ),
    );
  }
}
