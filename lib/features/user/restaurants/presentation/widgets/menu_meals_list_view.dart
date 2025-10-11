import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Keep your existing MenuItemCard import
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/menu_item_card.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

class MenuMealsListView extends StatelessWidget {
  const MenuMealsListView({super.key, required this.meals, required this.heroPrefix});

  final List<Meal> meals;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: meals.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final meal = meals[index];
        final delay = (70 * index).ms;
        return MenuItemCard(meal: meal)
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
