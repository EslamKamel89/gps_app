import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class AddMealCard extends StatefulWidget {
  const AddMealCard({super.key, required this.menu});
  final Menu menu;
  @override
  State<AddMealCard> createState() => _AddMealCardState();
}

class _AddMealCardState extends State<AddMealCard> {
  Meal _meal = Meal();
  bool _expanded = false;

  void _toggleExpanded([bool? v]) => setState(() => _expanded = v ?? !_expanded);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final borderColor = GPSColors.cardBorder.withOpacity(0.3);

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: AnimatedSwitcher(
          duration: 250.ms,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder:
              (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              ),
          child: _expanded ? _buildExpanded(context) : _buildCollapsed(context),
        ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.06, curve: Curves.easeOutCubic),
    );
  }

  // Collapsed view: full-width primary button
  Widget _buildCollapsed(BuildContext context) {
    return Padding(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => _toggleExpanded(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: GPSColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            'Add Meal',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          ),
        ).animate().fadeIn(duration: 160.ms).scale(begin: const Offset(0.98, 0.98)),
      ),
    );
  }

  // Expanded form
  Widget _buildExpanded(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
          key: const ValueKey('expanded'),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + collapse
              Row(
                children: [
                  Text(
                    'Meal • ${(_meal.name?.trim().isNotEmpty ?? false) ? _meal.name! : 'Untitled'}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: GPSColors.text,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Collapse',
                    onPressed: () => _toggleExpanded(false),
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.06)),
                    icon: const Icon(Icons.expand_less, color: GPSColors.text),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.14),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              GPSGaps.h12,

              // Name
              GpsLabeledField(
                label: 'Name',
                child: TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _meal.name,
                  onChanged: (v) => setState(() => _meal.name = v),
                  decoration: const InputDecoration(hintText: 'e.g., Beef Burger'),
                  validator: (v) => validator(input: v, label: 'Name', isRequired: true),
                ),
              ),
              GPSGaps.h12,

              // Price
              GpsLabeledField(
                label: 'Price',
                child: TextFormField(
                  key: const ValueKey('price'),
                  initialValue: _meal.price?.toString() ?? '',
                  onChanged: (v) => setState(() => _meal.price = v),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => validator(input: v, label: 'Price', isRequired: true),
                  decoration: const InputDecoration(
                    hintText: 'e.g., 12.95',
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: GPSColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GPSGaps.h12,

              // Image upload
              ImageUploadField(
                multiple: false,
                resource: UploadResource.common,

                onChanged: (images) {
                  setState(() {
                    if (images.isEmpty) {
                      _meal.images = null;
                    } else {
                      _meal.images = RestaurantImage(id: images[0].id, path: images[0].path);
                    }
                  });
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
              GPSGaps.h12,

              // Category / Subcategory
              CategorySelectorProvider(
                onSelect: (selected) {
                  setState(() {
                    _meal.categories = Category(id: selected.selectedCategory?.id);
                    _meal.subcategories = Category(id: selected.selectedSubCategory?.id);
                  });
                },
              ),
              GPSGaps.h12,

              // Description
              GpsLabeledField(
                label: 'Description (Optional)',
                child: TextFormField(
                  key: const ValueKey('description'),
                  initialValue: _meal.description,
                  onChanged: (v) => setState(() => _meal.description = v),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Grass-fed beef, cheddar, lettuce...',
                  ),
                ),
              ),
              GPSGaps.h12,
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: context.width * 0.5,
                  child: AddButton(label: 'Add Meal', onTap: _addMeal),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.03, curve: Curves.easeOutCubic);
  }

  Future _addMeal() async {
    // pr(_meal);
    // return;
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<RestaurantsController>();
    final cubit = context.read<RestaurantCubit>();
    widget.menu.meals ?? [];
    widget.menu.meals?.add(_meal);
    cubit.update(cubit.state.data!);
    _toggleExpanded();
    final res = await controller.addMeal(menu: widget.menu, meal: _meal);
    if (mounted) {
      setState(() {
        _meal = Meal();
      });
    }
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }
}
