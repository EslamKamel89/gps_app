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
import 'package:gps_app/features/favorites/presentation/favorites_screen.dart';
import 'package:gps_app/features/favorites/presentation/widgets/detail_row.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpandedDetails extends StatelessWidget {
  final String? ownerName;
  final String? mobile;
  final String? email;
  final String? address;
  final int? seatingCapacity;

  const ExpandedDetails({
    super.key,
    required this.ownerName,
    required this.mobile,
    required this.email,
    required this.address,
    required this.seatingCapacity,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      DetailRow(icon: MdiIcons.accountCircleOutline, label: 'Owner', value: ownerName),
      DetailRow(icon: MdiIcons.phone, label: 'Mobile', value: mobile),
      DetailRow(icon: MdiIcons.emailOutline, label: 'Email', value: email),
      DetailRow(icon: MdiIcons.mapMarkerOutline, label: 'Address', value: address, multiline: true),
      if (seatingCapacity != null)
        DetailRow(icon: MdiIcons.seatOutline, label: 'Seating', value: '$seatingCapacity'),
    ];

    return Column(children: [GPSGaps.h8, ...rows.separatedBy(() => GPSGaps.h8)]);
  }
}
