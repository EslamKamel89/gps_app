import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = Icon(MdiIcons.heartOutline, size: 56, color: GPSColors.mutedText);
    final text = Text(
      'No favorites exist',
      style: TextStyle(color: GPSColors.mutedText, fontSize: 15, fontWeight: FontWeight.w600),
    );

    return Container(
      alignment: Alignment.center,
      height: context.height * 0.7,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GPSGaps.h24,
          icon
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.96, 0.96),
                end: const Offset(1.04, 1.04),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          GPSGaps.h12,
          text.animate().fadeIn(duration: 350.ms),
        ],
      ),
    );
  }
}
