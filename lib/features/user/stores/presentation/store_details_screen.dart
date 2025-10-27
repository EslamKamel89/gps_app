import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/store_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/branch_map_screen.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/profile_nav_button.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/show_action_sheet.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/tab_bar_delegate.dart';
import 'package:gps_app/features/user/stores/cubits/store_cubit.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/badge_chip.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/circle_back.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/contact_card.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/section_list_view.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/state_city_card.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/store_details_skeleton.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/today_hours_row.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({
    super.key,
    required this.enableEdit,
    required this.enableCompleteProfile,
  });

  final bool enableEdit;
  final bool enableCompleteProfile;
  @override
  State<StoreDetailsScreen> createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;
  bool _editNameLocation = false;
  String _imageUrl(UserModel? user) {
    final path = user?.image?.path;
    if (path == null) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    return "${EndPoint.baseUrl}/$path";
  }

  bool _isOpenNow(UserModel? user) {
    final oh = user?.vendor?.operatingHours;
    if (oh == null) return false;

    final now = DateTime.now();
    final weekdayKey =
        <int, String>{1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu', 5: 'fri', 6: 'sat', 7: 'sun'}[now
            .weekday]!;

    List<String>? slot;
    switch (weekdayKey) {
      case 'mon':
        slot = oh.mon;
        break;
      case 'tue':
        slot = oh.tue;
        break;
      case 'wed':
        slot = oh.wed;
        break;
      case 'thu':
        slot = oh.thu;
        break;
      case 'fri':
        slot = oh.fri;
        break;
      case 'sat':
        slot = oh.sat;
        break;
      case 'sun':
        slot = oh.sun;
        break;
    }
    if (slot == null || slot.length < 2) return false;

    TimeOfDay? parse(String s) {
      final parts = s.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: h, minute: m);
    }

    final start = parse(slot[0]);
    final end = parse(slot[1]);
    if (start == null || end == null) return false;

    bool inside(TimeOfDay a, TimeOfDay b, DateTime x) {
      final xTod = TimeOfDay(hour: x.hour, minute: x.minute);
      int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
      final xs = toMinutes(xTod), as = toMinutes(a), bs = toMinutes(b);
      if (as <= bs) return xs >= as && xs <= bs;

      return xs >= as || xs <= bs;
    }

    return inside(start, end, now);
  }

  late StoreCubit cubit;
  @override
  void initState() {
    cubit = context.read<StoreCubit>()..user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, ApiResponseModel<UserModel>>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? user = state.data;
        StoreModel? storeOrFarm = user?.storeOrFarm();
        VendorModel? vendor = user?.vendor;

        List<CatalogSectionModel> sections = user?.sections() ?? [];

        String title =
            vendor?.vendorName?.trim().isNotEmpty == true
                ? vendor!.vendorName!
                : (user?.fullName ?? 'Store');
        final tabs = sections.map((s) => s.name ?? 'Section').toList();
        return SafeArea(
          child: DefaultTabController(
            length: tabs.isEmpty ? 1 : tabs.length,
            child: Scaffold(
              backgroundColor: GPSColors.background,
              body:
                  state.response == ResponseEnum.loading
                      ? Padding(padding: EdgeInsets.all(10), child: StoreDetailsSkeleton())
                      : NestedScrollView(
                        headerSliverBuilder:
                            (context, innerScrolled) => [
                              SliverAppBar(
                                backgroundColor: GPSColors.background,
                                expandedHeight: 260,
                                pinned: true,
                                elevation: 0,
                                leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                                actions: [
                                  // IconButton(
                                  //   tooltip: 'Share',
                                  //   icon: const Icon(Icons.share_rounded, color: Colors.white),
                                  //   onPressed: () {
                                  //     // pr(widget.user.sections().length);
                                  //   },
                                  // ),
                                ],
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CustomStack(
                                        enableEdit: widget.enableEdit,
                                        actionWidget: EditButton(
                                          onPressed: () async {
                                            _updateUserImage(user: user!);
                                          },
                                        ),
                                        child: Image.network(
                                              _imageUrl(user),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                            .animate()
                                            .fadeIn(duration: 400.ms)
                                            .scale(
                                              begin: const Offset(1.02, 1.02),
                                              end: const Offset(1, 1),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SliverToBoxAdapter(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: GPSColors.background,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomStack(
                                          enableEdit: widget.enableEdit,
                                          actionWidget: EditButton(
                                            onPressed: () {
                                              setState(() {
                                                _editNameLocation = !_editNameLocation;
                                              });
                                            },
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomStack(
                                                  enableEdit:
                                                      widget.enableEdit && _editNameLocation,
                                                  actionWidget: EditButton(
                                                    onPressed: () async {
                                                      _updateVendorName(user: user);
                                                    },
                                                  ),
                                                  child: Text(
                                                    title,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.headlineSmall?.copyWith(
                                                      color: GPSColors.text,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              CustomStack(
                                                enableEdit: widget.enableEdit && _editNameLocation,
                                                actionWidget: EditButton(
                                                  onPressed: () async {
                                                    _updateVendorLocation(user: user);
                                                  },
                                                ),
                                                child: IconButton(
                                                  tooltip: 'Open Map',
                                                  icon: Icon(MdiIcons.mapMarker),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder:
                                                            (_) => BranchMapScreen(
                                                              latitude:
                                                                  storeOrFarm?.latitude
                                                                      ?.toString() ??
                                                                  '0',
                                                              longitude:
                                                                  storeOrFarm?.longitude
                                                                      ?.toString() ??
                                                                  '0',
                                                              title: "$title Location",
                                                            ),
                                                        fullscreenDialog: true,
                                                      ),
                                                    );
                                                  },
                                                ).animate(delay: 40.ms).fadeIn(duration: 150.ms),
                                              ),

                                              IconButton(
                                                tooltip:
                                                    _isFav
                                                        ? 'Remove from favorites'
                                                        : 'Add to favorites',
                                                onPressed: () => setState(() => _isFav = !_isFav),
                                                icon: Icon(
                                                  _isFav
                                                      ? Icons.favorite_rounded
                                                      : Icons.favorite_outline,
                                                  color:
                                                      _isFav
                                                          ? Colors.redAccent
                                                          : GPSColors.mutedText,
                                                ),
                                              ),
                                            ],
                                          ).animate().fadeIn(duration: 280.ms).slideY(begin: .1),
                                        ),

                                        GPSGaps.h12,

                                        Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: [
                                                BadgeChip(
                                                  icon:
                                                      _isOpenNow(user)
                                                          ? Icons.schedule_rounded
                                                          : Icons.schedule_rounded,
                                                  label: _isOpenNow(user) ? 'Open now' : 'Closed',
                                                  iconColor:
                                                      _isOpenNow(user)
                                                          ? Colors.green
                                                          : GPSColors.mutedText,
                                                ),
                                                if (user?.userType?.type == 'store')
                                                  const BadgeChip(
                                                    icon: Icons.storefront_rounded,
                                                    label: 'Store',
                                                  ),
                                                if (user?.userType?.type == 'farm')
                                                  BadgeChip(icon: MdiIcons.tree, label: 'Store'),
                                              ],
                                            )
                                            .animate(delay: 70.ms)
                                            .fadeIn(duration: 250.ms)
                                            .slideY(begin: .08),

                                        GPSGaps.h16,
                                        if ((vendor?.address ?? '').isNotEmpty)
                                          CustomStack(
                                            enableEdit: widget.enableEdit,
                                            actionWidget: EditButton(
                                              onPressed: () async {
                                                _updateVendorAddress(user: user);
                                              },
                                            ),
                                            child: Text(
                                              vendor!.address!,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: GPSColors.mutedText,
                                                height: 1.4,
                                              ),
                                            ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),
                                          ),
                                        if (user?.state != null && user?.district != null)
                                          GPSGaps.h16,
                                        if (user?.state != null && user?.district != null)
                                          CustomStack(
                                            enableEdit: widget.enableEdit,
                                            actionWidget: EditButton(
                                              onPressed: () async {
                                                _updateUserStateDistrict(user);
                                              },
                                            ),
                                            child: StateCityCard(
                                              state: (user?.state)!,
                                              district: (user?.district)!,
                                            ),
                                          ),
                                        if ((vendor?.address ?? '').isNotEmpty) GPSGaps.h16,
                                        ContactCard(user: user, enableEdit: widget.enableEdit),
                                        if (vendor?.operatingHours != null) GPSGaps.h16,
                                        if (vendor?.operatingHours != null)
                                          TodayHoursRow(
                                            operating: vendor!.operatingHours!,
                                          ).animate().fadeIn(duration: 240.ms).slideY(begin: .06),
                                        // if (_vendor?.operatingHours != null) GPSGaps.h16,
                                        GPSGaps.h10,
                                        if ((user?.sections() ?? []).isEmpty &&
                                            widget.enableCompleteProfile)
                                          Column(
                                            children: [
                                              GPSGaps.h16,
                                              ProfileCTAButton(
                                                label: 'Add Category',
                                                onPressed: () {
                                                  Future.delayed(100.ms, () {
                                                    Navigator.of(context).pushNamed(
                                                      AppRoutesNames
                                                          .storeFarmOnboardingProductsScreen,
                                                    );
                                                  });
                                                },
                                                icon: MdiIcons.foodForkDrink,
                                                expand: true,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SliverPersistentHeader(
                                pinned: true,
                                delegate: TabBarDelegate(
                                  (tabs.isEmpty
                                      ? const TabBar(
                                        tabs: [Tab(text: 'Items')],
                                        indicatorWeight: 3,
                                        indicatorColor: GPSColors.primary,
                                        labelColor: GPSColors.text,
                                        unselectedLabelColor: GPSColors.mutedText,
                                      )
                                      : PreferredSize(
                                        preferredSize: const Size.fromHeight(kTextTabBarHeight),
                                        child: Material(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          child: CustomStack(
                                            enableEdit: widget.enableEdit,
                                            actionWidget: EditButton(
                                              onPressed: () async {
                                                _updateSectionsNames(user: user);
                                              },
                                            ),
                                            child: TabBar(
                                              isScrollable: true,
                                              indicatorWeight: 3,
                                              indicatorColor: Colors.green,
                                              labelColor: Colors.black,
                                              unselectedLabelColor: Colors.grey,
                                              labelStyle: Theme.of(context).textTheme.titleSmall
                                                  ?.copyWith(fontWeight: FontWeight.w800),
                                              tabs: [
                                                for (final t in tabs)
                                                  Tab(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 2.0,
                                                      ),
                                                      child: Text(
                                                        t,
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  // .animate()
                                  // .fadeIn(duration: 220.ms)
                                  // .slideY(begin: .08),
                                ),
                              ),
                            ],
                        body: TabBarView(
                          children: [
                            for (int ti = 0; ti < tabs.length; ti++)
                              SectionListView(
                                section: sections[ti],
                                heroPrefix: 'tab$ti',
                                enableEdit: widget.enableEdit,
                              ),
                          ],
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  Future _updateVendorName({required UserModel? user}) async {
    final storage = serviceLocator<LocalStorage>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: user?.vendor?.vendorName,
            controller: ctl,
            label: 'Update your name',
          ),
    );
    if (newVal == null) return;
    cubit.state.data?.vendor?.vendorName = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'vendor/${user?.vendor?.id}',
      data: {'vendor_name': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateVendorAddress({required UserModel? user}) async {
    final storage = serviceLocator<LocalStorage>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: user?.vendor?.address,
            controller: ctl,
            label: 'Update your address',
          ),
    );
    if (newVal == null) return;
    cubit.state.data?.vendor?.address = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'vendor/${user?.vendor?.id}',
      data: {'address': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateVendorLocation({required UserModel? user}) async {
    final storage = serviceLocator<LocalStorage>();
    final LatLng? newVal = await showFormBottomSheet<LatLng>(
      context,
      builder: (ctx, ctl) => ProfileLocationForm(controller: ctl, label: 'Update your location'),
    );
    if (newVal == null) return;
    final type = user?.userType?.type;
    if (type == 'farm') {
      user?.farm?.latitude = newVal.latitude;
      user?.farm?.longitude = newVal.longitude;
    }
    if (type == 'store') {
      user?.farm?.latitude = newVal.latitude;
      user?.farm?.longitude = newVal.longitude;
    }
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: '$type/${user?.storeOrFarm()?.id}',
      data: {'latitude': newVal.latitude, 'longitude': newVal.longitude},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateUserStateDistrict(UserModel? user) async {
    final storage = serviceLocator<LocalStorage>();
    final SelectedStateAndDistrict? newVal = await showFormBottomSheet<SelectedStateAndDistrict>(
      context,
      builder: (ctx, ctl) => ProfileStateSelectionForm(controller: ctl),
    );
    if (newVal == null || newVal.selectedState == null || newVal.selectedDistrict == null) {
      return;
    }
    user?.state = newVal.selectedState;
    user?.district = newVal.selectedDistrict;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${user?.id}',
      data: {'state_id': newVal.selectedState?.id, 'district_id': newVal.selectedDistrict?.id},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateSectionsNames({required UserModel? user}) async {
    final storage = serviceLocator<LocalStorage>();
    final sections = user?.storeOrFarm()?.sections;
    final idx = await showActionSheet(
      context,
      title: 'Choose which category name to edit',
      children:
          sections?.map((m) {
            return Row(children: [Icon(MdiIcons.pen), GPSGaps.w10, Text(m.name ?? '')]);
          }).toList() ??
          [],
    );
    if (idx == null) return;
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: sections?[idx].name ?? '',
            controller: ctl,
            label: 'Update category name',
          ),
    );
    if (newVal == null) return;
    sections?[idx].name = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'catalog-sections/${sections?[idx].id}',
      data: {'name': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateUserImage({required UserModel user}) async {
    final storage = serviceLocator<LocalStorage>();
    final UploadedImage? newVal = await showFormBottomSheet<UploadedImage>(
      context,
      builder: (ctx, ctl) => ProfileImageForm(controller: ctl, label: 'Update Your Image'),
    );
    if (newVal == null) return;
    user.image?.path = newVal.path;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${user.id}',
      data: {'image_id': newVal.id},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }
}
