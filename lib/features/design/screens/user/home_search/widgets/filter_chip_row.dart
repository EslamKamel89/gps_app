import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/filter_chip_pill.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/tag_chip.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChipPill(label: 'Filters', icon: Icons.filter_list, onTap: () {}),
          GPSGaps.w12,
          const TagChip(label: '100% Grass-fed'),
          GPSGaps.w12,
          const TagChip(label: 'Organic'),
        ].animate(interval: 80.ms).fadeIn(duration: 280.ms).slideX(begin: .1),
      ),
    );
  }
}
