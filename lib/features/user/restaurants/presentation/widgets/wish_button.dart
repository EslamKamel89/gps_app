import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_list_create_widget.dart';
import 'package:lottie/lottie.dart';

class WishButton extends StatefulWidget {
  const WishButton({super.key, this.label = 'Ask the Chef', this.isLoading = false});

  final String label;
  final bool isLoading;

  @override
  State<WishButton> createState() => _WishButtonState();
}

class _WishButtonState extends State<WishButton> {
  bool _pressed = false;

  void _tap() {
    if (widget.isLoading) return;
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return WishListCreateWidget();
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
        child: Stack(
          children: [
            Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        GPSColors.primary.withOpacity(0.4),
                        GPSColors.primary.withOpacity(.6),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(.25)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                        GPSGaps.w8,
                        Lottie.asset(
                          'assets/animations/cooking.json',
                          // width: 200,
                          // height: 200,
                          fit: BoxFit.contain,
                        ),

                        GPSGaps.w8,
                        Text(
                          key: const ValueKey('label'),
                          widget.label,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .2,
                          ),
                        ),
                        GPSGaps.w16,
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
                .slideY(begin: .08, curve: Curves.easeOutCubic)
                .shimmer(duration: 2200.ms, delay: 600.ms)
                .then(delay: 2.seconds)
                .scaleXY(begin: 1.0, end: 1.01, duration: 320.ms, curve: Curves.easeInOut)
                .then(delay: 4.seconds),
          ],
        ),
      ),
    );
  }
}
