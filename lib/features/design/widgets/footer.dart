import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.onSkip, required this.onNext});
  final VoidCallback onSkip;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final nextEnabled = onNext != null;

    return Row(
      children: [
        TextButton(onPressed: onSkip, child: const Text('Skip'))
            .animate()
            .fadeIn(duration: 250.ms)
            .slideX(begin: -.1, curve: Curves.easeOut),
        const Spacer(),
        ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    nextEnabled ? GPSColors.primary : GPSColors.cardBorder,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Next'),
            )
            .animate(target: nextEnabled ? 1 : 0)
            .scaleXY(
              begin: 1.0,
              end: 1.03,
              duration: 300.ms,
              curve: Curves.easeInOut,
            )
            .then(delay: 1200.ms)
            .tint(
              color:
                  nextEnabled
                      ? GPSColors.primary.withOpacity(.05)
                      : Colors.transparent,
              duration: 500.ms,
            ),
      ],
    );
  }
}
