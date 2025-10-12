import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Badge(
        backgroundColor: GPSColors.accent,
        label: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(title, style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
