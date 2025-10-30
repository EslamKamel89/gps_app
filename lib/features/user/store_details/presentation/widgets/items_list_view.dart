import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/empty_state.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/item_card.dart';

class ItemsListView extends StatelessWidget {
  const ItemsListView({
    super.key,
    required this.section,
    required this.heroPrefix,
    required this.enableEdit,
  });

  final CatalogSectionModel section;
  final String heroPrefix;
  final bool enableEdit;

  @override
  Widget build(BuildContext context) {
    final items =
        (section.items ?? const []).where((i) => (i.status ?? true) == true).toList()
          ..sort((a, b) => (a.position ?? 9999).compareTo(b.position ?? 9999));

    if (items.isEmpty) {
      return const EmptyState(message: 'No items in this section.');
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
