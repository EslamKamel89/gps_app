import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with TickerProviderStateMixin {
  final String _userName = 'Eslam';
  final String _userRank = 'Eco Explorer • Lv 3';

  late final List<Wish> _wishes = [
    Wish(
      id: 'w1',
      text: 'I love vegan pizza',
      status: WishStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      acceptors: [
        Acceptor(
          restaurantId: 'r1',
          restaurantName: 'True Acre',
          rating: 4.6,
          distanceKm: 1.2,
          meal: Meal(
            name: 'Margherita Verde',
            description: 'Cashew mozzarella, fresh basil, heirloom tomatoes',
            price: 9.50,
            dietTags: const ['vegan', 'organic'],
          ),
        ),
        Acceptor(
          restaurantId: 'r2',
          restaurantName: 'Green Bites',
          rating: 4.2,
          distanceKm: 2.4,
          meal: Meal(
            name: 'Forest Pesto Pizza',
            description: 'Kale pesto, artichoke hearts, olives',
            price: 10.90,
            dietTags: const ['vegan', 'nut-free'],
          ),
        ),
        Acceptor(
          restaurantId: 'r3',
          restaurantName: 'Vegano+',
          rating: 4.8,
          distanceKm: 3.1,
          meal: Meal(
            name: 'Truffle Funghi Flatbread',
            description: 'Roasted mushrooms, rocket, truffle drizzle',
            price: 12.40,
            dietTags: const ['vegan', 'specialty'],
          ),
        ),
      ],
    ),
    Wish(
      id: 'w2',
      text: 'Looking for gluten-free falafel wrap',
      status: WishStatus.waiting,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      acceptors: const [],
    ),
    Wish(
      id: 'w3',
      text: 'Cold-pressed green juice nearby',
      status: WishStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      acceptors: [
        Acceptor(
          restaurantId: 'r4',
          restaurantName: 'Leaf & Loom',
          rating: 4.4,
          distanceKm: 0.8,
          meal: Meal(
            name: 'Morning Greens',
            description: 'Kale, spinach, cucumber, apple, ginger',
            price: 5.90,
            dietTags: const ['vegan', 'gluten-free'],
          ),
        ),
      ],
    ),
  ];

  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        backgroundColor: GPSColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: GPSColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GPSColors.cardBorder),
              ),
              child: const Icon(Icons.local_florist_rounded, color: GPSColors.primary, size: 22),
            ).animate().fadeIn(duration: 280.ms).scale(begin: const Offset(.9, .9)),
            GPSGaps.w12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: txt.titleMedium?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _userRank,
                  style: txt.labelMedium?.copyWith(color: GPSColors.mutedText, height: 1.2),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: GPSColors.text),
          ).animate().fadeIn(),
          GPSGaps.w8,
        ],
      ),

      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: _wishes.length,
          separatorBuilder: (_, __) => GPSGaps.h12,
          itemBuilder: (context, index) {
            final wish = _wishes[index];
            final isExpanded = _expanded.contains(wish.id);
            return WishCard(
                  wish: wish,
                  expanded: isExpanded,
                  onToggleExpanded: () {
                    setState(() {
                      if (isExpanded) {
                        _expanded.remove(wish.id);
                      } else {
                        _expanded.add(wish.id);
                      }
                    });
                  },
                  onViewRestaurant: (acceptor) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Open ${acceptor.restaurantName} details'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                )
                .animate(delay: (60 * index).ms)
                .fadeIn(duration: 280.ms, curve: Curves.easeOutCubic)
                .slideY(begin: .08, curve: Curves.easeOutCubic)
                .scale(begin: const Offset(.98, .98));
          },
        ),
      ),
    );
  }
}

enum WishStatus { waiting, accepted }

class Wish {
  final String id;
  final String text;
  final WishStatus status;
  final DateTime createdAt;
  final List<Acceptor> acceptors;

  Wish({
    required this.id,
    required this.text,
    required this.status,
    required this.createdAt,
    required this.acceptors,
  });

  bool get hasMatches => acceptors.isNotEmpty;
}

