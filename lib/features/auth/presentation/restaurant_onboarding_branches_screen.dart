// features/vendor_onboarding/screens/vendor_onboarding_branches_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/features/auth/cubits/create_restaurant_branches/create_restaurant_branches_cubit.dart';
import 'package:gps_app/features/auth/models/branch_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/branch_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';

class RestaurantOnboardingBranchesScreen extends StatefulWidget {
  const RestaurantOnboardingBranchesScreen({super.key});

  @override
  State<RestaurantOnboardingBranchesScreen> createState() =>
      _RestaurantOnboardingBranchesScreenState();
}

class _RestaurantOnboardingBranchesScreenState extends State<RestaurantOnboardingBranchesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: BlocConsumer<CreateRestaurantBranchesCubit, CreateRestaurantBranchesState>(
        listener: (context, state) {
          if (state.branchesResponse.response == ResponseEnum.success) {
            // Navigator.of(
            //   context,
            // ).pushNamed(AppRoutesNames.restaurantOnboardingMenuScreen);
            Navigator.of(context).maybePop();
            context.read<RestaurantCubit>().restaurant(
              restaurantId: userInMemory()?.restaurant?.id ?? -1,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateRestaurantBranchesCubit>();
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Step 1 of 3',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
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
                            '📍 Add Your Restaurant Branches',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: GPSColors.primary,
                            ),
                          ),
                          GPSGaps.h8,
                          Text(
                            'Let’s set up all your restaurant locations. You can add multiple branches below.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: GPSColors.mutedText,
                              height: 1.4,
                            ),
                          ),
                          GPSGaps.h24,

                          // Branch Cards
                          ...state.branches.map((branch) {
                            return BranchCard(
                              branch: branch,
                              onDelete: () => cubit.removeBranch(branchParam: branch),
                            );
                          }),

                          // Add Another
                          GPSGaps.h12,
                          AddButton(
                            label: 'Add Another Branch',
                            onTap: () => cubit.addBranch(branchParam: BranchParam()),
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
                            return cubit.state.branchesResponse.response == ResponseEnum.loading
                                ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                                : ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;
                                    cubit.createBranches();
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
                                  child: const Text('Save'),
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
