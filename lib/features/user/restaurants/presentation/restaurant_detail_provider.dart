import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/user/restaurants/cubits/restaurant_cubit.dart';

import 'widgets/restaurant_detail_widget.dart';

class RestaurantDetailProvider extends StatelessWidget {
  const RestaurantDetailProvider({super.key, this.restaurantId = 1});
  final int restaurantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantCubit>(
      create:
          (context) =>
              RestaurantCubit()..restaurant(restaurantId: restaurantId),
      child: RestaurantDetailWidget(restaurantId: restaurantId),
    );
  }
}
