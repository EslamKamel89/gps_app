// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/tag_chip.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';

class WishTextBox extends StatelessWidget {
  const WishTextBox({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        controller: controller,
        minLines: 3,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
        style: txt.bodyMedium?.copyWith(
          color: GPSColors.text,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        decoration: const InputDecoration(
          hintText: 'e.g., “I love vegan pizza” or “Gluten-free falafel wrap”',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
