import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_accept_widget.dart';

class WishAcceptButton extends StatefulWidget {
  const WishAcceptButton({super.key, required this.wishListId});
  final int wishListId;
  @override
  State<WishAcceptButton> createState() => _WishAcceptButtonState();
}

class _WishAcceptButtonState extends State<WishAcceptButton> {
  bool _pressed = false;

  void _tap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return WishListAcceptWidget(wishListId: widget.wishListId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: 120.ms,
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: _tap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: _AcceptOfferButton(onPressed: _tap),
      ),
    );
  }
}

class _AcceptOfferButton extends StatelessWidget {
  const _AcceptOfferButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.white,
    );

    final btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
        backgroundColor: GPSColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, size: 20),
          GPSGaps.w8,
          Text('Bring This Wish to Life', style: textStyle),
        ],
      ),
    );

    return btn
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(begin: .04, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 180.ms);
  }
}
