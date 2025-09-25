// features/vendor_onboarding/screens/vendor_onboarding_branches_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/branch.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/branch_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantOnboardingBranchesScreen extends StatefulWidget {
  const RestaurantOnboardingBranchesScreen({super.key});

  @override
  State<RestaurantOnboardingBranchesScreen> createState() =>
      _RestaurantOnboardingBranchesScreenState();
}

class _RestaurantOnboardingBranchesScreenState
    extends State<RestaurantOnboardingBranchesScreen> {
  final List<VendorBranch> _branches = [VendorBranch.empty()];

  void _addBranch() {
    setState(() {
      _branches.add(VendorBranch.empty());
    });
  }

  void _removeBranch(VendorBranch branch) {
    setState(() {
      _branches.remove(branch);
    });
  }

  void _onBranchChanged(VendorBranch updated) {
    final index = _branches.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      setState(() {
        _branches[index] = updated;
      });
    }
  }

  bool get _isNextEnabled {
    return true;
    return _branches.isNotEmpty &&
        _branches.every(
          (b) => b.branchName.isNotEmpty && b.phoneNumber.isNotEmpty,
        );
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
                    'Step 1 of 3',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GPSColors.mutedText,
                    ),
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
                    ..._branches.map((branch) {
                      return BranchCard(
                        branch: branch,
                        onDelete: () => _removeBranch(branch),
                        onChanged: _onBranchChanged,
                      );
                    }),

                    // Add Another
                    GPSGaps.h12,
                    AddButton(label: '➕ Add Another Branch', onTap: _addBranch),
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
                  OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('← Previous'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        _isNextEnabled
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Proceeding to next step..."),
                                ),
                              );
                              // Navigate to Menu Step
                              Navigator.of(context).pushNamed(
                                AppRoutesNames.restaurantOnboardingMenuScreen,
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
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
