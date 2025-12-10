import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/report/presentation/block_bottom_sheet.dart';

class BlockUserWidget extends StatefulWidget {
  const BlockUserWidget({super.key, required this.blockUserId});
  final int blockUserId;
  @override
  State<BlockUserWidget> createState() => _BlockUserWidgetState();
}

class _BlockUserWidgetState extends State<BlockUserWidget> {
  bool _startHide = false;
  bool _removeText = false;

  static const Duration waitBeforeHide = Duration(seconds: 5);
  static const Duration fadeDuration = Duration(milliseconds: 1000);
  static const Duration slideDuration = Duration(milliseconds: 1000);

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
        openBlockBottomSheet(context, blockUserId: widget.blockUserId);
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
            Icon(Icons.block, color: Colors.red, size: 20),

            if (!_removeText) GPSGaps.w8,

            if (!_removeText)
              Builder(
                builder: (context) {
                  final textWidget = Text(
                    'Block User',
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