class Acceptor {
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final double distanceKm;
  final Meal meal;

  Acceptor({
    required this.restaurantId,
    required this.restaurantName,
    required this.rating,
    required this.distanceKm,
    required this.meal,
  });
}

class Meal {
  final String name;
  final String description;
  final double price;
  final List<String> dietTags;

  const Meal({
    required this.name,
    required this.description,
    required this.price,
    required this.dietTags,
  });
}

class WishCard extends StatelessWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onViewRestaurant,
  });

  final Wish wish;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final void Function(Acceptor acceptor) onViewRestaurant;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onToggleExpanded,
      borderRadius: BorderRadius.circular(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LeafBadge(),
                  GPSGaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wish',
                          style: txt.labelMedium?.copyWith(
                            color: GPSColors.mutedText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .2,
                          ),
                        ),
                        GPSGaps.h4,
                        Text(
                          '“${wish.text}”',
                          style: txt.titleMedium?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GPSGaps.w8,
                  _StatusPill(status: wish.status, count: wish.acceptors.length),
                ],
              ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

              GPSGaps.h12,

              if (wish.status == WishStatus.accepted)
                _AcceptedPreviewRow(acceptors: wish.acceptors),

              if (wish.status == WishStatus.waiting)
                _WaitingTip().animate().fadeIn(duration: 220.ms).slideY(begin: .06),

              GPSGaps.h12,
              _PrimaryActionRow(
                expanded: expanded,
                isAccepted: wish.status == WishStatus.accepted,
                onPressed: onToggleExpanded,
              ),

              AnimatedSwitcher(
                duration: 260.ms,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder:
                    (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: anim.drive(Tween(begin: const Offset(0, .06), end: Offset.zero)),
                        child: child,
                      ),
                    ),
                child:
                    expanded
                        ? Column(
                          key: const ValueKey('expanded'),
                          children: [
                            GPSGaps.h12,
                            if (wish.status == WishStatus.accepted)
                              _AcceptorsList(
                                acceptors: wish.acceptors,
                                onViewRestaurant: onViewRestaurant,
                              )
                            else
                              _WaitingSuggestions(),
                          ],
                        )
                        : const SizedBox.shrink(key: ValueKey('collapsed')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeafBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: GPSColors.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: const Icon(Icons.eco_rounded, color: GPSColors.primary, size: 20),
    ).animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96));
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.count});
  final WishStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final bool accepted = status == WishStatus.accepted;
    final Color bg = accepted ? GPSColors.primary.withOpacity(.12) : const Color(0xFFECEFF1);
    final Color fg = accepted ? GPSColors.primary : GPSColors.mutedText;

    final String label = accepted ? 'Accepted by $count' : 'Waiting';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            accepted ? Icons.check_circle_rounded : Icons.hourglass_bottom_rounded,
            size: 16,
            color: fg,
          ),
          GPSGaps.w8,
          Text(label, style: txt.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w800)),
        ],
      ),
    ).animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96));
  }
}

class _AcceptedPreviewRow extends StatelessWidget {
  const _AcceptedPreviewRow({required this.acceptors});
  final List<Acceptor> acceptors;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final preview = acceptors.take(3).toList();
    final remaining = acceptors.length - preview.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in preview) _MiniRestaurantChip(name: a.restaurantName),
            if (remaining > 0) _MiniRestaurantChip(name: '+$remaining more'),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
        GPSGaps.h8,
        Text(
          'Matched restaurants can satisfy this wish with specific menu items.',
          style: txt.bodySmall?.copyWith(color: GPSColors.mutedText),
        ),
      ],
    );
  }
}

