import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurants/presentation/branch_list.dart';
import 'package:gps_app/features/user/restaurants/presentation/certifications_screen.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/branch_nav_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'badges.dart';
import 'circle_back.dart';
import 'helpers.dart';
import 'loading_error_scaffolds.dart';
import 'menu_meals_list_view.dart';
import 'reviews.dart';
import 'tab_bar_delegate.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key, this.restaurantId = 1});
  final int restaurantId;

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;

  // Static reviews (kept)
  late final List<Review> _reviews = const [
    Review(
      reviewerName: 'Amina H.',
      comment: 'Amazing grass-fed options. The short ribs were melt-in-mouth!',
      rating: 4.5,
    ),
    Review(
      reviewerName: 'Omar K.',
      comment: 'Great ingredients. Loved the raw cheese board.',
      rating: 4.0,
    ),
    Review(
      reviewerName: 'Layla S.',
      comment: 'Kimchi chicken was perfectly spicy. Friendly staff.',
      rating: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, ApiResponseModel<RestaurantDetailedModel>>(
      listener: (context, state) {
        // reserved for future side effects
      },
      builder: (context, state) {
        switch (state.response) {
          case ResponseEnum.initial:
          case ResponseEnum.loading:
            return const LoadingScaffold();

          case ResponseEnum.failed:
            return ErrorScaffold(
              onRetry:
                  () =>
                      context.read<RestaurantCubit>().restaurant(restaurantId: widget.restaurantId),
            );

          case ResponseEnum.success:
            final menus = state.data?.menus ?? const <Menu>[];
            final tabs = menus.map((m) => m.name ?? 'Menu').toList();

            // Cover image = user.images[0].path
            final String coverUrl = resolveMediaUrl(
              state.data?.user?.images?.isNotEmpty == true
                  ? state.data!.user!.images!.first.path
                  : null,
            );

            // Title: vendor.vendorName or fallback
            final restaurantTitle =
                (state.data?.vendor?.vendorName?.trim().isNotEmpty ?? false)
                    ? state.data!.vendor!.vendorName!
                    : 'Restaurant';

            return DefaultTabController(
              length: tabs.length,
              child: Scaffold(
                backgroundColor: GPSColors.background,
                body: NestedScrollView(
                  headerSliverBuilder:
                      (context, inner) => [
                        SliverAppBar(
                          backgroundColor: GPSColors.background,
                          expandedHeight: 260,
                          pinned: true,
                          elevation: 0,
                          leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                          actions: [
                            IconButton(
                              tooltip: 'Share',
                              icon: const Icon(Icons.share_rounded, color: Colors.black),
                              onPressed: () {}, // TODO: wire share logic
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                      imageUrl: coverUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => const CoverPlaceholder(),
                                      errorWidget: (_, __, ___) => const CoverError(),
                                    )
                                    .animate()
                                    .fadeIn(duration: 400.ms)
                                    .scale(
                                      begin: const Offset(1.02, 1.02),
                                      end: const Offset(1, 1),
                                    ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Color(0x55000000)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Info block
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
                                          restaurantTitle,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall?.copyWith(
                                            color: GPSColors.text,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        tooltip:
                                            _isFav ? 'Remove from favorites' : 'Add to favorites',
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
                                          ...(state.data?.mainCategories ?? []).map(
                                            (c) => BadgeChip(label: c.name ?? ''),
                                          ),
                                          ...(state.data?.subCategories ?? []).map(
                                            (c) => BadgeChip(label: c.name ?? ''),
                                          ),
                                        ],
                                      )
                                      .animate(delay: 70.ms)
                                      .fadeIn(duration: 250.ms)
                                      .slideY(begin: .08),

                                  GPSGaps.h16,

                                  // GPSGaps.h8,
                                  // Text(
                                  //   'Neighborhood kitchen serving grass-fed meats, raw cheeses, and seasonal produce from nearby farms.',
                                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  //     color: GPSColors.mutedText,
                                  //     height: 1.4,
                                  //   ),
                                  // ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),
                                  GPSGaps.h16,
                                  // const SectionHeader(title: 'Reviews'),
                                  // ReviewsSection(reviews: _reviews),
                                  BranchCTAButton(
                                    label: 'View Branches',
                                    onPressed: () {
                                      Future.delayed(100.ms, () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => BranchList(
                                                  branches: state.data?.branches ?? [],
                                                ),
                                          ),
                                        );
                                      });
                                    },
                                    icon: MdiIcons.foodForkDrink,
                                    tooltip: 'Go to branch details',
                                    expand: true,
                                  ),
                                  GPSGaps.h8,
                                  BranchCTAButton(
                                    label: 'View Certifications',
                                    onPressed: () {
                                      Future.delayed(100.ms, () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => CertificationsScreen(
                                                  items: state.data?.certifications ?? [],
                                                ),
                                          ),
                                        );
                                      });
                                    },
                                    icon: MdiIcons.certificate,
                                    tooltip: 'Go to branch details',
                                    expand: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Pinned TabBar
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: TabBarDelegate(
                            TabBar(
                              isScrollable: true,
                              indicatorWeight: 3,
                              indicatorColor: Colors.green,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              tabs: [
                                for (final t in tabs)
                                  Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(t, style: const TextStyle(fontSize: 16)),
                                    ),
                                  ),
                              ],
                            ).animate().fadeIn(duration: 220.ms).slideY(begin: .08),
                          ),
                        ),
                      ],
                  body: TabBarView(
                    children: [
                      for (int ti = 0; ti < tabs.length; ti++)
                        MenuMealsListView(
                          heroPrefix: 'tab$ti',
                          meals: menus[ti].meals ?? const <Meal>[],
                        ),
                    ],
                  ),
                ),
              ),
            );
          case null:
            return SizedBox();
        }
      },
    );
  }
}
