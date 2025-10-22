import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/wish_accept_button.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/acceptor_model.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/wish_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/acceptors_list.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/category_preview_row.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/primary_action_row.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/status_bill.dart';

class WishCard extends StatelessWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onViewRestaurant,
  });

  final WishModel wish;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final void Function(AcceptorModel acceptor) onViewRestaurant;

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
                  LeafBadge(),
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
                          '“${wish.description}”',
                          style: txt.titleMedium?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GPSGaps.w8,
                  StatusPill(status: wish.status ?? 0, count: wish.acceptors?.length ?? 0),
                ],
              ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

              if (wish.id != null) GPSGaps.h12,
              if (wish.id != null) WishAcceptButton(wishListId: wish.id!),
              GPSGaps.h12,
              if (![wish.category, wish.subcategory].contains(null))
                CategoryPreviewRow(category: wish.category!, subCategory: wish.subcategory!),

              GPSGaps.h12,
              if (wish.acceptors?.isNotEmpty == true)
                PrimaryActionRow(
                  expanded: expanded,
                  isAccepted: wish.status == 1,
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
                            if (wish.status == 1)
                              AcceptorsList(
                                acceptors: wish.acceptors ?? [],
                                onViewRestaurant: onViewRestaurant,
                              )
                            else
                              SizedBox(),
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

class WishCardSkeleton extends StatelessWidget {
  const WishCardSkeleton({super.key});

  static const _bg = Color(0xFFF6F6F6);
  static const _border = Color(0xFFE6E6E6);
  static const _pill = Color(0xFFECECEC);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Container(
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: radius,
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _circle(32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bar(width: 60, height: 10),
                        const SizedBox(height: 6),
                        _bar(width: 180, height: 14),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _pillBox(width: 110, height: 22, radius: 999),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(spacing: 8, runSpacing: 8, children: [_chip(), _chip(), _chip(width: 72)]),
              const SizedBox(height: 12),

              _bar(width: 240, height: 12),
              const SizedBox(height: 14),

              _pillBox(width: 140, height: 40, radius: 10),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,

          colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
        );
  }

  Widget _pillBox({required double width, required double height, double radius = 8}) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: _pill, borderRadius: BorderRadius.circular(radius)),
  );

  Widget _bar({required double width, double height = 12}) =>
      _pillBox(width: width, height: height, radius: 6);

  Widget _circle(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(color: _pill, shape: BoxShape.circle),
  );

  Widget _chip({double width = 64}) => _pillBox(width: width, height: 28, radius: 999);
}
