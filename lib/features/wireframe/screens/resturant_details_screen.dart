import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';
import 'package:gps_app/features/wireframe/widgets/reviews_section.dart';

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
                  leading: _CircleBack(onTap: () => Navigator.of(context).maybePop()),
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
                              _BadgeChip(label: '100% Grass-fed'),
                              _BadgeChip(label: 'Organic'),
                              _BadgeChip(label: 'Locally sourced'),
                              _BadgeChip(label: 'Non-GMO'),
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
                          const _SectionHeader(title: 'Reviews'),
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
                  delegate: _TabBarDelegate(
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
                _MenuListView(items: _menus[tabs[ti]]!, heroPrefix: 'tab$ti'),
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

class _MenuListView extends StatelessWidget {
  const _MenuListView({required this.items, required this.heroPrefix});
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

        return _MenuItemCard(item: item, heroTag: '$heroPrefix-$index')
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({required this.item, required this.heroTag});
  final MenuItem item;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
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
              _Thumb(heroTag: heroTag).animate().fadeIn(duration: 200.ms),
              GPSGaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: textTheme.titleMedium?.copyWith(
                              color: GPSColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _PriceBadge(price: item.price),
                      ],
                    ),
                    GPSGaps.h8,
                    Text(
                      item.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: GPSColors.mutedText,
                        height: 1.35,
                      ),
                    ),
                    GPSGaps.h8,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (item.isSpicy)
                          const _Pill(label: 'Spicy', icon: Icons.local_fire_department_rounded),
                        for (final t in item.tags) _Pill(label: t),
                      ],
                    ),
                    GPSGaps.h12,
                    Row(
                      children: [
                        // Expanded(child: _AddButton(label: 'Add to order', onTap: () {})),
                        Spacer(),
                        // GPSGaps.w12,
                        _IconAction(icon: Icons.favorite_border_rounded, onTap: () {}),
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

class _Thumb extends StatelessWidget {
  const _Thumb({required this.heroTag});
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800&auto=format&fit=crop',
          width: 86,
          height: 86,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                width: 86,
                height: 86,
                color: GPSColors.cardBorder,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined, color: GPSColors.mutedText),
              ),
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(.95, .95));
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: GPSColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white),
            GPSGaps.w8,
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: .06);
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: GPSColors.text),
      ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.96, .96)),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.icon});
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 14, color: GPSColors.primary), GPSGaps.w8],
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(999),
      ),
      child: content,
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack({this.onTap});
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

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this._tabBar);
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
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
