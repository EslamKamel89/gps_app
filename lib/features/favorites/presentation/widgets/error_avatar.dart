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

class ErrorAvatar extends StatelessWidget {
  final double size;
  const ErrorAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.4),
        border: Border.all(color: GPSColors.cardBorder),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.broken_image_outlined, color: GPSColors.mutedText),
    );
  }
}