class _MiniRestaurantChip extends StatelessWidget {
  const _MiniRestaurantChip({required this.name});
  final String name;

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
          const Icon(Icons.storefront_rounded, size: 16, color: GPSColors.primary),
          GPSGaps.w8,
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _WaitingTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: GPSColors.mutedText, size: 18),
          GPSGaps.w8,
          Expanded(
            child: Text(
              'We’ll notify you when a restaurant accepts your wish.',
              style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionRow extends StatelessWidget {
  const _PrimaryActionRow({
    required this.expanded,
    required this.isAccepted,
    required this.onPressed,
  });

  final bool expanded;
  final bool isAccepted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label =
        expanded
            ? 'Collapse'
            : isAccepted
            ? 'View matches'
            : 'More details';

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: GPSColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          icon: Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(.98, .98)),
        GPSGaps.w12,
        if (!isAccepted)
          OutlinedButton.icon(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: GPSColors.text,
              side: const BorderSide(color: GPSColors.cardBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Improve wish', style: TextStyle(fontWeight: FontWeight.w700)),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
      ],
    );
  }
}

class _AcceptorsList extends StatelessWidget {
  const _AcceptorsList({required this.acceptors, required this.onViewRestaurant});

  final List<Acceptor> acceptors;
  final void Function(Acceptor acceptor) onViewRestaurant;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: acceptors.length,
      separatorBuilder: (_, __) => GPSGaps.h8,
      itemBuilder: (context, i) {
        final a = acceptors[i];
        return _AcceptorRow(acceptor: a, onTap: () => onViewRestaurant(a))
            .animate(delay: (60 * i).ms)
            .fadeIn(duration: 240.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .06, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98));
      },
    );
  }
}

class _AcceptorRow extends StatelessWidget {
  const _AcceptorRow({required this.acceptor, required this.onTap});
  final Acceptor acceptor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LogoBox().animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96)),
            GPSGaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          acceptor.restaurantName,
                          style: txt.titleSmall?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StarRow(rating: acceptor.rating, size: 16),
                      GPSGaps.w8,
                      Text(
                        '${acceptor.distanceKm.toStringAsFixed(1)} km',
                        style: txt.labelMedium?.copyWith(color: GPSColors.mutedText),
                      ),
                    ],
                  ),
                  GPSGaps.h8,

                  Text(
                    acceptor.meal.name,
                    style: txt.bodyMedium?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GPSGaps.h6,
                  Text(
                    acceptor.meal.description,
                    style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GPSGaps.h6,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in acceptor.meal.dietTags) _TagChip(label: t),
                      _PriceTag(price: acceptor.meal.price),
                    ],
                  ),
                ],
              ),
            ),
            GPSGaps.w8,
            const Icon(Icons.chevron_right_rounded, color: GPSColors.mutedText),
          ],
        ),
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: GPSColors.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: const Icon(Icons.storefront_rounded, color: GPSColors.primary, size: 22),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: GPSColors.primary.withOpacity(.10),
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: txt.labelMedium?.copyWith(color: GPSColors.primary, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, this.size = 18});
  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
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
      return Icon(icon, size: size, color: const Color(0xFFFFC107));
    });
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

class _WaitingSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: GPSColors.mutedText, size: 20),
              GPSGaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No matches yet',
                      style: txt.titleSmall?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GPSGaps.h6,
                    Text(
                      'Try refining your wish so restaurants can match it faster.',
                      style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
                    ),
                    GPSGaps.h10,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SuggestionBullet(
                          icon: Icons.place_outlined,
                          text: 'Add a location hint (e.g., “near Zamalek”).',
                        ),
                        _SuggestionBullet(
                          icon: Icons.schedule_outlined,
                          text: 'Add timing (e.g., “tonight” or “lunch”).',
                        ),
                        _SuggestionBullet(
                          icon: Icons.sell_outlined,
                          text: 'Add dietary tags (vegan, gluten-free, organic).',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        GPSGaps.h12,

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SuggestionChip(icon: Icons.place_outlined, label: 'Add location', onTap: () {}),
            _SuggestionChip(icon: Icons.schedule_outlined, label: 'Add time', onTap: () {}),
            _SuggestionChip(icon: Icons.sell_outlined, label: 'Add tags', onTap: () {}),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
      ],
    );
  }
}

class _SuggestionBullet extends StatelessWidget {
  const _SuggestionBullet({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: GPSColors.mutedText),
          GPSGaps.w8,
          Expanded(
            child: Text(
              text,
              style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: GPSColors.text,
        side: const BorderSide(color: GPSColors.cardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
