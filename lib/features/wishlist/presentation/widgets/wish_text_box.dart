import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class WishTextBox extends StatelessWidget {
  const WishTextBox({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
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
