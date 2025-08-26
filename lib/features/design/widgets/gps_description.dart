import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GpsShortDescription extends StatelessWidget {
  const GpsShortDescription({super.key, this.isSplashScreen = false, this.description});
  final bool isSplashScreen;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Text(
          description ?? 'GPS FOR HEALTH',
          style: TextStyle(
            fontSize: 20,
            color: isSplashScreen ? Colors.white : Color(0xFF154c22),
            letterSpacing: 3.0,
            fontWeight: FontWeight.w700,
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 350.ms)
        .slideY(begin: .2)
        .shimmer(duration: 1200.ms, delay: 900.ms);
  }
}
