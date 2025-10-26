import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/empty_state.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/item_card.dart';

class EmptySectionList extends StatelessWidget {
  const EmptySectionList({
    super.key,
    required this.items,
    required this.heroPrefix,
    required this.enableEdit,
  });
  final List<CatalogItemModel> items;
  final String heroPrefix;
  final bool enableEdit;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(message: 'No items available.');
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final delay = (70 * index).ms;
        return ItemCard(item: items[index], heroTag: '$heroPrefix-$index', enableEdit: enableEdit)
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
