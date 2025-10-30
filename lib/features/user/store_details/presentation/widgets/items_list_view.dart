import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/add_item_card.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/item_card.dart';

class ItemsListView extends StatefulWidget {
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
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  @override
  Widget build(BuildContext context) {
    widget.section.items ?? [];
    final items = widget.section.items;

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items!.length + (widget.enableEdit ? 1 : 0),
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return AddItemCard(section: widget.section);
        }

        final item = items[index];
        final delay = (70 * index).ms;
        return ItemCard(
              key: Key("${item.id}-${item.name}"),
              item: item,
              heroTag: '${widget.heroPrefix}-$index',
              enableEdit: widget.enableEdit,
              section: widget.section,
            )
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
