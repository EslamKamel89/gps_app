import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BlogCardSkeleton extends StatelessWidget {
  final double height;

  const BlogCardSkeleton({super.key, this.height = 300});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with shimmer
          Container(
            height: height * 0.5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[200]!,
                          Colors.grey[300]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Shimmer effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment(-1.0, -1.0),
                        end: Alignment(1.0, 1.0),
                      ),
                    ),
                  ).animate().slide(
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(1.0, 0.0),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                Container(
                      height: 24,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[300],
                      ),
                    )
                    .animate()
                    .fade(duration: 500.ms)
                    .then()
                    .slide(
                      duration: 800.ms,
                      curve: Curves.easeOut,
                      begin: const Offset(-0.2, 0),
                      end: Offset.zero,
                    ),

                const SizedBox(height: 8),

                // Subtitle placeholder
                Container(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[300],
                      ),
                    )
                    .animate()
                    .fade(duration: 600.ms)
                    .then()
                    .slide(
                      duration: 900.ms,
                      curve: Curves.easeOut,
                      begin: const Offset(-0.2, 0),
                      end: Offset.zero,
                    ),

                const SizedBox(height: 16),

                // Action buttons row
                Row(
                  children: [
                    // Like button placeholder
                    Container(
                          height: 32,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                        )
                        .animate()
                        .fade(duration: 700.ms)
                        .then()
                        .slide(
                          duration: 1000.ms,
                          curve: Curves.easeOut,
                          begin: const Offset(-0.2, 0),
                          end: Offset.zero,
                        ),

                    const SizedBox(width: 8),

                    // Comment button placeholder
                    Container(
                          height: 32,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                        )
                        .animate()
                        .fade(duration: 800.ms)
                        .then()
                        .slide(
                          duration: 1100.ms,
                          curve: Curves.easeOut,
                          begin: const Offset(-0.2, 0),
                          end: Offset.zero,
                        ),

                    const SizedBox(width: 8),

                    // Image button placeholder
                    Container(
                          height: 32,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[300],
                          ),
                        )
                        .animate()
                        .fade(duration: 900.ms)
                        .then()
                        .slide(
                          duration: 1200.ms,
                          curve: Curves.easeOut,
                          begin: const Offset(-0.2, 0),
                          end: Offset.zero,
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BlogListLoadingState extends StatelessWidget {
  final int itemCount;

  const BlogListLoadingState({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return BlogCardSkeleton()
            .animate()
            .fadeIn(duration: 300.ms)
            .slide(
              duration: 500.ms,
              curve: Curves.easeOut,
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            )
            .then()
            .scale(
              duration: 400.ms,
              curve: Curves.easeOut,
              begin: Offset(0.95, 0.95),
              end: Offset(1.0, 1.0),
            );
      },
    );
  }
}
