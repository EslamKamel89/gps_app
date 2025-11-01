// features/vendor_onboarding/screens/vendor_onboarding_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/features/auth/cubits/create_restaurant_menus/create_restaurant_menus_cubit.dart';
import 'package:gps_app/features/auth/models/menu_param/meal_param.dart';
import 'package:gps_app/features/auth/models/menu_param/menu_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/menu_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';

class RestaurantOnboardingMenuScreen extends StatefulWidget {
  const RestaurantOnboardingMenuScreen({super.key});

  @override
  State<RestaurantOnboardingMenuScreen> createState() => _RestaurantOnboardingMenuScreenState();
}

class _RestaurantOnboardingMenuScreenState extends State<RestaurantOnboardingMenuScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_back_rounded),
                    //   onPressed: () => Navigator.maybePop(context),
                    // ),
                    const Spacer(),
                    Text(
                      'Step 2 of 3',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                    ),
                  ],
                ),
              ),

              BlocConsumer<CreateRestaurantMenusCubit, CreateRestaurantMenusState>(
                listener: (context, state) {
                  if (state.menusResponse.response == ResponseEnum.success) {
                    Navigator.of(context).maybePop();
                    context.read<RestaurantCubit>().restaurant(
                      restaurantId: userInMemory()?.restaurant?.id ?? -1,
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<CreateRestaurantMenusCubit>();
                  return Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Your Menus',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          GPSGaps.h8,
                          Text(
                            'Add menus and items that customers will see. You can create multiple menus (e.g., Lunch, Dinner).',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: GPSColors.mutedText,
                              height: 1.4,
                            ),
                          ),
                          GPSGaps.h24,

                          // Menu Cards
                          ...state.menus.map((menu) {
                            return MenuCard(
                              menu: menu,
                              onDelete: () => cubit.removeMenu(menuParam: menu),
                            );
                          }),

                          // Add Another Menu
                          GPSGaps.h12,
                          AddButton(
                            label: 'Add Another Menu',
                            onTap: () => cubit.addMenu(menuParam: MenuParam(meals: [MealParam()])),
                          ),
                          GPSGaps.h24,
                        ],
                      ),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // OutlinedButton(
                    //   onPressed: () => Navigator.maybePop(context),
                    //   style: OutlinedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    //   ),
                    //   child: const Text('← Previous'),
                    // ),
                    const Spacer(),
                    Builder(
                      builder: (context) {
                        final cubit = context.watch<CreateRestaurantMenusCubit>();

                        return cubit.state.menusResponse.response == ResponseEnum.loading
                            ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Center(child: CircularProgressIndicator()),
                            )
                            : ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                cubit.createMenus();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GPSColors.accent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('Save'),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
        ),
      ),
    );
  }
}
