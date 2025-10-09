import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/menu_item_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;

  late final Map<String, List<MenuItem>> _menus = {
    'Meat Lovers': [
      MenuItem(
        name: 'Grass-Fed Beef Burger',
        description: '200g patty, raw cheddar, pickles, sprouted bun',
        price: 12.95,
        isSpicy: false,
        tags: const ['100% Grass-fed', 'Local'],
      ),
      MenuItem(
        name: 'Wood-Smoked Short Ribs',
        description: '24h brine, slow smoked, rosemary jus',
        price: 19.50,
        isSpicy: false,
        tags: const ['Slow Cooked'],
      ),
      MenuItem(
        name: 'Harissa Lamb Skewers',
        description: 'Free-range lamb, citrus yogurt, mint',
        price: 15.75,
        isSpicy: true,
        tags: const ['Spicy'],
      ),
    ],
    'Cheese Lovers': [
      MenuItem(
        name: 'Raw Milk Cheese Board',
        description: 'Farm selection, seasonal fruit, sprouted crackers',
        price: 14.20,
        isSpicy: false,
        tags: const ['Raw Milk', 'Local'],
      ),
      MenuItem(
        name: 'Baked Brie & Honey',
        description: 'Wildflower honey, toasted walnuts, sourdough',
        price: 10.90,
        isSpicy: false,
        tags: const ['Vegetarian'],
      ),
      MenuItem(
        name: 'Halloumi Herb Fries',
        description: 'Crisp halloumi, olive oil, thyme',
        price: 9.60,
        isSpicy: false,
        tags: const ['Vegetarian', 'Share'],
      ),
    ],
    "Today's Specials": [
      MenuItem(
        name: 'Wild Salmon Bowl',
        description: 'Quinoa, avocado, citrus greens, dill dressing',
        price: 17.40,
        isSpicy: false,
        tags: const ['Omega-3', 'Gluten-Free'],
      ),
      MenuItem(
        name: 'Truffle Mushroom Tagliatelle',
        description: 'Cremini, porcini, shaved truffle, parmigiano',
        price: 16.30,
        isSpicy: false,
        tags: const ['Vegetarian'],
      ),
      MenuItem(
        name: 'Spicy Kimchi Chicken',
        description: 'Fermented kimchi glaze, sesame, scallion',
        price: 13.80,
        isSpicy: true,
        tags: const ['Spicy'],
      ),
    ],
  };
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
    final tabs = _menus.keys.toList();
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
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                              'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1600&auto=format&fit=crop',
                              fit: BoxFit.cover,
                            )
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
                                  'True Acre',
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

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: const [
                              BadgeChip(label: '100% Grass-fed'),
                              BadgeChip(label: 'Organic'),
                              BadgeChip(label: 'Locally sourced'),
                              BadgeChip(label: 'Non-GMO'),
                            ],
                          ).animate(delay: 70.ms).fadeIn(duration: 250.ms).slideY(begin: .08),

                          GPSGaps.h16,

                          // const _SectionHeader(title: 'About'),
                          // GPSGaps.h16,
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
                          // GPSGaps.h8,
                          ReviewsSection(reviews: _reviews),
                          // const _SectionHeader(title: 'Menu'),
                          // GPSGaps.h8,
                          // _AddToFavoritesRow(
                          //   isFav: _isFav,
                          //   onChanged: (v) => setState(() => _isFav = v),
                          // ).animate().fadeIn(duration: 260.ms).slideY(begin: .06),
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
                              child: Text(t, style: TextStyle(fontSize: 16)),
                            ),
                          ),
                      ],
                    ).animate().fadeIn(duration: 220.ms).slideY(begin: .08),
                  ),
                ),
              ],

          // Tab bodies
          body: TabBarView(
            children: [
              for (int ti = 0; ti < tabs.length; ti++)
                MenuListView(items: _menus[tabs[ti]]!, heroPrefix: 'tab$ti'),
            ],
          ),
        ),
      ),
    );
  }
}

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

class Review {
  final String reviewerName;
  final String comment;

  final double rating;

  const Review({required this.reviewerName, required this.comment, required this.rating});
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    super.key,
    required this.reviews,
    this.title = 'Reviews',
    this.compact = false,
  });

  final List<Review> reviews;
  final String title;
  final bool compact;

  double get _avg {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        // Row(
        //   children: [
        //     Expanded(
        //       child: Text(
        //         title,
        //         style: theme.titleMedium?.copyWith(
        //           color: GPSColors.text,
        //           fontWeight: FontWeight.w800,
        //         ),
        //       ),
        //     ),
        //     // Average badge
        //     _AvgRatingBadge(avg: _avg, count: reviews.length),
        //   ],
        // ).animate().fadeIn(duration: 220.ms).slideY(begin: .08),

        // GPSGaps.h12,
        if (reviews.isEmpty)
          Container(
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
          ).animate().fadeIn(duration: 240.ms).slideY(begin: .06)
        else
          ListView.separated(
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
          ),
      ],
    );
  }
}

class _AvgRatingBadge extends StatelessWidget {
  const _AvgRatingBadge({required this.avg, required this.count});
  final double avg;
  final int count;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StarRow(rating: avg, size: 16, color: Colors.amber),
          GPSGaps.w8,
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: avg),
            duration: 300.ms,
            builder:
                (_, v, __) => Text(
                  v.toStringAsFixed(1),
                  style: txt.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
          ),
          GPSGaps.w8,
          Text('($count)', style: txt.labelMedium?.copyWith(color: Colors.white70)),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.95, .95));
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
    final Color c = color ?? const Color(0xFFFFC107); // default amber
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

class MenuListView extends StatelessWidget {
  const MenuListView({super.key, required this.items, required this.heroPrefix});
  final List<MenuItem> items;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final item = items[index];
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
