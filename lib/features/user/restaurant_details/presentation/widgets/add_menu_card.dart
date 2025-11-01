import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class AddMenuCard extends StatefulWidget {
  const AddMenuCard({super.key, required this.restaurant});
  final RestaurantDetailedModel? restaurant;
  @override
  State<AddMenuCard> createState() => _AddMenuCardState();
}

class _AddMenuCardState extends State<AddMenuCard> {
  final _formKey = GlobalKey<FormState>();
  Menu menu = Menu();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Menu • ${menu.name ?? 'Untitled'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: GPSColors.text,
                    ),
                  ),
                ],
              ),
              GPSGaps.h12,

              // Menu Name
              GpsLabeledField(
                label: 'Menu Name',
                child: TextFormField(
                  initialValue: menu.name,
                  onChanged: (v) {
                    setState(() {
                      menu.name = v;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g., Lunch Menu',
                  ),
                  validator:
                      (v) => validator(
                        input: v,
                        label: 'Menu Name',
                        isRequired: true,
                      ),
                ),
              ),
              GPSGaps.h16,

              GpsLabeledField(
                label: 'Description (Optional)',
                child: TextFormField(
                  initialValue: menu.description,
                  onChanged: (v) {
                    setState(() {
                      menu.description = v;
                    });
                  },
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Weekday lunch specials',
                  ),
                ),
              ),
              GPSGaps.h16,

              GPSGaps.h12,
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: context.width * 0.5,
                  child: AddButton(label: 'Add Menu', onTap: _addMenu),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08),
      ),
    );
  }

  Future _addMenu() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<RestaurantsController>();
    final cubit = context.read<RestaurantCubit>();
    cubit.state.data?.menus ??= [];
    cubit.state.data?.menus?.add(menu);
    cubit.update(cubit.state.data!);
    final res = await controller.addMenu(menu: menu);
    if (res.response == ResponseEnum.success) {
      if (mounted) {
        setState(() {
          menu = Menu();
        });
      }
    }
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }
}
