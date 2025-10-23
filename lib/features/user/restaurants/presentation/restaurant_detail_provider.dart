import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/user/restaurants/cubits/restaurant_cubit.dart';

import 'widgets/restaurant_details_screen.dart';

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
    return BlocProvider<RestaurantCubit>(
      create:
          (context) =>
              RestaurantCubit()..restaurant(restaurantId: restaurantId),
      child: RestaurantDetailsScreen(
        restaurantId: restaurantId,
        enableEdit: enableEdit,
        enableCompleteProfile: enableCompleteProfile,
      ),
    );
  }
}
