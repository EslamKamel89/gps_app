import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

AppBar profileAppBar({required String title}) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Colors.black)),
    backgroundColor: GPSColors.primary.withOpacity(0.2),
    foregroundColor: Colors.black,
  );
}
