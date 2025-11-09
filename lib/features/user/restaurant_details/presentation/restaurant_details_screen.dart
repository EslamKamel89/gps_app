import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/presentation/widgets/fav_button.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/branch_list.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/certifications_screen.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/add_menu_card.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/profile_appbar.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/profile_nav_button.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/show_action_sheet.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/contact_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widgets/badges.dart';
import 'widgets/helpers.dart';
import 'widgets/loading_error_scaffolds.dart';
import 'widgets/meals_list_view.dart';
import 'widgets/tab_bar_delegate.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({
    super.key,
    this.restaurantId = 1,
    required this.enableEdit,
    this.enableCompleteProfile = false,
  });
  final int restaurantId;
  final bool enableEdit;
  final bool enableCompleteProfile;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final RestaurantCubit cubit;
  @override
  void initState() {
    cubit = context.read<RestaurantCubit>();
    cubit.restaurant(restaurantId: widget.restaurantId);
    super.initState();
  }

  @override
  void dispose() {
    cubit.state.data = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      RestaurantCubit,
      ApiResponseModel<RestaurantDetailedModel>
    >(
      listener: (context, state) {},
      builder: (context, state) {
        if ((state.response == ResponseEnum.initial ||
                state.response == ResponseEnum.loading) &&
            state.data == null) {
          return const LoadingScaffold();
        } else if (state.response case ResponseEnum.failed) {
          return ErrorScaffold(
            onRetry: () => cubit.restaurant(restaurantId: widget.restaurantId),
          );
        } else if (state.response == ResponseEnum.success ||
            state.data != null) {
          final menus = state.data?.menus ?? const <Menu>[];
          final tabs = menus.map((m) => m.name ?? 'Menu').toList();

          final String coverUrl = resolveMediaUrl(
            state.data?.user?.images?.isNotEmpty == true
                ? state.data!.user!.images!.first.path
                : null,
          );

          final restaurantTitle =
              (state.data?.vendor?.vendorName?.trim().isNotEmpty ?? false)
                  ? state.data!.vendor!.vendorName!
                  : 'Restaurant';

          return SafeArea(
            child: DefaultTabController(
              length: tabs.length + (widget.enableEdit ? 1 : 0),
              child: Scaffold(
                backgroundColor: GPSColors.background,
                appBar: profileAppBar(
                  title: state.data?.vendor?.vendorName ?? 'Restaurant Details',
                ),

                body: NestedScrollView(
                  headerSliverBuilder:
                      (context, inner) => [
                        // SliverAppBar(
                        //   backgroundColor: GPSColors.background,
                        //   expandedHeight: 260,
                        //   pinned: true,
                        //   elevation: 0,
                        //   // leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                        //   actions: [
                        //     // IconButton(
                        //     //   tooltip: 'Share',
                        //     //   icon: const Icon(Icons.share_rounded, color: Colors.black),
                        //     //   onPressed: () {},
                        //     // ),
                        //   ],
                        //   flexibleSpace: FlexibleSpaceBar(
                        //     background: Stack(
                        //       fit: StackFit.expand,
                        //       children: [
                        //         CustomStack(
                        //           enableEdit: widget.enableEdit,
                        //           actionWidget: EditButton(
                        //             onPressed: () => _updateUserImage(restaurant: state.data),
                        //           ),
                        //           child: CachedNetworkImage(
                        //                 width: double.infinity,
                        //                 imageUrl: coverUrl,
                        //                 fit: BoxFit.cover,
                        //                 placeholder: (_, __) => const CoverPlaceholder(),
                        //                 errorWidget: (_, __, ___) => const CoverError(),
                        //               )
                        //               .animate()
                        //               .fadeIn(duration: 400.ms)
                        //               .scale(
                        //                 begin: const Offset(1.02, 1.02),
                        //                 end: const Offset(1, 1),
                        //               ),
                        //         ),

                        //         // Positioned(bottom: 5, right: 5, child: WishButton()),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              CustomStack(
                                enableEdit: widget.enableEdit,
                                actionWidget: EditButton(
                                  onPressed:
                                      () => _updateUserImage(
                                        restaurant: state.data,
                                      ),
                                ),
                                child: CachedNetworkImage(
                                      height: 200,
                                      width: double.infinity,
                                      imageUrl: coverUrl,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (_, __) => const CoverPlaceholder(),
                                      errorWidget:
                                          (_, __, ___) => const CoverError(),
                                    )
                                    .animate()
                                    .fadeIn(duration: 400.ms)
                                    .scale(
                                      begin: const Offset(1.02, 1.02),
                                      end: const Offset(1, 1),
                                    ),
                              ),

                              // Positioned(bottom: 5, right: 5, child: WishButton()),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: GPSColors.background,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                18,
                                16,
                                14,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TextButton(
                                  //   onPressed: () {
                                  //     var user = userInMemory();
                                  //     pr(user?.restaurant, 'restaurant');
                                  //   },
                                  //   child: Text('test'),
                                  // ),
                                  Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomStack(
                                              enableEdit: widget.enableEdit,
                                              actionWidget: EditButton(
                                                onPressed:
                                                    () => _updateRestaurantName(
                                                      restaurant: state.data,
                                                    ),
                                              ),
                                              child: Text(
                                                restaurantTitle,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      color: GPSColors.text,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          FavoriteButton(
                                            showFav:
                                                state.data?.id?.toString() !=
                                                userInMemory()?.restaurant?.id
                                                    ?.toString(),
                                            id: state.data?.id,
                                            type: 'restaurant',
                                          ),
                                        ],
                                      )
                                      .animate()
                                      .fadeIn(duration: 280.ms)
                                      .slideY(begin: .1),

                                  // if (state.data?.mainCategories?.isNotEmpty == true)
                                  Column(
                                    children: [
                                      GPSGaps.h12,
                                      Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: [
                                              ...(state.data?.mainCategories ??
                                                      [])
                                                  .map(
                                                    (c) => BadgeChip(
                                                      label: c.name ?? '',
                                                    ),
                                                  ),
                                              ...(state.data?.subCategories ??
                                                      [])
                                                  .map(
                                                    (c) => BadgeChip(
                                                      label: c.name ?? '',
                                                    ),
                                                  ),
                                            ],
                                          )
                                          .animate(delay: 70.ms)
                                          .fadeIn(duration: 250.ms)
                                          .slideY(begin: .08),
                                    ],
                                  ),

                                  GPSGaps.h16,

                                  // GPSGaps.h8,
                                  // Text(
                                  //   'Neighborhood kitchen serving grass-fed meats, raw cheeses, and seasonal produce from nearby farms.',
                                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  //     color: GPSColors.mutedText,
                                  //     height: 1.4,
                                  //   ),
                                  // ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),
                                  // const SectionHeader(title: 'Reviews'),
                                  // ReviewsSection(reviews: _reviews),
                                  GPSGaps.h16,
                                  ContactCard(
                                    user: state.data?.user,
                                    enableEdit: widget.enableEdit,
                                  ),
                                  GPSGaps.h16,
                                  if (state.data?.branches?.isNotEmpty == true)
                                    Column(
                                      children: [
                                        GPSGaps.h16,
                                        ProfileCTAButton(
                                          label: 'View Branches',
                                          onPressed: () {
                                            Future.delayed(100.ms, () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => BranchList(
                                                        branches:
                                                            state
                                                                .data
                                                                ?.branches ??
                                                            [],
                                                        enableEdit:
                                                            widget.enableEdit,
                                                      ),
                                                ),
                                              );
                                            });
                                          },
                                          icon: MdiIcons.foodForkDrink,
                                          tooltip: 'Go to branch details',
                                          expand: true,
                                        ),
                                      ],
                                    ),

                                  if (state.data?.branches?.isNotEmpty ==
                                          false &&
                                      widget.enableCompleteProfile)
                                    Column(
                                      children: [
                                        GPSGaps.h16,
                                        ProfileCTAButton(
                                          label: 'Add Branches',
                                          onPressed: () {
                                            Future.delayed(100.ms, () {
                                              Navigator.of(context).pushNamed(
                                                AppRoutesNames
                                                    .restaurantOnboardingBranchesScreen,
                                              );
                                            });
                                          },
                                          icon: MdiIcons.foodForkDrink,
                                          expand: true,
                                        ),
                                      ],
                                    ),

                                  if (state.data?.certifications?.isNotEmpty ==
                                      true)
                                    Column(
                                      children: [
                                        GPSGaps.h8,
                                        ProfileCTAButton(
                                          label: 'View Certifications',
                                          onPressed: () {
                                            Future.delayed(100.ms, () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          CertificationsScreen(
                                                            enableEdit:
                                                                widget
                                                                    .enableEdit,
                                                          ),
                                                ),
                                              );
                                            });
                                          },
                                          icon: MdiIcons.certificate,
                                          expand: true,
                                        ),
                                      ],
                                    ),

                                  if (state.data?.certifications?.isNotEmpty ==
                                          false &&
                                      widget.enableCompleteProfile)
                                    Column(
                                      children: [
                                        GPSGaps.h8,
                                        ProfileCTAButton(
                                          label: 'Add Certifications',
                                          onPressed: () {
                                            Future.delayed(100.ms, () {
                                              Navigator.of(context).pushNamed(
                                                AppRoutesNames
                                                    .restaurantOnboardingCertificationsScreen,
                                              );
                                            });
                                          },
                                          icon: MdiIcons.certificate,
                                          tooltip:
                                              'Go to certification details',
                                          expand: true,
                                        ),
                                      ],
                                    ),
                                  if (state.data?.menus?.isNotEmpty == false &&
                                      widget.enableCompleteProfile)
                                    Column(
                                      children: [
                                        GPSGaps.h8,
                                        ProfileCTAButton(
                                          label: 'Add Menus',
                                          onPressed: () {
                                            Future.delayed(100.ms, () {
                                              Navigator.of(context).pushNamed(
                                                AppRoutesNames
                                                    .restaurantOnboardingMenuScreen,
                                              );
                                            });
                                          },
                                          icon: MdiIcons.paperRoll,
                                          tooltip: 'Go to menus details',
                                          expand: true,
                                        ),
                                      ],
                                    ),
                                  GPSGaps.h8,
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state.data?.menus?.isNotEmpty == true)
                          SliverPersistentHeader(
                            pinned: true,

                            delegate: TabBarDelegate(
                              // forcedHeight: 80,
                              PreferredSize(
                                preferredSize: const Size.fromHeight(
                                  kTextTabBarHeight,
                                ),
                                // preferredSize: const Size.fromHeight(70),
                                child: Material(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CustomStack(
                                    enableEdit: widget.enableEdit,
                                    actionWidget: EditButton(
                                      onPressed: () {
                                        _updateOrDeleteMenusNames(
                                          restaurant: state.data,
                                        );
                                      },
                                    ),
                                    child: TabBar(
                                          isScrollable: true,
                                          indicatorWeight: 3,
                                          indicatorColor: Colors.green,
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Colors.grey,
                                          labelStyle: Theme.of(
                                            context,
                                          ).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                          tabs: [
                                            for (final t in tabs)
                                              Tab(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    1.0,
                                                  ),
                                                  child: Text(
                                                    t,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (widget.enableEdit)
                                              Tab(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    1.0,
                                                  ),
                                                  child: Text(
                                                    'Add Menu',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                        .animate()
                                        .fadeIn(duration: 220.ms)
                                        .slideY(begin: .08),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                  body:
                      state.data?.menus?.isNotEmpty == true
                          ? TabBarView(
                            children: [
                              for (int ti = 0; ti < tabs.length; ti++)
                                MealsListView(
                                  heroPrefix: 'tab$ti',
                                  menu: menus[ti],
                                  enableEdit: widget.enableEdit,
                                ),
                              if (widget.enableEdit)
                                AddMenuCard(restaurant: state.data),
                            ],
                          )
                          : const SizedBox(),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future _updateRestaurantName({
    required RestaurantDetailedModel? restaurant,
  }) async {
    final storage = serviceLocator<LocalStorage>();
    final currentUser = userInMemory();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: currentUser?.vendor?.vendorName,
            controller: ctl,
            label: 'Update your name',
          ),
    );
    if (newVal == null) return;
    final newState = cubit.state.data?.copyWith();
    newState?.vendor?.vendorName = newVal;
    cubit.update(newState!);
    final res = await UpdateController.update(
      path: 'vendor/${restaurant?.vendor?.id}',
      data: {'vendor_name': newVal},
    );
    int? restaurantId = currentUser?.restaurant?.id;
    if (res.response == ResponseEnum.success && restaurantId != null) {
      currentUser?.vendor?.vendorName = newVal;
      storage.cacheUser(currentUser);
    }
  }

  Future _updateOrDeleteMenusNames({
    required RestaurantDetailedModel? restaurant,
  }) async {
    final idx = await showActionSheet(
      context,
      title: 'Choose which menu you want',
      children:
          restaurant?.menus?.map((m) {
            return Row(
              children: [Icon(MdiIcons.check), GPSGaps.w10, Text(m.name ?? '')],
            );
          }).toList() ??
          [],
    );
    if (idx == null) return;
    final action = await showActionSheet(
      context,
      title: 'Do you want to edit or delete?',
      children: [
        Row(children: [Icon(MdiIcons.pen), GPSGaps.w10, Text('Edit')]),
        Row(children: [Icon(MdiIcons.trashCan), GPSGaps.w10, Text('Delete')]),
      ],
    );
    if (action == null) return;
    if (action == 0) {
      await _updateMenu(menu: restaurant?.menus?[idx]);
    } else if (action == 1) {
      final areYouSure = await showActionSheet(
        context,
        title: 'Are you sure you want to delete menu?',
        children: [
          Row(children: [Icon(MdiIcons.check), GPSGaps.w10, Text('Yes')]),
          Row(children: [Icon(MdiIcons.cancel), GPSGaps.w10, Text('No')]),
        ],
      );
      if (areYouSure != 0) return;
      _deleteMenu(restaurant: restaurant, menu: restaurant?.menus?[idx]);
    }
  }

  Future _updateMenu({required Menu? menu}) async {
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: menu?.name ?? '',
            controller: ctl,
            label: 'Update menu name',
          ),
    );
    if (newVal == null) return;
    final newState = cubit.state.data?.copyWith();
    menu?.name = newVal;
    cubit.update(newState!);
    final res = await UpdateController.update(
      path: 'restaurant-menus/${menu?.id}',
      data: {'name': newVal},
    );
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }

  Future _deleteMenu({
    required RestaurantDetailedModel? restaurant,
    required Menu? menu,
  }) async {
    final controller = serviceLocator<RestaurantsController>();
    restaurant?.menus?.remove(menu);
    cubit.update(cubit.state.data!);
    final res = await controller.deleteMenu(menu: menu!);
  }

  Future _updateUserImage({
    required RestaurantDetailedModel? restaurant,
  }) async {
    final storage = serviceLocator<LocalStorage>();
    final currentUser = userInMemory();
    final UploadedImage? newVal = await showFormBottomSheet<UploadedImage>(
      context,
      builder:
          (ctx, ctl) =>
              ProfileImageForm(controller: ctl, label: 'Update Your Image'),
    );
    if (newVal == null) return;
    restaurant?.user?.images = [ImageModel(path: newVal.path)];
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${currentUser?.id}',
      data: {'image_id': newVal.id},
    );
    if (res.response == ResponseEnum.success) {
      currentUser?.image = ImageModel(id: newVal.id, path: newVal.path);
      storage.cacheUser(currentUser);
    }
  }
}

final testTab = 'testTab';
