import 'package:flutter/material.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

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
      backgroundColor: GPSColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PinLeafLogo(size: 140, isSplashScreen: true),
              GPSGaps.h24,
              GpsShortDescription(isSplashScreen: true),
              GPSGaps.h24,
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const _BottomSwipeHint(),
    );
  }
}
