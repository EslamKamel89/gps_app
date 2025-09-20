// features/vendor_onboarding/widgets/menu_item_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/auth/cubits/create_catalog_section_items/create_catalog_section_items_cubit.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ProductItemForm extends StatefulWidget {
  final CatalogItemParam item;
  final VoidCallback onRemove;

  const ProductItemForm({super.key, required this.item, required this.onRemove});

  @override
  State<ProductItemForm> createState() => _ProductItemFormState();
}

class _ProductItemFormState extends State<ProductItemForm> {
  late CreateCatalogSectionItemsCubit cubit;
  @override
  void initState() {
    context.read<CreateCatalogSectionItemsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Item • ${widget.item.name ?? 'Untitled'}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.red),
                onPressed: widget.onRemove,
                tooltip: 'Remove Item',
              ),
            ],
          ),
          GPSGaps.h12,

          // Name
          GpsLabeledField(
            label: 'Name',
            child: TextFormField(
              initialValue: widget.item.name,
              onChanged: (v) => widget.item.name = v,
              decoration: const InputDecoration(hintText: 'e.g., Beef Burger'),
            ),
          ),
          GPSGaps.h12,

          // Price
          GpsLabeledField(
            label: 'Price',
            child: TextFormField(
              initialValue: widget.item.price != null ? widget.item.price!.toStringAsFixed(2) : '',
              onChanged: (v) => widget.item.price = double.parse(v),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'e.g., 12.95',
                prefixText: '\$ ',
                prefixStyle: TextStyle(color: GPSColors.primary),
              ),
            ),
          ),
          GPSGaps.h12,

          // Description
          GpsLabeledField(
            label: 'Description (Optional)',
            child: TextFormField(
              initialValue: widget.item.description,
              onChanged: (v) => widget.item.description = v,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g., Grass-fed beef, cheddar, lettuce...',
              ),
            ),
          ),

          // Category
          GPSGaps.h12,
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.06);
  }
}
