import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_icon.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/utils/assets/assets.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, this.title = 'GPS'});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: GPSColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          RoundIcon(icon: Icons.menu_rounded, onTap: () {}),
          GPSGaps.w12,
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsData.logo3d, width: 30, height: 30),
                GPSGaps.w4,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
              ],
            ),
          ),
          GPSGaps.w12,
          RoundIcon(icon: Icons.person_outline, onTap: () {}),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: -.2, curve: Curves.easeOut);
  }
}
