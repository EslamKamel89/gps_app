import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: GPSColors.primary,
              borderRadius: BorderRadius.circular(18),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?q=80&w=1200&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 16,
                  right: 16,
                  child: Text(
                    'Earn Points with Verified Restaurants',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: GPSColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Learn more'),
                  ).animate().fadeIn(duration: 250.ms).slideX(begin: -.1),
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 350.ms)
          .slideY(begin: .1)
          .shimmer(delay: 1200.ms, duration: 1200.ms),
    );
  }
}
