// restaurant_detail_screen.dart (refactored)
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/menu_item_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

// === import your models ===

// === TEMP: same MenuItem class you used for MenuItemCard ===
// (If it's already defined elsewhere, use that one; this is just to show the adapter.)
class MenuItem {
  final String name;
  final String description;
  final double price;
  final bool isSpicy;
  final List<String> tags;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.isSpicy,
    required this.tags,
  });
}

// === Helpers ===
const String kMediaBaseUrl =
    'https://your-backend.example.com/'; // <-- change to your files base URL

String resolveMediaUrl(String? path) {
  if (path == null || path.isEmpty) {
    return 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1600&auto=format&fit=crop';
  }
  if (path.startsWith('http')) return path;
  // join base + relative (very naive join; consider Uri if needed)
  return kMediaBaseUrl.endsWith('/') ? '$kMediaBaseUrl$path' : '$kMediaBaseUrl/$path';
}

double parsePrice(String? s) {
  if (s == null) return 0.0;
  final v = double.tryParse(s.trim());
  return v ?? 0.0;
}

class RestaurantDetailProvider extends StatelessWidget {
  const RestaurantDetailProvider({super.key, required this.model, this.restaurantId = 1});
  final RestaurantDetailedModel model;
  final int restaurantId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantCubit()..restaurant(restaurantId: restaurantId),
      child: RestaurantDetailWidget(model: model, restaurantId: restaurantId),
    );
  }
}

class RestaurantDetailWidget extends StatefulWidget {
  const RestaurantDetailWidget({super.key, required this.model, this.restaurantId = 1});

  final RestaurantDetailedModel model;
  final int restaurantId;

  @override
  State<RestaurantDetailWidget> createState() => _RestaurantDetailWidgetState();
}

class _RestaurantDetailWidgetState extends State<RestaurantDetailWidget>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;

  // Static reviews remain as-is (per requirements)
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
    final menus = widget.model.menus ?? const <Menu>[];
    final tabs = menus.map((m) => m.name ?? 'Menu').toList();

    // Cover image = user.images[0].path
    final String coverUrl = resolveMediaUrl(
      widget.model.user?.images?.isNotEmpty == true ? widget.model.user!.images!.first.path : null,
    );

    // Fallback restaurant title: vendor.vendorName or "Restaurant"
    final restaurantTitle =
        widget.model.vendor?.vendorName?.trim().isNotEmpty == true
            ? widget.model.vendor!.vendorName!
            : 'Restaurant';
    return BlocConsumer<RestaurantCubit, ApiResponseModel<RestaurantDetailedModel>>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
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
                          onPressed: () {}, // TODO: wire your share logic
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(coverUrl, fit: BoxFit.cover)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .scale(begin: const Offset(1.02, 1.02), end: const Offset(1, 1)),
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

                    // Info block (title, badges, about, reviews)
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
                                      restaurantTitle, // dynamic title
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: GPSColors.text,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
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

                              // Keep badges static (per requirements)
                              const Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  BadgeChip(label: '100% Grass-fed'),
                                  BadgeChip(label: 'Organic'),
                                  BadgeChip(label: 'Locally sourced'),
                                  BadgeChip(label: 'Non-GMO'),
                                ],
                              ).animate(delay: 70.ms).fadeIn(duration: 250.ms).slideY(begin: .08),

                              GPSGaps.h16,

                              // Simple dynamic about from vendor.address if you want, or keep static.
                              // Requirement: it's okay to keep this static; keeping your original static text:
                              GPSGaps.h8,
                              Text(
                                'Neighborhood kitchen serving grass-fed meats, raw cheeses, and seasonal produce from nearby farms.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: GPSColors.mutedText,
                                  height: 1.4,
                                ),
                              ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),

                              GPSGaps.h16,
                              const SectionHeader(title: 'Reviews'),
                              ReviewsSection(reviews: _reviews),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Pinned TabBar (dynamic from menus)
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

              // Tab bodies → each menu.meals (adapt Meal → MenuItem for your existing MenuItemCard)
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
      },
    );
  }
}

// =============== Components you already had (kept) ===============

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: GPSColors.primary),
          GPSGaps.w8,
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class CircleBack extends StatelessWidget {
  const CircleBack({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ).animate().fadeIn().scale(begin: const Offset(.95, .95)),
      ),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  TabBarDelegate(this._tabBar);
  final Widget _tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: GPSColors.background,
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            color: GPSColors.background,
            border: Border(
              bottom: BorderSide(color: GPSColors.cardBorder),
              top: BorderSide(color: GPSColors.cardBorder),
            ),
          ),
          child: _tabBar,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 52;
  @override
  double get minExtent => 52;
  @override
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) => false;
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: GPSColors.mutedText),
      ],
    ).animate().fadeIn(duration: 220.ms).slideY(begin: .08);
  }
}

// Simple review model & section kept (static)
class Review {
  final String reviewerName;
  final String comment;
  final double rating;
  const Review({required this.reviewerName, required this.comment, required this.rating});
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key, required this.reviews});
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'No reviews yet.',
          style: theme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 240.ms).slideY(begin: .06);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, i) {
        final r = reviews[i];
        final delay = (80 * i).ms;
        return _ReviewCard(review: r)
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Ink(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    review.reviewerName,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StarRow(rating: review.rating, size: 18),
              ],
            ),
            GPSGaps.h8,
            Text(
              review.comment,
              style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: .05),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, this.size = 20, this.color});

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? const Color(0xFFFFC107);
    final stars = List<Widget>.generate(5, (i) {
      final idx = i + 1;
      IconData icon;
      if (rating >= idx) {
        icon = Icons.star_rounded;
      } else if (rating >= idx - 0.5) {
        icon = Icons.star_half_rounded;
      } else {
        icon = Icons.star_border_rounded;
      }
      return Icon(icon, size: size, color: c);
    });

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

// ================== Meals list using your existing MenuItemCard ==================

class MenuMealsListView extends StatelessWidget {
  const MenuMealsListView({super.key, required this.meals, required this.heroPrefix});

  final List<Meal> meals;
  final String heroPrefix;

  // Adapter: Meal -> MenuItem (for your existing MenuItemCard)
  MenuItem _toMenuItem(Meal meal) {
    return MenuItem(
      name: meal.name ?? '',
      description: meal.description ?? '',
      price: parsePrice(meal.price),
      isSpicy: false, // keep static as requested
      tags: const [], // keep static; your card can still render default tags
    );
    // If you want to keep your *old* static tags (like ['Spicy'] for some items),
    // inject them here based on any heuristic you prefer.
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: meals.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final item = _toMenuItem(meals[index]);
        final delay = (70 * index).ms;
        return MenuItemCard(item: item, heroTag: '$heroPrefix-$index')
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}
