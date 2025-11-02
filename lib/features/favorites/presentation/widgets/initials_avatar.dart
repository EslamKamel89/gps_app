// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/models/favourtie_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        style: TextStyle(color: GPSColors.text, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ).animate().shimmer(duration: 800.ms, delay: 50.ms); // subtle glint
  }
}
