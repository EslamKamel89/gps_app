import 'package:flutter/material.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

Future<void> showAuthRequiredDialog() async {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) return;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: GPSColors.cardSelected,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.lock_outline,
                  size: 28,
                  color: GPSColors.primary,
                ),
              ),

              GPSGaps.h16,

              Text(
                'You’re almost there!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GPSColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              GPSGaps.h8,

              Text(
                'Please sign in or create an account to continue. '
                'It only takes a minute and keeps your progress safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GPSColors.mutedText,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              GPSGaps.h20,

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(
                          ctx,
                        ).pushNamed(AppRoutesNames.registerScreen);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: GPSColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GPSGaps.w12,

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pushNamed(AppRoutesNames.loginScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GPSColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
