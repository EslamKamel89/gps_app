import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class Chevron extends StatelessWidget {
  final bool expanded;
  const Chevron({super.key, required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        RotateEffect(
          begin: expanded ? 0.5 : 0,
          duration: 220.ms,
          curve: Curves.easeOut,
        ),
        FadeEffect(duration: 150.ms),
      ],
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: GPSColors.mutedText,
        size: 24,
      ),
    );
  }
}
