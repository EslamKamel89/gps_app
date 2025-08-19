import 'package:flutter/material.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';
import 'package:gps_app/features/wireframe/widgets/gps_description.dart';
import 'package:gps_app/features/wireframe/widgets/pinleaf_logo.dart';

class GPSSplashScreen extends StatefulWidget {
  const GPSSplashScreen({super.key});

  @override
  State<GPSSplashScreen> createState() => _GPSSplashScreenState();
}

class _GPSSplashScreenState extends State<GPSSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.loginScreen, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.primary.withValues(alpha: 1.2),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PinLeafLogo(size: 140),
              GPSGaps.h24,
              GpsShortDescription(),
              GPSGaps.h24,
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const _BottomSwipeHint(),
    );
  }
}
