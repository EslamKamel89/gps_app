import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_list_create_widget.dart';

class WishCreateScreen extends StatefulWidget {
  const WishCreateScreen({super.key});

  @override
  State<WishCreateScreen> createState() => _WishCreateScreenState();
}

class _WishCreateScreenState extends State<WishCreateScreen>
    with TickerProviderStateMixin {
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
            const LeafBadge()
                .animate()
                .fadeIn(duration: 220.ms)
                .scale(begin: const Offset(.96, .96)),
            GPSGaps.w12,
            Text(
              'New Wish',
              style: txt.titleMedium?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: WishListCreateWidget()),
    );
  }
}
