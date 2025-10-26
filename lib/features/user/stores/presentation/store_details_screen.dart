import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/store_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/tabbar_delegate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/branch_map_screen.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/profile_nav_button.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/badge_chip.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/circle_back.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/contact_card.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/empty_section_list.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/section_list_view.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/state_city_card.dart';
import 'package:gps_app/features/user/stores/presentation/widgets/today_hours_row.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({
    super.key,
    required this.user,
    required this.enableEdit,
    required this.enableCompleteProfile,
  });

  final UserModel user;
  final bool enableEdit;
  final bool enableCompleteProfile;
  @override
  State<StoreDetailsScreen> createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;
  StoreModel? get _store => widget.user.store;
  VendorModel? get _vendor => widget.user.vendor;

  List<CatalogSectionModel> get _sections => widget.user.sections();

  String get _title =>
      _vendor?.vendorName?.trim().isNotEmpty == true
          ? _vendor!.vendorName!
          : (widget.user.fullName ?? 'Store');

  String _imageUrl() {
    final path = widget.user.image?.path;
    if (path == null) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    return "${EndPoint.baseUrl}/$path";
  }

  bool get _isOpenNow {
    final oh = _vendor?.operatingHours;
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

  @override
  Widget build(BuildContext context) {
    final tabs = _sections.map((s) => s.name ?? 'Section').toList();

    return DefaultTabController(
      length: tabs.isEmpty ? 1 : tabs.length,
      child: Scaffold(
        backgroundColor: GPSColors.background,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerScrolled) => [
                SliverAppBar(
                  backgroundColor: GPSColors.background,
                  expandedHeight: 260,
                  pinned: true,
                  elevation: 0,
                  leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                  actions: [
                    IconButton(
                      tooltip: 'Share',
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_imageUrl(), fit: BoxFit.cover)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(1.02, 1.02), end: const Offset(1, 1)),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xAA000000), Color(0x55000000)],
                            ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: GPSColors.text,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Open Map',
                                icon: Icon(Icons.location_on),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BranchMapScreen(
                                            latitude: _store?.latitude?.toString() ?? '0',
                                            longitude: _store?.longitude?.toString() ?? '0',
                                            title: "$_title Location",
                                          ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ).animate(delay: 40.ms).fadeIn(duration: 150.ms),

                              IconButton(
                                tooltip: _isFav ? 'Remove from favorites' : 'Add to favorites',
                                onPressed: () => setState(() => _isFav = !_isFav),
                                icon: Icon(
                                  _isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                                  color: _isFav ? Colors.redAccent : GPSColors.mutedText,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 280.ms).slideY(begin: .1),

                          GPSGaps.h12,

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if ((_vendor?.address ?? '').isNotEmpty)
                                const BadgeChip(icon: Icons.place_rounded, label: 'Address'),
                              BadgeChip(
                                icon: _isOpenNow ? Icons.schedule_rounded : Icons.schedule_rounded,
                                label: _isOpenNow ? 'Open now' : 'Closed',
                                iconColor: _isOpenNow ? Colors.green : GPSColors.mutedText,
                              ),
                              if (widget.user.userType?.type == 'store')
                                const BadgeChip(icon: Icons.storefront_rounded, label: 'Store'),
                              if (widget.user.userType?.type == 'farm')
                                BadgeChip(icon: MdiIcons.tree, label: 'Store'),
                            ],
                          ).animate(delay: 70.ms).fadeIn(duration: 250.ms).slideY(begin: .08),

                          GPSGaps.h16,
                          if ((_vendor?.address ?? '').isNotEmpty)
                            Text(
                              _vendor!.address!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: GPSColors.mutedText,
                                height: 1.4,
                              ),
                            ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),
                          if (widget.user.state != null && widget.user.district != null)
                            GPSGaps.h16,
                          if (widget.user.state != null && widget.user.district != null)
                            StateCityCard(
                              state: widget.user.state!,
                              district: widget.user.district!,
                            ),
                          if ((_vendor?.address ?? '').isNotEmpty) GPSGaps.h16,
                          ContactCard(
                            email: widget.user.email,
                            mobile: widget.user.mobile,
                            website: _store?.website,
                          ),
                          if (_vendor?.operatingHours != null) GPSGaps.h16,
                          if (_vendor?.operatingHours != null)
                            TodayHoursRow(
                              operating: _vendor!.operatingHours!,
                            ).animate().fadeIn(duration: 240.ms).slideY(begin: .06),
                          // if (_vendor?.operatingHours != null) GPSGaps.h16,
                          GPSGaps.h10,
                          if (widget.user.sections().isEmpty && widget.enableCompleteProfile)
                            Column(
                              children: [
                                GPSGaps.h16,
                                ProfileCTAButton(
                                  label: 'Add Category',
                                  onPressed: () {
                                    Future.delayed(100.ms, () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed(AppRoutesNames.storeFarmOnboardingProductsScreen);
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
                            : TabBar(
                              isScrollable: true,
                              indicatorWeight: 3,
                              indicatorColor: GPSColors.primary,
                              labelColor: GPSColors.text,
                              unselectedLabelColor: GPSColors.mutedText,
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              tabs: [
                                for (final t in tabs)
                                  Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Text(t, style: const TextStyle(fontSize: 16)),
                                    ),
                                  ),
                              ],
                            ))
                        .animate()
                        .fadeIn(duration: 220.ms)
                        .slideY(begin: .08),
                  ),
                ),
              ],
          body:
              tabs.isEmpty
                  ? EmptySectionList(items: _flatItems(), heroPrefix: 'all-0')
                  : TabBarView(
                    children: [
                      for (int ti = 0; ti < tabs.length; ti++)
                        SectionListView(section: _sections[ti], heroPrefix: 'tab$ti'),
                    ],
                  ),
        ),
      ),
    );
  }

  List<CatalogItemModel> _flatItems() {
    final list = <CatalogItemModel>[];
    for (final s in _sections) {
      list.addAll(s.items ?? const []);
    }
    return list;
  }
}
