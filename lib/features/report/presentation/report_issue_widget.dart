import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/report/presentation/report_bottom_sheet.dart';

class ReportIssueWidget extends StatefulWidget {
  const ReportIssueWidget({super.key, required this.typeId, required this.type});
  final int typeId;
  final String type;
  @override
  State<ReportIssueWidget> createState() => _ReportIssueWidgetState();
}

class _ReportIssueWidgetState extends State<ReportIssueWidget> {
  bool _startHide = false;
  bool _removeText = false;

  static const Duration waitBeforeHide = Duration(seconds: 2);
  static const Duration fadeDuration = Duration(milliseconds: 400);
  static const Duration slideDuration = Duration(milliseconds: 400);

  Timer? _hideTimer;
  Timer? _removeTimer;

  @override
  void initState() {
    super.initState();

    _hideTimer = Timer(waitBeforeHide, () {
      if (!mounted) return;
      setState(() => _startHide = true);

      _removeTimer = Timer(fadeDuration, () {
        if (!mounted) return;
        setState(() => _removeText = true);
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _removeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openReportBottomSheet(context, typeId: widget.typeId, type: widget.type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: GPSColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.report, color: GPSColors.warning, size: 20),

            if (!_removeText) GPSGaps.w8,

            if (!_removeText)
              Builder(
                builder: (context) {
                  final textWidget = Text(
                    'Report an issue',
                    style: const TextStyle(
                      color: GPSColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  );

                  if (!_startHide) {
                    return textWidget.animate().fadeIn(duration: 180.ms);
                  } else {
                    return textWidget
                        .animate()
                        .fadeOut(duration: fadeDuration)
                        .slideX(end: -0.25, duration: slideDuration);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
