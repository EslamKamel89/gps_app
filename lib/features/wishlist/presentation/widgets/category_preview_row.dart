import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/mini_restaurant_chip.dart';

class CategoryPreviewRow extends StatelessWidget {
  const CategoryPreviewRow({super.key, required this.category, required this.subCategory});
  final CategoryModel category;
  final SubCategoryModel subCategory;
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (category.name != null) MiniRestaurantChip(name: category.name ?? ''),
            if (subCategory.name != null) MiniRestaurantChip(name: subCategory.name ?? ''),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
        GPSGaps.h8,
        Text(
          'Matched restaurants can satisfy this wish with specific menu items.',
          style: txt.bodySmall?.copyWith(color: GPSColors.mutedText),
        ),
      ],
    );
  }
}
