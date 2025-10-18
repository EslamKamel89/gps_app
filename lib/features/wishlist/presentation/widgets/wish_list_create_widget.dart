// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/tag_chip.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/diet_tag_selector.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_text_box.dart';

class WishListCreateWidget extends StatefulWidget {
  const WishListCreateWidget({super.key});

  @override
  State<WishListCreateWidget> createState() => _WishListCreateWidgetState();
}

class _WishListCreateWidgetState extends State<WishListCreateWidget> {
  final _controller = TextEditingController();

  static const List<String> _allDietTags = <String>[
    'Vegan',
    'Vegetarian',
    'Organic',
    'Gluten-free',
    'Dairy-free',
    'Halal',
  ];

  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.wishList, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Describe your wish',
          style: txt.labelMedium?.copyWith(
            color: GPSColors.mutedText,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

        GPSGaps.h8,

        WishTextBox(controller: _controller)
            .animate()
            .fadeIn(duration: 240.ms)
            .slideY(begin: .06)
            .scale(begin: const Offset(.98, .98)),

        GPSGaps.h16,

        Text(
          'Dietary tags',
          style: txt.labelMedium?.copyWith(
            color: GPSColors.mutedText,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

        GPSGaps.h8,

        DietTagSelector(
          allTags: _allDietTags,
          selected: _selectedTags,
          onChanged: (tag, isSelected) {
            setState(() {
              if (isSelected) {
                _selectedTags.add(tag);
              } else {
                _selectedTags.remove(tag);
              }
            });
          },
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        if (_selectedTags.isNotEmpty) ...[
          GPSGaps.h12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((t) => TagChip(label: t)).toList(growable: false),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
        ],

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
    );
  }
}
