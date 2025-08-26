import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/resturant_details_screen.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/menu_item_card.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class MenuListView extends StatelessWidget {
  const MenuListView({super.key, required this.items, required this.heroPrefix});
  final List<MenuItem> items;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final item = items[index];
        final delay = (70 * index).ms;

        return MenuItemCard(item: item, heroTag: '$heroPrefix-$index')
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
