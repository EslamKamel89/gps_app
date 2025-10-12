import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

import 'circle_back.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x11000000),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class CoverError extends StatelessWidget {
  const CoverError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x14000000),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: Colors.black45,
        ),
      ),
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: GPSColors.background,
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            leading: const CircleBack(),
            flexibleSpace: const FlexibleSpaceBar(
              background: CoverPlaceholder(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 22, width: 200, color: Colors.white),
                  GPSGaps.h12,
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 34, color: Colors.white),
                      ),
                      GPSGaps.w8,
                      Expanded(
                        child: Container(height: 34, color: Colors.white),
                      ),
                      GPSGaps.w8,
                      Expanded(
                        child: Container(height: 34, color: Colors.white),
                      ),
                    ],
                  ),
                  GPSGaps.h16,
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  GPSGaps.h8,
                  Container(
                    height: 14,
                    width: MediaQuery.sizeOf(context).width * .7,
                    color: Colors.white,
                  ),
                  GPSGaps.h16,
                  Container(height: 18, width: 120, color: Colors.white),
                  GPSGaps.h12,
                  for (int i = 0; i < 3; i++) ...[
                    Container(
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: GPSColors.cardBorder),
                      ),
                    ),
                    GPSGaps.h12,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: GPSColors.cardBorder),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 14,
                  spreadRadius: -4,
                  offset: Offset(0, 6),
                  color: Color(0x1A000000),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 42,
                  color: Colors.black54,
                ),
                GPSGaps.h12,
                Text(
                  'Failed to load restaurant.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                GPSGaps.h8,
                Text(
                  'Please check your connection and try again.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GPSColors.mutedText,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
                GPSGaps.h16,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
