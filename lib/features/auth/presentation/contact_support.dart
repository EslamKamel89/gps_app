import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class AccountBlockedScreen extends StatelessWidget {
  const AccountBlockedScreen({
    super.key,

    this.secondaryLabel = 'Go back',
    this.supportEmail = 'support@example.com',
    this.ticketId,
  });

  final String secondaryLabel;
  final String supportEmail;
  final String? ticketId; // Optional reference code to show to user

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    // Warning palette (align to your token system if you have equivalents)
    const warning = Color(0xFFFFB020); // amber
    const danger = Color(0xFFDC2626); // red-600
    const dark = Color(0xFF0F172A); // slate-900 for contrast

    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // === Decorative header ===
            Positioned.fill(
              child: Column(
                children: [
                  // Top hero (warning gradient + icon halo)
                  SizedBox(
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Diagonal warning gradient
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFF4E5), // soft-amber
                                Color(0xFFFFE8E6), // soft-red
                              ],
                            ),
                          ),
                        ),
                        // Subtle pattern overlay via blur & border
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 24, right: 16),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: GPSColors.cardBorder),
                              color: Colors.white.withOpacity(.35),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                              child: const SizedBox(),
                            ),
                          ).animate().fadeIn(duration: 300.ms).slideX(begin: .08),
                        ),
                        // Pulsing warning icon halo
                        Center(
                          child: _WarningHalo(
                            size: 140,
                            iconColor: danger,
                            ringColor: warning.withOpacity(.22),
                            bgColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content section sits on neutral background
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
            // === Foreground content ===
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 220, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Account blocked',
                                style: txt.headlineSmall?.copyWith(
                                  color: GPSColors.text,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const _StatusChip(label: 'Blocked'),
                          ],
                        )
                        .animate()
                        .fadeIn(duration: 260.ms)
                        .slideY(begin: .10, curve: Curves.easeOutCubic),

                    GPSGaps.h12,

                    Text(
                      "Your account has been blocked by the administration.",
                      style: txt.bodyLarge?.copyWith(
                        color: GPSColors.text,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate(delay: 60.ms).fadeIn(duration: 240.ms).slideY(begin: .08),

                    GPSGaps.h8,

                    Text(
                      "If you believe this is a mistake, please contact our support team. We'll review your case and get back to you as soon as possible.",
                      style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.45),
                    ).animate(delay: 90.ms).fadeIn(duration: 240.ms).slideY(begin: .06),

                    if (ticketId != null) ...[
                      GPSGaps.h12,
                      _InfoCard(
                        icon: Icons.confirmation_number_rounded,
                        title: 'Reference ID',
                        subtitle: ticketId!,
                      ).animate(delay: 120.ms).fadeIn(duration: 260.ms).slideY(begin: .08),
                    ],

                    GPSGaps.h16,

                    _StepsCard(
                      steps: const [
                        'Review the latest email/notification from the app.',
                        'Prepare any details that can help verify your identity.',
                        'Contact support to request a manual review.',
                      ],
                    ).animate(delay: 140.ms).fadeIn(duration: 260.ms).slideY(begin: .08),

                    GPSGaps.h20,

                    // CTA buttons
                    _PrimaryButton(
                      label: 'Contact Support',
                      onPressed: () {},
                      leading: Icons.support_agent_rounded,
                      bg: danger,
                    ).animate(delay: 160.ms).fadeIn(duration: 240.ms).slideY(begin: .06),

                    GPSGaps.h12,

                    _SecondaryButton(
                      label: secondaryLabel,
                      onPressed: () {},
                    ).animate(delay: 180.ms).fadeIn(duration: 220.ms).slideY(begin: .06),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningHalo extends StatelessWidget {
  const _WarningHalo({
    required this.size,
    required this.iconColor,
    required this.ringColor,
    required this.bgColor,
  });

  final double size;
  final Color iconColor;
  final Color ringColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final ring = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: -6,
            offset: Offset(0, 12),
            color: Color(0x33000000),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.block_rounded, size: size * .45, color: iconColor),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulsing ring
        Container(
              width: size * 1.45,
              height: size * 1.45,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ringColor),
            )
            .animate(onPlay: (c) => c.repeat(period: 1600.ms))
            .scale(begin: const Offset(.85, .85), end: const Offset(1, 1))
            .fade(begin: 0.30, end: 0.0),

        // Middle ring
        Container(
              width: size * 1.2,
              height: size * 1.2,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ringColor),
            )
            .animate(onPlay: (c) => c.repeat(period: 1600.ms))
            .scale(begin: const Offset(.85, .85), end: const Offset(1, 1))
            .fade(begin: 0.30, end: 0.0),

        // Icon disc
        ring.animate().fadeIn(duration: 350.ms).scale(begin: const Offset(.96, .96)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8E6), // soft red
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Text(
        label,
        style: txt.labelMedium?.copyWith(
          color: const Color(0xFFB42318),
          fontWeight: FontWeight.w800,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.confirmation_number_rounded, color: Color(0xFFB45309)),
            ),
            GPSGaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: txt.labelLarge?.copyWith(
                      color: GPSColors.mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GPSGaps.h8,
                  Text(
                    subtitle,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What you can do',
              style: txt.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
            ),
            GPSGaps.h8,
            ...List.generate(steps.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.chevron_right_rounded, color: GPSColors.mutedText, size: 20),
                    GPSGaps.w8,
                    Expanded(
                      child: Text(
                        steps[i],
                        style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed, this.leading, this.bg});

  final String label;
  final VoidCallback? onPressed;
  final IconData? leading;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg ?? const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          shadowColor: const Color(0x33000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[Icon(leading, size: 20), GPSGaps.w8],
            Text(
              label,
              style: txt.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: GPSColors.text,
          side: const BorderSide(color: GPSColors.cardBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: txt.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
