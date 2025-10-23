import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class GrassFedGuideScreen extends StatefulWidget {
  const GrassFedGuideScreen({super.key});

  @override
  State<GrassFedGuideScreen> createState() => _GrassFedGuideScreenState();
}

class _GrassFedGuideScreenState extends State<GrassFedGuideScreen> {
  final _heroImages = const [
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    'https://plus.unsplash.com/premium_photo-1723708920667-5e8816cc3fb0?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    'https://plus.unsplash.com/premium_photo-1670601440146-3b33dfcd7e17?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=938',
  ];

  int _heroIndex = 0;
  final _pageCtrl = PageController();

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: GPSColors.background,
        // Transparent AppBar sitting over hero (simple, no back/share)
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Grass-Fed Guide',
            style: txt.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HERO: Carousel with gradient overlay, dots & caption
              _HeroCarousel(
                    images: _heroImages,
                    controller: _pageCtrl,
                    onPageChanged: (i) => setState(() => _heroIndex = i),
                    caption: '100% Grass-Fed • Pasture',
                  )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .scale(begin: const Offset(1.02, 1.02)),

              GPSGaps.h16,

              // Trust / Attribute Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _BadgeChip(label: '100% Grass-Fed'),
                        _BadgeChip(label: 'Grass-Finished'),
                        _BadgeChip(label: 'Pasture-Raised'),
                        _BadgeChip(label: 'No Antibiotics'),
                        _BadgeChip(label: 'Non-GMO Feed'),
                        _BadgeChip(label: 'Local • Organic'),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 240.ms)
                    .scale(begin: const Offset(.96, .96)),
              ),

              GPSGaps.h20,

              // Tabs + content (last child as required)
              const _SectionTabs(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({
    required this.images,
    required this.controller,
    required this.onPageChanged,
    required this.caption,
  });

  final List<String> images;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: images.length,
            itemBuilder: (_, i) {
              final url = images[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Cached image with shimmer loading + error icon
                  CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) => _ShimmerBox.rounded(radius: 0),
                    errorWidget: (ctx, _, __) => const _ImageError(),
                  ),
                  // Dark gradient for legibility
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0x88000000)],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Bottom caption + dots
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              children: [
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(blurRadius: 6, color: Colors.black54),
                    ],
                  ),
                ).animate().fadeIn(duration: 220.ms).slideY(begin: .2),
                GPSGaps.h8,
                _PageDots(controller: controller, count: images.length),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatefulWidget {
  const _PageDots({required this.controller, required this.count});
  final PageController controller;
  final int count;

  @override
  State<_PageDots> createState() => _PageDotsState();
}

