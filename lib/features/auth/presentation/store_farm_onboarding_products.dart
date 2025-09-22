// features/vendor_onboarding/screens/vendor_onboarding_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/cubits/create_catalog_section_items/create_catalog_section_items_cubit.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/section_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StoreFarmOnboardingProductsScreen extends StatefulWidget {
  const StoreFarmOnboardingProductsScreen({super.key});

  @override
  State<StoreFarmOnboardingProductsScreen> createState() =>
      _StoreFarmOnboardingProductsScreenState();
}

class _StoreFarmOnboardingProductsScreenState extends State<StoreFarmOnboardingProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                  if (state.sectionsResponse.response == ResponseEnum.success) {
                    Navigator.of(context).pushNamed(AppRoutesNames.homeSearchScreen);
                  }
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: GPSColors.mutedText,
                              height: 1.4,
                            ),
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
                    Builder(
                      builder: (context) {
                        final cubit = context.watch<CreateCatalogSectionItemsCubit>();
                        return cubit.state.sectionsResponse.response == ResponseEnum.loading
                            ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Center(child: CircularProgressIndicator()),
                            )
                            : ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                cubit.createCatalogSection();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text('Next →'),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
        ),
      ),
    );
  }
}
