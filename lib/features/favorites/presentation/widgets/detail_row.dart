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

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool multiline;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: GPSColors.primary),
        GPSGaps.w8,
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: TextStyle(
                    color: GPSColors.mutedText,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            maxLines: multiline ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