class _PageDotsState extends State<_PageDots> {
  double _page = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    setState(
      () =>
          _page =
              widget.controller.page ??
              widget.controller.initialPage.toDouble(),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.count, (i) {
        final active = (_page).round() == i;
        return AnimatedContainer(
          duration: 200.ms,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 22 : 8,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

// ---------- Tabs + Content (last child) ----------
class _SectionTabs extends StatefulWidget {
  const _SectionTabs();

  @override
  State<_SectionTabs> createState() => _SectionTabsState();
}

class _SectionTabsState extends State<_SectionTabs> {
  final tabs = const [
    'Overview',
    'Kinds',
    'Categories',
    'Benefits',
    'More Info',
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab buttons (simple, no slivers)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GPSColors.cardBorder),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (i) {
                  final selected = _current == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _current = i),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? GPSColors.primary.withOpacity(.10)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                selected
                                    ? GPSColors.primary
                                    : GPSColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          tabs[i],
                          style: txt.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color:
                                selected ? GPSColors.primary : GPSColors.text,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ).animate().fadeIn(duration: 240.ms).slideY(begin: .06),

          GPSGaps.h16,

          // Switched content
          AnimatedSwitcher(
            duration: 260.ms,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _buildTabBody(_current, key: ValueKey(_current)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(int index, {Key? key}) {
    switch (index) {
      case 0:
        return _OverviewSection(key: key);
      case 1:
        return _KindsSection(key: key);
      case 2:
        return _CategoriesSection(key: key);
      case 3:
        return _BenefitsSection(key: key);
      case 4:
      default:
        return _MoreInfoSection(key: key);
    }
  }
}

// ---------- Sections ----------

// Overview
class _OverviewSection extends StatelessWidget {
  const _OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What “Grass-Fed” Means',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h8,
        Text(
          'Grass-fed animals derive the majority of their diet from pasture and forage rather than grain. '
          'This typically produces meat and dairy with a healthier fat profile, richer micronutrients, and flavors shaped by the local landscape.',
          style: txt.bodyMedium?.copyWith(
            color: GPSColors.mutedText,
            height: 1.45,
          ),
        ),
        GPSGaps.h16,
        Text(
          'Key Nutrients',
          style: txt.titleSmall?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h12,
        Column(
          // spacing: 12,
          // runSpacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(width: double.infinity),
            _NutrientCard(
              title: 'Omega-3',
              delta: '▲ higher',
              blurb:
                  'Supports heart & brain health through anti-inflammatory pathways.',
            ),
            _NutrientCard(
              title: 'CLA',
              delta: '▲ higher',
              blurb:
                  'Conjugated linoleic acid linked with improved body composition.',
            ),
            _NutrientCard(
              title: 'Vitamins A/K2',
              delta: 'rich',
              blurb:
                  'Fat-soluble vitamins vital for immunity, bones, and vision.',
            ),
          ],
        ).animate().fadeIn(duration: 260.ms).slideY(begin: .06),
      ],
    );
  }
}

class _NutrientCard extends StatelessWidget {
  const _NutrientCard({
    required this.title,
    required this.delta,
    required this.blurb,
  });
  final String title;
  final String delta;
  final String blurb;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: -6,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: txt.titleSmall?.copyWith(
              color: GPSColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          GPSGaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: GPSColors.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: GPSColors.primary),
            ),
            child: Text(
              delta,
              style: txt.labelMedium?.copyWith(
                color: GPSColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          GPSGaps.h8,
          Text(
            blurb,
            style: txt.bodySmall?.copyWith(
              color: GPSColors.mutedText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Kinds (grid-like wrap of cards)
class _KindsSection extends StatelessWidget {
  const _KindsSection({super.key});

  static final _kinds = [
    (
      'Beef',
      'From pasture-raised cattle; typically leaner with robust, mineral-rich flavor.',
      'https://images.unsplash.com/photo-1526625397487-978d689d30b5?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=874',
    ),
    (
      'Lamb',
      'Grassy, herbal notes reflect seasonal forage; tender with delicate fat.',
      'https://images.unsplash.com/photo-1572095003535-d951bc6e39ce?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    ),
    (
      'Goat',
      'Mild and clean when pasture-raised; excellent in slow braises and grills.',
      'https://images.unsplash.com/photo-1657584278271-6e42be001246?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    ),
    (
      'Bison',
      'Very lean red meat with sweet, iron-rich flavor and quick cooking times.',
      'https://images.unsplash.com/photo-1580504959222-16076146ade6?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=614',
    ),
    (
      'Dairy: Milk',
      'Grass-fed milk often shows seasonal variation in color and creaminess.',
      'https://images.unsplash.com/photo-1523473827533-2a64d0d36748?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=580',
    ),
    (
      'Dairy: Cheese',
      'Raw or low-heat cheeses preserve character from pasture flora and milk.',
      'https://plus.unsplash.com/premium_photo-1682145567707-3387febcc07b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    ),
    (
      'Butter / Ghee',
      'Often richer in carotenoids (golden hue) with deep, nutty aromatics.',
      'https://images.unsplash.com/photo-1573812461383-e5f8b759d12e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870',
    ),
    (
      'Organ Meats',
      'Nutrient-dense (A, B-complex, minerals); best sourced from trusted farms.',
      'https://plus.unsplash.com/premium_photo-1726837319074-238bd31107cf?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=908',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kinds',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h12,
        Column(
          children:
              _kinds.map((k) {
                return _ImageInfoCard(title: k.$1, blurb: k.$2, imageUrl: k.$3)
                    .animate()
                    .fadeIn(duration: 260.ms)
                    .scale(begin: const Offset(.98, .98));
              }).toList(),
        ),
      ],
    );
  }
}

// Categories (filters visual only + list)
class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({super.key});

  static const _filters = [
    'Fresh Cuts',
    'Ground',
    'Organs',
    'Bones/Broth',
    'Dairy',
  ];

  static final _items = [
    (
      'Ribeye (Beef)',
      'Rib primal • High marbling • Tender • Pan-sear or grill.',
      ['Grass-finished', 'Omega-3', 'CLA'],
      'https://images.unsplash.com/photo-1690983321402-35ff91692b56?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=902',
    ),
    (
      'Ground Beef',
      'Versatile for burgers, sauces, and stuffed vegetables; quick to cook.',
      ['Lean options', 'Weeknight-friendly'],
      'https://plus.unsplash.com/premium_photo-1668616816678-5f82734f1f40?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=387',
    ),
    (
      'Bone Broth Bones',
      'Marrow/knuckle bones for slow simmering; mineral-rich stock foundation.',
      ['Collagen', 'Gelatin'],
      'https://images.unsplash.com/photo-1572171579626-e79450374587?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=435',
    ),
    (
      'Grass-Fed Butter',
      'Golden hue indicates carotenoids; ideal for sautéing and finishing.',
      ['Vitamin A', 'Flavor'],
      'https://images.unsplash.com/photo-1724041305788-afe63ae3bb5a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=774',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h12,
        // Visual filters (non-interactive as requested static content)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _filters
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChipStatic(label: f),
                      ),
                    )
                    .toList(),
          ),
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        GPSGaps.h12,

        Column(
          children:
              _items.map((it) {
                return _HorizontalCard(
                      title: it.$1,
                      blurb: it.$2,
                      tags: it.$3,
                      imageUrl: it.$4,
                    )
                    .animate()
                    .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
                    .slideY(begin: .06, curve: Curves.easeOutCubic);
              }).toList(),
        ),
      ],
    );
  }
}

// Benefits (icon cards 2-column)
class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection({super.key});

  static const _benefits = [
    (
      Icons.favorite_rounded,
      'Heart Health',
      'Higher omega-3 and better fat ratios may support cardiovascular markers.',
    ),
    (
      Icons.healing_rounded,
      'Inflammation',
      'Pasture-raised fats often produce a more favorable inflammatory response.',
    ),
    (
      Icons.restaurant_rounded,
      'Flavor & Searing',
      'Clean, well-rendering fat delivers pronounced Maillard browning and aroma.',
    ),
    (
      Icons.eco_rounded,
      'Soil & Biodiversity',
      'Managed grazing can recycle nutrients, build soil, and foster habitats.',
    ),
    (
      Icons.verified_rounded,
      'Animal Welfare',
      'Outdoor movement and grazing reflect more natural behaviors and diets.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h12,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _benefits
                  .map(
                    (b) =>
                        _IconBenefitCard(icon: b.$1, title: b.$2, blurb: b.$3)
                            .animate()
                            .fadeIn(duration: 240.ms)
                            .slideY(begin: .06)
                            .scale(begin: const Offset(.98, .98)),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

// More Info (labels, tips, FAQs, mini image strip)
class _MoreInfoSection extends StatelessWidget {
  const _MoreInfoSection({super.key});

  static final _strip = const [
    'https://images.unsplash.com/photo-1560807707-8cc77767d783?q=80&w=1600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1520072959219-c595dc870360?q=80&w=1600&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1456926631375-92c8ce872def?q=80&w=1600&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Label Guide',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h8,
        const _BulletLine(
          text:
              'Grass-Fed vs Grass-Finished: grass-finished indicates forage to the end of life.',
        ),
        const _BulletLine(
          text:
              'Pasture-Raised: time on pasture; feed may vary; check producer details.',
        ),
        const _BulletLine(
          text:
              'Certifications: look for reputable third-party audits for transparency.',
        ),

        GPSGaps.h16,

        Text(
          'Buying & Storage Tips',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h8,
        const _BulletLine(
          text:
              'Prefer bright color and clean aroma; avoid excessive purge in packaging.',
        ),
        const _BulletLine(
          text:
              'Cook lean cuts slightly gentler; rest adequately for juiciness.',
        ),
        const _BulletLine(
          text:
              'Freeze airtight; thaw in the fridge; label dates for rotation.',
        ),

        GPSGaps.h16,

        Text(
          'Sustainable Farms',
          style: txt.titleMedium?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        GPSGaps.h8,
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemBuilder:
                (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: _strip[i],
                          fit: BoxFit.cover,
                          placeholder:
                              (ctx, _) => _ShimmerBox.rounded(radius: 12),
                          errorWidget: (ctx, _, __) => const _ImageError(),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 220.ms)
                    .scale(begin: const Offset(.98, .98)),
            separatorBuilder: (_, __) => GPSGaps.w10,
            itemCount: _strip.length,
          ),
        ),
      ],
    );
  }
}

// ---------- Small UI Pieces ----------

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
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
            style: txt.labelMedium?.copyWith(
              color: GPSColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipStatic extends StatelessWidget {
  const _FilterChipStatic({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Text(
        label,
        style: txt.labelLarge?.copyWith(
          color: GPSColors.text,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ImageInfoCard extends StatelessWidget {
  const _ImageInfoCard({
    required this.title,
    required this.blurb,
    required this.imageUrl,
  });
  final String title;
  final String blurb;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              spreadRadius: -6,
              offset: Offset(0, 8),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (ctx, _) => _ShimmerBox.rounded(radius: 0),
                  errorWidget: (ctx, _, __) => const _ImageError(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GPSGaps.h6,
                  Text(
                    blurb,
                    style: txt.bodySmall?.copyWith(
                      color: GPSColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalCard extends StatelessWidget {
  const _HorizontalCard({
    required this.title,
    required this.blurb,
    required this.tags,
    required this.imageUrl,
  });
  final String title;
  final String blurb;
  final List<String> tags;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: SizedBox(
              width: 110,
              height: 96,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (ctx, _) => _ShimmerBox.rounded(radius: 0),
                errorWidget: (ctx, _, __) => const _ImageError(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GPSGaps.h4,
                  Text(
                    blurb,
                    style: txt.bodySmall?.copyWith(
                      color: GPSColors.mutedText,
                      height: 1.35,
                    ),
                  ),
                  GPSGaps.h6,
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        tags
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: GPSColors.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: txt.labelMedium?.copyWith(
                                    color: GPSColors.text,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBenefitCard extends StatelessWidget {
  const _IconBenefitCard({
    required this.icon,
    required this.title,
    required this.blurb,
  });
  final IconData icon;
  final String title;
  final String blurb;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: -6,
              offset: Offset(0, 6),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: GPSColors.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GPSColors.primary),
              ),
              child: Icon(icon, color: GPSColors.primary),
            ).animate().scale(begin: const Offset(.92, .92)),
            GPSGaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GPSGaps.h6,
                  Text(
                    blurb,
                    style: txt.bodySmall?.copyWith(
                      color: GPSColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: GPSColors.text)),
          Expanded(
            child: Text(
              text,
              style: txt.bodySmall?.copyWith(
                color: GPSColors.mutedText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            size: 34,
            color: GPSColors.mutedText,
          ),
          GPSGaps.h6,
          Text(
            'Image unavailable',
            style: txt.bodySmall?.copyWith(color: GPSColors.mutedText),
          ),
        ],
      ),
    );
  }
}

// Shimmer placeholder using flutter_animate
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox._({required this.borderRadius});
  factory _ShimmerBox.rounded({double radius = 12}) =>
      _ShimmerBox._(borderRadius: BorderRadius.circular(radius));

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFF1),
            borderRadius: borderRadius,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white)
        .blurXY(begin: 0, end: 0); // keep pipeline; adjustable if desired
  }
}
