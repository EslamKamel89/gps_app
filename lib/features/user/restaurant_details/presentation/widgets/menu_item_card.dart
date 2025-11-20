import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/category_chip.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/delete_button.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/icon_action.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/price_badge.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/show_action_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/thumb.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({super.key, required this.meal, required this.enableEdit, required this.menu});
  final Menu menu;
  final Meal meal;
  final bool enableEdit;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool showEdit = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        if (showEdit) return;
        Navigator.pushNamed(
          context,
          AppRoutesNames.itemInfoScreen,
          arguments: {'type': 'meal', 'itemId': widget.meal.id},
        );
      },
      child: CustomStack(
        enableEdit: widget.enableEdit,
        actionWidget: EditButton(
          onPressed: () async {
            setState(() {
              showEdit = !showEdit;
            });
          },
        ),
        child: Stack(
          children: [
            Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GPSColors.cardBorder),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 14,
                    spreadRadius: -4,
                    offset: Offset(0, 6),
                    color: Color(0x1A000000),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomStack(
                      enableEdit: showEdit && widget.enableEdit,
                      actionWidget: EditButton(
                        onPressed: () async {
                          _updateMealImage(widget.meal);
                        },
                      ),
                      child: ThumbWidget(meal: widget.meal).animate().fadeIn(duration: 200.ms),
                    ),
                    GPSGaps.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomStack(
                                  enableEdit: showEdit && widget.enableEdit,
                                  actionWidget: EditButton(
                                    onPressed: () async {
                                      _updateMealName(widget.meal);
                                    },
                                  ),
                                  child: Text(
                                    widget.meal.name ?? '',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: GPSColors.text,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              CustomStack(
                                enableEdit: showEdit && widget.enableEdit,
                                actionWidget: EditButton(
                                  onPressed: () async {
                                    _updateMealPrice(widget.meal);
                                  },
                                ),
                                child: PriceBadge(price: double.parse(widget.meal.price ?? '0')),
                              ),
                            ],
                          ),
                          !widget.enableEdit ? GPSGaps.h8 : SizedBox(),
                          CustomStack(
                            enableEdit: showEdit && widget.enableEdit,

                            actionWidget: EditButton(
                              onPressed: () async {
                                _updateMealDescription(widget.meal);
                              },
                            ),
                            child: Text(
                              widget.meal.description ?? (showEdit ? 'Add description' : ''),
                              style: textTheme.bodyMedium?.copyWith(
                                color: GPSColors.mutedText,
                                height: 1.35,
                              ),
                            ),
                          ),
                          !widget.enableEdit ? GPSGaps.h8 : SizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: CustomStack(
                                  enableEdit: showEdit && widget.enableEdit,
                                  right: 5,
                                  actionWidget: EditButton(
                                    onPressed: () async {
                                      _updateMealCategory(widget.meal);
                                    },
                                  ),
                                  child: Wrap(
                                    children: [
                                      if (widget.meal.categories?.name != null)
                                        CategoryChip(title: widget.meal.categories?.name ?? ''),
                                      if (widget.meal.subcategories?.name != null)
                                        CategoryChip(title: widget.meal.subcategories?.name ?? ''),
                                    ],
                                  ),
                                ),
                              ),

                              // Spacer(),
                              // GPSGaps.w12,
                              IconAction(icon: Icons.favorite_border_rounded, onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showEdit && widget.enableEdit)
              Positioned(
                top: 0,
                left: 0,
                child: DeleteButton(
                  onTap: () {
                    _deleteMeal(menu: widget.menu, meal: widget.meal);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future _updateMealName(Meal meal) async {
    final cubit = context.read<RestaurantCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) =>
              ProfileTextForm(initialValue: meal.name, controller: ctl, label: 'Update Meal Name'),
    );
    if (newVal == null) return;
    meal.name = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(path: 'meals/${meal.id}', data: {'name': newVal});
  }

  Future _updateMealDescription(Meal meal) async {
    final cubit = context.read<RestaurantCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: meal.description,
            controller: ctl,
            label: 'Update Meal Description',
          ),
    );
    if (newVal == null) return;
    meal.description = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'meals/${meal.id}',
      data: {'description': newVal},
    );
  }

  Future _updateMealPrice(Meal meal) async {
    final cubit = context.read<RestaurantCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: meal.price,
            controller: ctl,
            label: 'Update Meal Price',
            isNumeric: true,
          ),
    );
    if (newVal == null) return;
    meal.price = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(path: 'meals/${meal.id}', data: {'price': newVal});
  }

  Future _updateMealCategory(Meal meal) async {
    final cubit = context.read<RestaurantCubit>();
    final CategorySelector? newVal = await showFormBottomSheet<CategorySelector>(
      context,
      builder: (ctx, ctl) => ProfileCategorySelectionForm(controller: ctl),
    );
    if (newVal == null || newVal.selectedCategory == null || newVal.selectedSubCategory == null) {
      return;
    }
    meal.categories?.name = newVal.selectedCategory?.name;
    meal.subcategories?.name = newVal.selectedSubCategory?.name;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'meals/${meal.id}',
      data: {
        'category_id': newVal.selectedCategory?.id,
        'sub_category_id': newVal.selectedSubCategory?.id,
      },
    );
  }

  Future _updateMealImage(Meal meal) async {
    final cubit = context.read<RestaurantCubit>();
    final UploadedImage? newVal = await showFormBottomSheet<UploadedImage>(
      context,
      builder: (ctx, ctl) => ProfileImageForm(controller: ctl, label: 'Update Meal image'),
    );
    if (newVal == null) return;
    meal.images?.path = "${EndPoint.baseUrl}/${newVal.path}";
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'meals/${meal.id}',
      data: {'image_id': newVal.id},
    );
  }

  Future _deleteMeal({required Menu? menu, required Meal meal}) async {
    final areYouSure = await showActionSheet(
      context,
      title: 'Are you sure you want to delete this meal?',
      children: [
        Row(children: [Icon(MdiIcons.check), GPSGaps.w10, Text('Yes')]),
        Row(children: [Icon(MdiIcons.cancel), GPSGaps.w10, Text('No')]),
      ],
    );
    if (areYouSure != 0) return;
    final cubit = context.read<RestaurantCubit>();
    menu?.meals?.remove(meal);
    cubit.update(cubit.state.data!);
    final controller = serviceLocator<RestaurantsController>();
    final res = await controller.deleteMeal(meal: meal);
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }
}
