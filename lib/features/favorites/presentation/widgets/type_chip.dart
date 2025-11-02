// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const TypeChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: GPSColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: GPSColors.accent),
              GPSGaps.w4,
              Text(
                label,
                style: TextStyle(
                  color: GPSColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 200.ms);
  }
}
