import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

Future<int?> showActionSheet(
  BuildContext context, {
  String? title,
  required List<Widget> children,
}) {
  assert(children.isNotEmpty, 'children must not be empty');

  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: false,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (ctx) {
      final media = MediaQuery.of(ctx);

      final sheet = Container(
            constraints: BoxConstraints(maxHeight: media.size.height * 0.7),
            decoration: BoxDecoration(
              color: GPSColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: const Border(top: BorderSide(color: GPSColors.cardBorder)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GPSGaps.h8,

                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: GPSColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ).animate().fadeIn(duration: 180.ms).slideY(begin: .15),

                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              color: GPSColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          icon: const Icon(Icons.close_rounded, color: GPSColors.mutedText),
                          onPressed: () => Navigator.of(ctx).pop(null),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 220.ms).slideY(begin: .10),
                  const Divider(height: 1, color: GPSColors.cardBorder),
                ],

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(children.length, (i) {
                        final child = children[i];

                        final tappable = Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.of(ctx).pop(i),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: child,
                            ),
                          ),
                        );

                        return Padding(
                          padding: EdgeInsets.only(bottom: i == children.length - 1 ? 0 : 10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: GPSColors.cardBorder),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: -4,
                                  offset: Offset(0, 6),
                                  color: Color(0x14000000),
                                ),
                              ],
                            ),
                            child: tappable
                                .animate(delay: (60 * i).ms)
                                .fadeIn(duration: 220.ms, curve: Curves.easeOutCubic)
                                .slideY(begin: .08, curve: Curves.easeOutCubic)
                                .scale(begin: const Offset(.98, .98), end: const Offset(1, 1)),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 180.ms, curve: Curves.easeOutCubic)
          .slideY(begin: .12, curve: Curves.easeOutCubic);

      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0), child: sheet),
      );
    },
  );
}
