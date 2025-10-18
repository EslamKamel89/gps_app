import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/entities/acceptor_entity.dart';
import 'package:gps_app/features/wishlist/entities/wish_entity.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/accepted_preview_row.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/acceptors_list.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/primary_action_row.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/status_bill.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/waiting_suggestions.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wating_tip.dart';
import 'package:gps_app/features/wishlist/presentation/wishlist_screen.dart';

class WishCard extends StatelessWidget {
  const WishCard({
    super.key,
    required this.wish,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onViewRestaurant,
  });

  final WishEntity wish;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final void Function(AcceptorEntity acceptor) onViewRestaurant;

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
                  StatusPill(status: wish.status, count: wish.acceptors.length),
                ],
              ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

              GPSGaps.h12,

              if (wish.status == WishStatus.accepted) AcceptedPreviewRow(acceptors: wish.acceptors),

              if (wish.status == WishStatus.waiting)
                WaitingTip().animate().fadeIn(duration: 220.ms).slideY(begin: .06),

              GPSGaps.h12,
              PrimaryActionRow(
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
                              AcceptorsList(
                                acceptors: wish.acceptors,
                                onViewRestaurant: onViewRestaurant,
                              )
                            else
                              WaitingSuggestions(),
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
