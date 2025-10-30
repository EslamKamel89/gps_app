import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/add_meal_card.dart';
// Keep your existing MenuItemCard import
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/menu_item_card.dart';

class MealsListView extends StatefulWidget {
  const MealsListView({
    super.key,
    required this.menu,
    required this.heroPrefix,
    required this.enableEdit,
  });
  final Menu menu;
  final String heroPrefix;
  final bool enableEdit;

  @override
  State<MealsListView> createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> {
  @override
  Widget build(BuildContext context) {
    widget.menu.meals ?? [];
    final meals = widget.menu.meals;
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: meals!.length + (widget.enableEdit ? 1 : 0),
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        if (index == meals.length) {
          return AddMealCard(menu: widget.menu);
        }

        final meal = meals[index];
        final delay = (70 * index).ms;
        return MenuItemCard(
              key: Key("${meal.id}-${meal.name}"),
              menu: widget.menu,
              meal: meal,
              enableEdit: widget.enableEdit,
            )
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
