import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/badge_chip.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/circle_back.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/menu_list_view.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/section_header.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/tabbar_delegate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/reviews_section.dart';

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
                  leading: CircleBack(
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Share',
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.black,
                      ),
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

                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: GPSColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
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
                                        _isFav
                                            ? 'Remove from favorites'
                                            : 'Add to favorites',
                                    onPressed:
                                        () => setState(() => _isFav = !_isFav),
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
                              )
                              .animate()
                              .fadeIn(duration: 280.ms)
                              .slideY(begin: .1),

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
                              )
                              .animate(delay: 70.ms)
                              .fadeIn(duration: 250.ms)
                              .slideY(begin: .08),

                          GPSGaps.h16,

                          // const _SectionHeader(title: 'About'),
                          // GPSGaps.h16,
                          GPSGaps.h8,
                          Text(
                            'Neighborhood kitchen serving grass-fed meats, raw cheeses, and seasonal produce from nearby farms.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
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
                      labelStyle: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
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
