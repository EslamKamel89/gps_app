import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ScanImageButton extends StatelessWidget {
  const ScanImageButton({super.key, required this.loading});
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: GPSColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                        .animate()
                        .fade(duration: 200.ms, curve: Curves.easeOut)
                        .scale(begin: Offset(0.95, 0.95), end: Offset(1.0, 1.0))
                        .then()
                        .shimmer(
                          color: Colors.white.withOpacity(0.18),
                          duration: 1200.ms,
                        ),

                    GPSGaps.w8,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                              width: 110,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            )
                            .animate()
                            .fade(duration: 200.ms)
                            .shimmer(
                              color: Colors.white.withOpacity(0.18),
                              duration: 1200.ms,
                            ),

                        const SizedBox(height: 6),

                        Container(
                              width: 70,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            )
                            .animate()
                            .fade(duration: 200.ms, delay: 100.ms)
                            .shimmer(
                              color: Colors.white.withOpacity(0.16),
                              duration: 1200.ms,
                            ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.camera_enhance_rounded,
                        color: GPSColors.cardBorder,
                      ).animate().scale(
                        begin: Offset(0.95, 0.95),
                        end: Offset(1.0, 1.0),
                        duration: 220.ms,
                        curve: Curves.easeOut,
                      ),
                    ),
                    GPSGaps.w8,
                    const Text(
                      'Scan a product',
                      style: TextStyle(color: Colors.white),
                    ).animate().fadeIn(duration: 250.ms),
                  ],
                ),
            ],
          ),
        )
        .animate()
        .fade(duration: 250.ms)
        .moveY(begin: 6, end: 0, duration: 300.ms);
  }
}
