import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class TodayHoursRow extends StatelessWidget {
  const TodayHoursRow({super.key, required this.operating});

  final OperatingTimeModel operating;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final now = DateTime.now();
    final key =
        <int, String>{
          1: 'mon',
          2: 'tue',
          3: 'wed',
          4: 'thu',
          5: 'fri',
          6: 'sat',
          7: 'sun',
        }[now.weekday]!;

    List<String>? slot;
    switch (key) {
      case 'mon':
        slot = operating.mon;
        break;
      case 'tue':
        slot = operating.tue;
        break;
      case 'wed':
        slot = operating.wed;
        break;
      case 'thu':
        slot = operating.thu;
        break;
      case 'fri':
        slot = operating.fri;
        break;
      case 'sat':
        slot = operating.sat;
        break;
      case 'sun':
        slot = operating.sun;
        break;
    }

    final text =
        (slot == null || slot.length < 2)
            ? 'Hours unavailable'
            : 'Today: ${slot[0]} – ${slot[1]}';

    final bool available = !(slot == null || slot.length < 2);

    return Semantics(
      label: 'Today opening hours',
      value: text,
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GPSColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: -6,
                  offset: Offset(0, 8),
                  color: Color(0x14000000),
                ),
              ],
              // subtle surface with accent whisper, same idea as ContactCard
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, GPSColors.accent.withOpacity(.06)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: GPSColors.accent.withOpacity(.6),
                          ),
                        ),
                        child: Icon(
                          Icons.access_time_filled_rounded,
                          size: 18,
                          color:
                              available
                                  ? GPSColors.primary
                                  : GPSColors.mutedText,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 200.ms)
                      .scale(begin: const Offset(.96, .96))
                      .shimmer(delay: 80.ms, duration: 1000.ms),

                  GPSGaps.w12,

                  // Text
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: txt.bodyMedium?.copyWith(
                        color: available ? GPSColors.text : GPSColors.mutedText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 220.ms, curve: Curves.easeOutCubic)
          .slideY(begin: .06, curve: Curves.easeOutCubic),
    );
  }
}
