import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

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
