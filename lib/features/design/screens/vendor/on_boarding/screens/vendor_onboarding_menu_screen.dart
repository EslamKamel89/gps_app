// features/vendor_onboarding/screens/vendor_onboarding_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/menu.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/menu_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class VendorOnboardingMenuScreen extends StatefulWidget {
  const VendorOnboardingMenuScreen({super.key});

  @override
  State<VendorOnboardingMenuScreen> createState() => _VendorOnboardingMenuScreenState();
}

class _VendorOnboardingMenuScreenState extends State<VendorOnboardingMenuScreen> {
  final List<VendorMenu> _menus = [VendorMenu.empty()];

  void _addMenu() {
    setState(() {
      _menus.add(VendorMenu.empty());
    });
  }

  void _removeMenu(VendorMenu menu) {
    setState(() {
      _menus.remove(menu);
    });
  }

  void _onMenuChanged(VendorMenu updated) {
    final index = _menus.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      setState(() {
        _menus[index] = updated;
      });
    }
  }

  bool get _isNextEnabled {
    return true;
    return _menus.isNotEmpty && _menus.any((m) => m.menuName.isNotEmpty);
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
                    'Step 2 of 3',
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
                      'Create Your Menus',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    GPSGaps.h8,
                    Text(
                      'Add menus and items that customers will see. You can create multiple menus (e.g., Lunch, Dinner).',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.4),
                    ),
                    GPSGaps.h24,

                    // Menu Cards
                    ..._menus.map((menu) {
                      return MenuCard(
                        menu: menu,
                        onDelete: () => _removeMenu(menu),
                        onChanged: _onMenuChanged,
                      );
                    }),

                    // Add Another Menu
                    GPSGaps.h12,
                    AddButton(label: 'Add Another Menu', onTap: _addMenu),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Proceeding to certifications...")),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (_) => VendorOnboardingCertificationsScreen()));
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
