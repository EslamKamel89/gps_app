import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';

class GPSBottomNav extends StatelessWidget {
  const GPSBottomNav({super.key, required this.currentIndex, required this.onChanged});
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      Icons.home_filled,
      Icons.shop,
      Icons.favorite_rounded,
      Icons.bookmark_rounded,
      Icons.person_rounded,
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      decoration: const BoxDecoration(
        color: GPSColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < items.length; i++)
            _NavIcon(
              icon: items[i],
              selected: currentIndex == i,
              onTap: () {
                onChanged(i);
                if (i == 0) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutesNames.homeSearchScreen, (_) => false);
                }
                if (i == 1) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutesNames.marketPlaceScreen, (_) => false);
                }
              },
            ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: .1),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.selected, required this.onTap});
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
            duration: 180.ms,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: selected ? GPSColors.primary : Colors.white, size: 22),
          )
          .animate(target: selected ? 1 : 0)
          .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08)),
    );
  }
}
