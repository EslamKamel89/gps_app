// features/vendor_onboarding/widgets/menu_item_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/menu_param/meal_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/category_selector.dart';

class MealForm extends StatefulWidget {
  final MealParam meal;
  final VoidCallback onRemove;

  const MealForm({super.key, required this.meal, required this.onRemove});

  @override
  State<MealForm> createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> {
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
                'Item • ${widget.meal.name ?? 'Untitled'}',
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
              initialValue: widget.meal.name,
              onChanged: (v) => widget.meal.name = v,
              decoration: const InputDecoration(hintText: 'e.g., Beef Burger'),
              validator:
                  (v) => validator(input: v, label: 'Name', isRequired: true),
            ),
          ),
          GPSGaps.h12,

          // Price
          GpsLabeledField(
            label: 'Price',
            child: TextFormField(
              initialValue: widget.meal.price?.toString() ?? '',
              onChanged: (v) => widget.meal.price = double.parse(v),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator:
                  (v) => validator(input: v, label: 'Price', isRequired: true),
              decoration: const InputDecoration(
                hintText: 'e.g., 12.95',
                prefixText: '\$ ',
                prefixStyle: TextStyle(color: GPSColors.primary),
              ),
            ),
          ),
          GPSGaps.h12,
          ImageUploadField(
            multiple: false,
            resource: UploadResource.common,
            initial: const [],
            onChanged: (images) {
              if (images.isEmpty) return;
              widget.meal.imageId = images[0].id;
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text('Tap to upload meal image'),
            ),
          ),
          // Description
          GPSGaps.h12,
          CategorySelectorProvider(
            onSelect: (selected) {
              widget.meal.categoryId = selected.selectedCategory?.id;
              widget.meal.subCategoryId = selected.selectedSubCategory?.id;
            },
          ),
          GPSGaps.h12,
          GpsLabeledField(
            label: 'Description (Optional)',
            child: TextFormField(
              initialValue: widget.meal.description,
              onChanged: (v) => widget.meal.description = v,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g., Grass-fed beef, cheddar, lettuce...',
              ),
            ),
          ),
          GPSGaps.h12,

          // Category
          // GpsLabeledField(
          //   label: 'Category',
          //   child: CategoryDropdown(
          //     value: _item.category,
          //     onChanged: (v) => _update('category', v),
          //   ),
          // ),
          // GPSGaps.h12,
          // GpsLabeledField(
          //   label: 'Sub category',
          //   child: CategoryDropdown(
          //     value: _item.category,
          //     onChanged: (v) => _update('category', v),
          //   ),
          // ),
          // GPSGaps.h12,

          // Spicy Toggle
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.local_fire_department_rounded,
          //       size: 16,
          //       color: Colors.orange,
          //     ),
          //     GPSGaps.w8,
          //     const Text('Spicy?', style: TextStyle(fontSize: 14)),
          //     const Spacer(),
          //     Switch(
          //       value: _item.isSpicy,
          //       onChanged: (v) => _update('isSpicy', v),
          //       activeColor: Colors.orange,
          //     ),
          //   ],
          // ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.06);
  }
}
