import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SelectedSubcategoriesInfo extends StatelessWidget {
  final int count;

  final String? emptyStateAsset;

  final VoidCallback? onTap;

  const SelectedSubcategoriesInfo({
    super.key,
    required this.count,
    this.emptyStateAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = count == 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: GPSColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: GPSColors.cardBorder.withOpacity(0.45),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0.5,
            ),
          ],
          gradient:
              isEmpty
                  ? null
                  : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GPSColors.cardSelected.withOpacity(0.55),
                      GPSColors.background,
                    ],
                  ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder:
              (currentChild, previousChildren) => Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
          child:
              isEmpty
                  ? _EmptyState(
                    key: const ValueKey('empty'),
                    asset: emptyStateAsset,
                  )
                  : _SelectedState(
                    key: const ValueKey('selected'),
                    count: count,
                  ),
        ),
      ),
    );
  }
}

class _SelectedState extends StatelessWidget {
  final int count;
  const _SelectedState({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final String label = count == 1 ? 'sub-category' : 'sub-categories';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: GPSColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: GPSColors.primary.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 18, color: GPSColors.primary),
              GPSGaps.w8,
              Text(
                '$count',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
            ],
          ),
        ),
        GPSGaps.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have $count $label selected',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GPSColors.text,
                ),
              ),
              GPSGaps.h6,
              const Text(
                'Tap on the sub category chip to toggle your selection',
                style: TextStyle(fontSize: 13, color: GPSColors.mutedText),
              ),
            ],
          ),
        ),
        GPSGaps.w12,
        Icon(Icons.chevron_right, color: GPSColors.mutedText),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String? asset;
  const _EmptyState({super.key, this.asset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 56,
            width: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: GPSColors.cardSelected.withOpacity(0.35),
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 28,
                color: GPSColors.primary,
              ),
            ),
          ),
        ),
        GPSGaps.w12,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'No sub-categories selected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GPSColors.text,
                ),
              ),
              GPSGaps.h6,
              Text(
                'Pick at least one to get started',
                style: TextStyle(fontSize: 13, color: GPSColors.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
