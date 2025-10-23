import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/category_chip.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/custom_stack.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/icon_action.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/price_badge.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/thumb.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/restaurant_details_forms.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({super.key, required this.meal, required this.enableEdit});
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
    return CustomStack(
      enableEdit: widget.enableEdit,
      actionWidget:
          widget.enableEdit
              ? EditButton(
                onPressed: () async {
                  setState(() {
                    showEdit = !showEdit;
                  });
                },
              )
              : SizedBox(),
      child: Ink(
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
                enableEdit: showEdit,
                actionWidget:
                    widget.enableEdit
                        ? EditButton(
                          onPressed: () async {
                            final String? name =
                                await showFormBottomSheet<String>(
                                  context,
                                  builder:
                                      (ctx, ctl) =>
                                          ProfileTextForm(controller: ctl),
                                );
                          },
                        )
                        : SizedBox(),
                child: ThumbWidget(
                  meal: widget.meal,
                ).animate().fadeIn(duration: 200.ms),
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
                            enableEdit: showEdit,
                            actionWidget:
                                widget.enableEdit
                                    ? EditButton(
                                      onPressed: () async {
                                        final String? name =
                                            await showFormBottomSheet<String>(
                                              context,
                                              builder:
                                                  (ctx, ctl) => ProfileTextForm(
                                                    controller: ctl,
                                                  ),
                                            );
                                      },
                                    )
                                    : SizedBox(),
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
                          enableEdit: showEdit,
                          actionWidget:
                              widget.enableEdit
                                  ? EditButton(
                                    onPressed: () async {
                                      final String? name =
                                          await showFormBottomSheet<String>(
                                            context,
                                            builder:
                                                (ctx, ctl) => ProfileTextForm(
                                                  controller: ctl,
                                                ),
                                          );
                                    },
                                  )
                                  : SizedBox(),
                          child: PriceBadge(
                            price: double.parse(widget.meal.price ?? '0'),
                          ),
                        ),
                      ],
                    ),
                    !widget.enableEdit ? GPSGaps.h8 : SizedBox(),
                    CustomStack(
                      enableEdit: showEdit,

                      actionWidget:
                          widget.enableEdit
                              ? EditButton(
                                onPressed: () async {
                                  final CategorySelector? categorySelector =
                                      await showFormBottomSheet<
                                        CategorySelector
                                      >(
                                        context,
                                        builder:
                                            (ctx, ctl) =>
                                                ProfileCategorySelectionForm(
                                                  controller: ctl,
                                                ),
                                      );
                                },
                              )
                              : SizedBox(),
                      child: Text(
                        widget.meal.description ?? '',
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
                            enableEdit: showEdit,
                            right: 5,
                            actionWidget:
                                widget.enableEdit
                                    ? EditButton(
                                      onPressed: () async {
                                        final CategorySelector?
                                        categorySelector =
                                            await showFormBottomSheet<
                                              CategorySelector
                                            >(
                                              context,
                                              builder:
                                                  (ctx, ctl) =>
                                                      ProfileCategorySelectionForm(
                                                        controller: ctl,
                                                      ),
                                            );
                                      },
                                    )
                                    : SizedBox(),
                            child: Wrap(
                              children: [
                                if (widget.meal.categories?.name != null)
                                  CategoryChip(
                                    title: widget.meal.categories?.name ?? '',
                                  ),
                                if (widget.meal.subcategories?.name != null)
                                  CategoryChip(
                                    title:
                                        widget.meal.subcategories?.name ?? '',
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Spacer(),
                        // GPSGaps.w12,
                        IconAction(
                          icon: Icons.favorite_border_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
