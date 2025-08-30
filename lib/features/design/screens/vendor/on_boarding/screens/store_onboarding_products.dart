// features/vendor_onboarding/screens/vendor_onboarding_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/category.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/category_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StoreOnboardingProductsScreen extends StatefulWidget {
  const StoreOnboardingProductsScreen({super.key});

  @override
  State<StoreOnboardingProductsScreen> createState() => _StoreOnboardingProductsScreenState();
}

class _StoreOnboardingProductsScreenState extends State<StoreOnboardingProductsScreen> {
  final List<Category> _categories = [Category.empty()];

  void _addCategory() {
    setState(() {
      _categories.add(Category.empty());
    });
  }

  void _removeCategory(Category category) {
    setState(() {
      _categories.remove(category);
    });
  }

  void _onCategoryChanged(Category updated) {
    final index = _categories.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      setState(() {
        _categories[index] = updated;
      });
    }
  }

  bool get _isNextEnabled {
    return true;
    return _categories.isNotEmpty && _categories.any((m) => m.menuName.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            Expanded(
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

                    ..._categories.map((category) {
                      return CategoryCard(
                        category: category,
                        onDelete: () => _removeCategory(category),
                        onChanged: _onCategoryChanged,
                      );
                    }),

                    GPSGaps.h12,
                    AddButton(label: 'Add Another Category', onTap: _addCategory),
                    GPSGaps.h24,
                  ],
                ),
              ),
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
