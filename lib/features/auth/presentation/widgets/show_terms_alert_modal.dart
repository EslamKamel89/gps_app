import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

Future<void>? showTermsAlertModal() {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) return null;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Center(
        child: Animate(
          effects: [
            FadeEffect(duration: 250.ms),
            ScaleEffect(begin: Offset(0.94, 0.94), end: Offset(1.0, 1.0), duration: 250.ms),
          ],
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GPSColors.cardSelected,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.security, size: 34, color: GPSColors.primary),
                  ),

                  GPSGaps.h12,

                  // Title
                  const Text(
                    'Important Safety Notice',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),

                  GPSGaps.h12,

                  // Body text (EXACT as you provided)
                  const Text(
                    'By using this app you agree to our Terms of Service and Community Guidelines. '
                    'You may not post content that is illegal, hateful, sexually explicit, harassing, or otherwise abusive. '
                    'We have zero tolerance for objectionable content — content that violates these terms may be removed and '
                    'offending accounts may be suspended or banned. You can report content using the in-app Flag button. '
                    'We will review reports and take action within 24 hours. Repeated violations may lead to permanent account suspension.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.4, color: GPSColors.mutedText),
                  ),

                  GPSGaps.h20,

                  // OK button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GPSColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
