import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutLoadingState extends StatelessWidget {
  const AboutLoadingState({super.key});

  Widget _shimmer(Widget child) {
    return child.animate().shimmer(duration: 1200.ms, color: Colors.white);
  }

  Widget _line({required double widthFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 14,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBorder = Color(0xFFE1D9CC);
    const cardSelected = Color(0xFFCAE1D8);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(height: 200, width: double.infinity, color: cardSelected),
            ),
          ),

          const SizedBox(height: 16),

          _shimmer(
            Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cardBorder),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmer(_line(widthFactor: 1.0)),
              const SizedBox(height: 8),
              _shimmer(_line(widthFactor: 0.92)),
              const SizedBox(height: 8),
              _shimmer(_line(widthFactor: 0.86)),
              const SizedBox(height: 8),
              _shimmer(_line(widthFactor: 0.6)),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _shimmer(
                Container(
                  height: 44,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cardBorder),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _shimmer(
                Container(
                  height: 44,
                  width: 96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cardBorder),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: _shimmer(
              Container(
                height: 12,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
