// features/vendor_onboarding/widgets/menu_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/section_header.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/product_item_form.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SectionCard extends StatefulWidget {
  final CatalogSectionParam section;
  final VoidCallback onDelete;

  const SectionCard({super.key, required this.section, required this.onDelete});

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  @override
  void initState() {
    super.initState();
  }

  void _update(String field, dynamic value) {
    // _menu = CategoryEntity(
    //   id: _menu.id,
    //   menuName: field == 'menuName' ? (value as String) : _menu.menuName,
    //   description: field == 'description' ? (value as String?) : _menu.description,
    //   availabilityHours:
    //       field == 'availabilityHours' ? (value as Map<String, String>) : _menu.availabilityHours,
    //   items: field == 'items' ? (value as List<ProductEntity>) : _menu.items,
    // );
    // widget.onChanged(_menu);
  }

  void _addItem() {
    // setState(() {
    //   _menu.items.add(ProductEntity.empty());
    // });
    // _update('items', _menu.items);
  }

  void _removeItem(CatalogItemParam item) {
    // setState(() {
    //   _menu.items.remove(item);
    // });
    // _update('items', _menu.items);
  }

  void _onItemChanged(CatalogItemParam updated) {
    // final index = _menu.items.indexWhere((i) => i.id == updated.id);
    // if (index != -1) {
    //   setState(() {
    //     _menu.items[index] = updated;
    //   });
    //   _update('items', _menu.items);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                "Category • ${widget.section.name ?? 'Untitled'}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
                tooltip: 'Delete Category',
              ),
            ],
          ),
          GPSGaps.h12,

          // Menu Name
          GpsLabeledField(
            label: 'Category Name',
            child: TextFormField(
              initialValue: widget.section.name,
              onChanged: (v) => _update('menuName', v),
              decoration: const InputDecoration(hintText: 'e.g., Organic'),
            ),
          ),

          // GPSGaps.h16,

          // Description
          // GpsLabeledField(
          //   label: 'Description (Optional)',
          //   child: TextFormField(
          //     initialValue: _menu.description,
          //     onChanged: (v) => _update('description', v),
          //     maxLines: 2,
          //     decoration: const InputDecoration(
          //       hintText: 'e.g., Weekday lunch specials',
          //     ),
          //   ),
          // ),
          GPSGaps.h20,

          const SectionHeader(title: 'Category Items'),
          GPSGaps.h12,
          if (widget.section.catalogItems?.isEmpty == true)
            Text(
              'No items added yet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GPSColors.mutedText),
            ),
          ...(widget.section.catalogItems ?? []).map((item) {
            return ProductItemForm(
              item: item,
              onRemove: () => _removeItem(item),
              onChanged: _onItemChanged,
            );
          }),

          GPSGaps.h12,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: context.width * 0.5,
              child: AddButton(label: 'Add Category Item', onTap: _addItem),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
