// features/vendor_onboarding/widgets/menu_item_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/category.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ProductItemForm extends StatefulWidget {
  final ProductItem item;
  final VoidCallback onRemove;
  final ValueChanged<ProductItem> onChanged;

  const ProductItemForm({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<ProductItemForm> createState() => _ProductItemFormState();
}

class _ProductItemFormState extends State<ProductItemForm> {
  late ProductItem _item;

  @override
  void initState() {
    _item = widget.item;
    super.initState();
  }

  void _update(String field, dynamic value) {
    // _item = _item.copyWith({field: value});
    widget.onChanged(_item);
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
                'Item • ${_item.name.isEmpty ? 'Untitled' : _item.name}',
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
              initialValue: _item.name,
              onChanged: (v) => _update('name', v),
              decoration: const InputDecoration(hintText: 'e.g., Beef Burger'),
            ),
          ),
          GPSGaps.h12,

          // Price
          GpsLabeledField(
            label: 'Price',
            child: TextFormField(
              initialValue:
                  _item.price > 0 ? _item.price.toStringAsFixed(2) : '',
              onChanged: (v) => _update('price', double.tryParse(v) ?? 0.0),
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
              initialValue: _item.description,
              onChanged: (v) => _update('description', v),
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
