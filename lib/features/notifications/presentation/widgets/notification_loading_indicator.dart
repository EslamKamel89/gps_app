import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class NotificationsLoadingIndicator extends StatelessWidget {
  const NotificationsLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Simulate 5 notifications loading
      itemBuilder: (context, index) {
        return ShimmerNotificationItem().animate().fadeIn(duration: 300.ms); // Staggered entrance
      },
    );
  }
}

class ShimmerNotificationItem extends StatelessWidget {
  const ShimmerNotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simulated dot indicator (for unread) – will shimmer
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmering content line
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: GPSColors.background.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Shimmering time line (shorter)
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: GPSColors.background.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(
          onPlay: (controller) => controller.repeat(), // Loop shimmer
        )
        .shimmer(
          duration: 1.2.seconds,
          color: GPSColors.primary.withOpacity(0.1),
          // backgroundColor: GPSColors.background.withOpacity(0.8),
        );
  }
}
