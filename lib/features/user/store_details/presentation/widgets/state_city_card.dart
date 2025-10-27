import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StateCityCard extends StatelessWidget {
  const StateCityCard({
    super.key,
    required this.state,
    required this.district,
    this.title = 'Location',
  });

  final StateModel state;
  final DistrictModel district;
  final String title;

  bool get _hasState => (state.name?.trim().isNotEmpty ?? false);
  bool get _hasCity => (district.name?.trim().isNotEmpty ?? false);
  bool get _hasAny => _hasState || _hasCity;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final rows = <Widget>[];
    var order = 0;

    if (_hasState) {
      rows.add(
        _InfoRow(
          icon: Icons.map_rounded,
          label: 'State',
          value: state.name!.trim(),
          order: order++,
          iconColor: GPSColors.primary,
          accentColor: GPSColors.accent,
        ),
      );
    }
    if (_hasCity) {
      rows.add(
        _InfoRow(
          icon: Icons.location_city_rounded,
          label: 'City',
          value: district.name!.trim(),
          order: order++,
          iconColor: GPSColors.primary,
          accentColor: GPSColors.accent,
        ),
      );
    }

    return Semantics(
      label: 'State and City card',
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: GPSColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: -6,
                  offset: Offset(0, 8),
                  color: Color(0x14000000),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, GPSColors.accent.withOpacity(.06)],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [GPSColors.primary, GPSColors.accent],
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.place_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                GPSGaps.w8,
                                Text(
                                  title,
                                  style: txt.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 220.ms)
                          .slideY(begin: .08, curve: Curves.easeOutCubic)
                          .scale(begin: const Offset(.95, .95)),

                      GPSGaps.h8,

                      if (_hasAny)
                        ..._intersperse(
                          rows,
                          Divider(
                            height: 12,
                            thickness: 1,
                            color: GPSColors.cardBorder,
                          ).animate().fadeIn(duration: 180.ms),
                        )
                      else
                        _EmptyState(
                          message: 'No location info available.',
                          textStyle: txt.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
          .slideY(begin: .05, curve: Curves.easeOutCubic),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.order,
    required this.iconColor,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final int order;
  final Color iconColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withOpacity(.6)),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              )
              .animate()
              .fadeIn(duration: 200.ms)
              .scale(begin: const Offset(.96, .96))
              .shimmer(delay: 100.ms * order, duration: 1000.ms),

          GPSGaps.w12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: txt.labelSmall?.copyWith(
                    color: GPSColors.mutedText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: txt.bodyMedium?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: '$label: $value',
      child: row
          .animate(delay: (60 * order).ms)
          .fadeIn(duration: 220.ms, curve: Curves.easeOutCubic)
          .slideY(begin: .06, curve: Curves.easeOutCubic),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.textStyle});
  final String message;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: GPSColors.accent, size: 18),
          GPSGaps.w8,
          Expanded(
            child: Text(
              message,
              style: textStyle?.copyWith(color: GPSColors.mutedText),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: .05);
  }
}

List<Widget> _intersperse(List<Widget> items, Widget separator) {
  if (items.isEmpty) return items;
  final out = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    out.add(items[i]);
    if (i != items.length - 1) out.add(separator);
  }
  return out;
}
