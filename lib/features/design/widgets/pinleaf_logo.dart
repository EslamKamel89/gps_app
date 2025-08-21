import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/utils/assets/assets.dart';

class PinLeafLogo extends StatelessWidget {
  const PinLeafLogo({super.key, required this.size, this.isSplashScreen = false});
  final double size;
  final bool isSplashScreen;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
          isSplashScreen ? AssetsData.logoLarge3d : AssetsData.logo,
          width: size,
          height: size,
        )
        .animate()
        .fadeIn(duration: 550.ms)
        .scale(begin: const Offset(.85, .85), end: Offset(1, 1), curve: Curves.easeOutBack)
        .then()
        .shake(hz: 1.5, duration: 350.ms);
  }
}
