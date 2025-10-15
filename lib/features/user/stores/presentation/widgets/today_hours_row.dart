// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/models/store_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/tabbar_delegate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class TodayHoursRow extends StatelessWidget {
  const TodayHoursRow({super.key, required this.operating});

  final OperatingTimeModel operating;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final now = DateTime.now();
    final key =
        <int, String>{1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu', 5: 'fri', 6: 'sat', 7: 'sun'}[now
            .weekday]!;

    List<String>? slot;
    switch (key) {
      case 'mon':
        slot = operating.mon;
        break;
      case 'tue':
        slot = operating.tue;
        break;
      case 'wed':
        slot = operating.wed;
        break;
      case 'thu':
        slot = operating.thu;
        break;
      case 'fri':
        slot = operating.fri;
        break;
      case 'sat':
        slot = operating.sat;
        break;
      case 'sun':
        slot = operating.sun;
        break;
    }

    final text =
        (slot == null || slot.length < 2) ? 'Hours unavailable' : 'Today: ${slot[0]} – ${slot[1]}';

    return Row(
      children: [
        const Icon(Icons.access_time_filled_rounded, color: GPSColors.mutedText, size: 18),
        GPSGaps.w8,
        Text(text, style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText)),
      ],
    );
  }
}
