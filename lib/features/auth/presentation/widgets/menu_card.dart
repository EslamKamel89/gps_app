// features/vendor_onboarding/widgets/menu_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/cubits/create_restaurant_menus/create_restaurant_menus_cubit.dart';
import 'package:gps_app/features/auth/models/menu_param/meal_param.dart';
import 'package:gps_app/features/auth/models/menu_param/menu_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/meal_form.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/section_header.dart';

class MenuCard extends StatefulWidget {
  final MenuParam menu;
  final VoidCallback onDelete;

  const MenuCard({super.key, required this.menu, required this.onDelete});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    CreateRestaurantMenusCubit cubit = context.watch<CreateRestaurantMenusCubit>();
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
                'Menu • ${widget.menu.name ?? 'Untitled'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
                tooltip: 'Delete Menu',
              ),
            ],
          ),
          GPSGaps.h12,

          // Menu Name
          GpsLabeledField(
            label: 'Menu Name',
            child: TextFormField(
              initialValue: widget.menu.name,
              onChanged: (v) => widget.menu.name = v,
              decoration: const InputDecoration(hintText: 'e.g., Lunch Menu'),
              validator: (v) => validator(input: v, label: 'Menu Name', isRequired: true),
            ),
          ),
          GPSGaps.h16,
          ImageUploadField(
            multiple: false,
            resource: UploadResource.common,
            initial: const [],
            onChanged: (images) {
              if (images.isEmpty) return;
              widget.menu.imageId = images[0].id;
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text('Tap to upload menu image'),
            ),
          ),
          GPSGaps.h16,
          // Description
          GpsLabeledField(
            label: 'Description (Optional)',
            child: TextFormField(
              initialValue: widget.menu.description,
              onChanged: (v) => widget.menu.description = v,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'e.g., Weekday lunch specials'),
            ),
          ),
          GPSGaps.h16,

          // Availability Hours
          // OpeningHoursEditor(
          //   hours: _menu.availabilityHours,
          //   onChanged: (hours) => _update('availabilityHours', hours),
          // ),
          // GPSGaps.h20,

          // Menu Items Section
          const SectionHeader(title: 'Menu Items'),
          GPSGaps.h12,
          if ((widget.menu.meals ?? []).isEmpty == true)
            Text(
              'No meals added yet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GPSColors.mutedText),
            ),
          ...(widget.menu.meals ?? []).map((meal) {
            return MealForm(
              meal: meal,
              onRemove: () => cubit.removeMeal(menuParam: widget.menu, mealParam: meal),
            );
          }),

          GPSGaps.h12,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: context.width * 0.5,
              child: AddButton(
                label: 'Add Menu Item',
                onTap: () => cubit.addMeal(menuParam: widget.menu, mealParam: MealParam()),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
