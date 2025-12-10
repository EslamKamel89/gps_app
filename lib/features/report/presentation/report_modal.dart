import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

Future<void>? showReportAcknowledgementModal({bool isBlock = false}) {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) return null;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Center(
        child: Animate(
          effects: [
            FadeEffect(duration: 260.ms),
            ScaleEffect(begin: Offset(0.96, 0.96), end: Offset(1.0, 1.0), duration: 260.ms),
          ],
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            backgroundColor: Colors.white,
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GPSColors.cardSelected,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.check_circle_outline, size: 36, color: GPSColors.primary),
                    ),

                    GPSGaps.h12,

                    Text(
                      isBlock
                          ? 'Thanks — we’ve blocked the user and received your report'
                          : 'Thanks — we’ve received your report',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),

                    GPSGaps.h8,

                    Text(
                      'Our moderation team will review your report and take appropriate action. '
                      'We aim to respond within 24 hours. Thank you for helping keep the community safe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: GPSColors.mutedText, height: 1.4),
                    ),

                    GPSGaps.h16,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 14, color: GPSColors.accent),
                        GPSGaps.w8,
                        Text(
                          'You can always reach support from the Help section.',
                          style: TextStyle(fontSize: 12, color: GPSColors.mutedText),
                        ),
                      ],
                    ),

                    GPSGaps.h16,

                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text(
                              'Close',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GPSGaps.w12,
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GPSColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              'Okay, thanks',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
