import 'package:flutter/material.dart';

import 'restaurant_details_screen.dart';

class RestaurantDetailProvider extends StatelessWidget {
  const RestaurantDetailProvider({
    super.key,
    this.restaurantId = 1,
    required this.enableEdit,
    this.enableCompleteProfile = false,
  });
  final int restaurantId;
  final bool enableEdit;
  final bool enableCompleteProfile;
  @override
  Widget build(BuildContext context) {
    return RestaurantDetailsScreen(
      restaurantId: restaurantId,
      enableEdit: enableEdit,
      enableCompleteProfile: enableCompleteProfile,
    );
  }
}
