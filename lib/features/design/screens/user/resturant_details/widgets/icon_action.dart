import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class IconAction extends StatelessWidget {
  const IconAction({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: GPSColors.text),
      ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.96, .96)),
    );
  }
}
