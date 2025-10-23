import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class LogoBox extends StatelessWidget {
  const LogoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: GPSColors.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: GPSColors.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
