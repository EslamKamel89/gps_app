import 'package:flutter/material.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class AuthRequiredScreen extends StatefulWidget {
  const AuthRequiredScreen({super.key, required this.currentTab});
  final int currentTab;

  @override
  State<AuthRequiredScreen> createState() => _AuthRequiredScreenState();
}

class _AuthRequiredScreenState extends State<AuthRequiredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GPSGaps.h24,

              // Top icon
              Container(
                decoration: BoxDecoration(
                  color: GPSColors.cardSelected,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.lock_outline,
                  size: 42,
                  color: GPSColors.primary,
                ),
              ),

              GPSGaps.h24,

              // Title
              Text(
                'You’re almost there!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GPSColors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              GPSGaps.h12,

              // Description
              Text(
                'Please sign in or create an account to continue. '
                'It only takes a minute and keeps your progress safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GPSColors.mutedText,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              GPSGaps.h24,
              const Spacer(),

              // Buttons
              Column(
                children: [
                  // Create Account
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.registerScreen);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: GPSColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  GPSGaps.h12,

                  // Sign In
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.loginScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GPSColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              GPSGaps.h24,
            ],
          ),
        ),
      ),
      bottomNavigationBar: GPSBottomNav(
        currentIndex: widget.currentTab,
        onChanged: (i) {},
      ),
    );
  }
}
