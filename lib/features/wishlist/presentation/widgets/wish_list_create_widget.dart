// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/presentation/widgets/labeled_field.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/tag_chip.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/diet_tag_selector.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_text_box.dart';

class WishListCreateWidget extends StatefulWidget {
  const WishListCreateWidget({super.key});

  @override
  State<WishListCreateWidget> createState() => _WishListCreateWidgetState();
}

class _WishListCreateWidgetState extends State<WishListCreateWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() {}

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Text(
            'Let’s make it happen — what’s your wish?',
            style: txt.labelMedium?.copyWith(
              color: GPSColors.mutedText,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

          GPSGaps.h8,

          LabeledField(
                label: 'Make a wish come true',
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) => validator(input: v, label: 'Wish', isRequired: true),
                  decoration: _inputDecoration(
                    'e.g., “I love vegan pizza” or “Gluten-free falafel wrap”',
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 240.ms)
              .slideY(begin: .06)
              .scale(begin: const Offset(.98, .98)),

          GPSGaps.h16,

          CategorySelectorProvider(onSelect: (_) {}),
          GPSGaps.h24,

          Row(
            children: [
              OutlinedButton(
                onPressed: _onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: GPSColors.text,
                  side: const BorderSide(color: GPSColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
              ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),

              GPSGaps.w12,

              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GPSColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800)),
              ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.98, .98)),
            ],
          ),
        ],
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
