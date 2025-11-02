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

class Chevron extends StatelessWidget {
  final bool expanded;
  const Chevron({super.key, required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        RotateEffect(begin: expanded ? 0.5 : 0, duration: 220.ms, curve: Curves.easeOut),
        FadeEffect(duration: 150.ms),
      ],
      child: Icon(Icons.keyboard_arrow_down_rounded, color: GPSColors.mutedText, size: 24),
    );
  }
}
