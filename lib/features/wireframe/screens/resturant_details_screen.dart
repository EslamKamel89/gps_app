import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: NestedScrollView(
        headerSliverBuilder:
            (context, inner) => [
              SliverAppBar(
                backgroundColor: GPSColors.primary,
                expandedHeight: 260,
                pinned: true,
                elevation: 0,
                leading: _CircleBack(onTap: () => Navigator.of(context).maybePop()),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
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
                      // gradient overlay for readability
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
            ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card-like top sheet
              Container(
                decoration: const BoxDecoration(
                  color: GPSColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
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

                      const _SectionHeader(title: 'About'),
                      GPSGaps.h8,
                      Text(
                        '100% grass-fed burgers and more, locally sourced',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.4),
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),

                      GPSGaps.h20,

                      const _SectionHeader(title: 'Menu'),
                      GPSGaps.h12,
                      const _MenuItemRow(name: 'Raw Cheese', price: 8.89),
                      const Divider(height: 1, color: GPSColors.cardBorder),
                      const _MenuItemRow(name: 'Spring Water', price: 2.00),

                      GPSGaps.h24,

                      _AddToFavoritesRow(
                        isFav: _isFav,
                        onChanged: (v) => setState(() => _isFav = v),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({required this.name, required this.price});
  final String name;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: GPSColors.text,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 240.ms).slideX(begin: .05);
  }
}

class _AddToFavoritesRow extends StatelessWidget {
  const _AddToFavoritesRow({required this.isFav, required this.onChanged});
  final bool isFav;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isFav),
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : GPSColors.primary,
            ),
            GPSGaps.w12,
            Expanded(
              child: Text(
                'Add to Favorites',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: .06);
  }
}
