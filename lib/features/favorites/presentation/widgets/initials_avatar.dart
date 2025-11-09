import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class InitialsAvatar extends StatelessWidget {
  final double size;
  final String initials;
  const InitialsAvatar({super.key, required this.size, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected,
        border: Border.all(color: GPSColors.cardBorder),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: GPSColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ).animate().shimmer(duration: 800.ms, delay: 50.ms); // subtle glint
  }
}
