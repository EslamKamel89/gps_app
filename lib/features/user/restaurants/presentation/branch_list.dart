// branch_list.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

class BranchList extends StatelessWidget {
  const BranchList({
    super.key,
    required this.branches,
    this.onTapBranch,
    this.onOpenWebsite,
    this.onCall,
    this.compact = false,
    this.heroPrefix,
  });

  final List<Branch> branches;

  final void Function(Branch branch)? onTapBranch;
  final void Function(String url)? onOpenWebsite;
  final void Function(String phoneNumber)? onCall;

  final bool compact;

  final String? heroPrefix;

  @override
  Widget build(BuildContext context) {
    if (branches.isEmpty) {
      return _EmptyState().animate().fadeIn(duration: 280.ms).slideY(begin: .08);
    }

    final pad = compact ? const EdgeInsets.all(12) : const EdgeInsets.fromLTRB(16, 16, 16, 28);

    return Scaffold(
      appBar: AppBar(title: Text('Branches'), backgroundColor: GPSColors.primary),
      body: ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: pad,
        itemCount: branches.length,
        separatorBuilder: (_, __) => GPSGaps.h12,
        itemBuilder: (context, i) {
          final b = branches[i];
          final delay = (70 * i).ms;
          return _BranchCard(
                branch: b,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTapBranch?.call(b);
                },
                onOpenWebsite: onOpenWebsite,
                onCall: onCall,
                heroTag: heroPrefix != null && b.id != null ? '$heroPrefix-${b.id}' : null,
              )
              .animate(delay: delay)
              .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
              .slideY(begin: .08, curve: Curves.easeOutCubic)
              .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
        },
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  const _BranchCard({
    required this.branch,
    this.onTap,
    this.onOpenWebsite,
    this.onCall,
    this.heroTag,
  });

  final Branch branch;
  final VoidCallback? onTap;
  final void Function(String url)? onOpenWebsite;
  final void Function(String phoneNumber)? onCall;
  final String? heroTag;

  RestaurantImage? get _firstImg =>
      (branch.images != null && branch.images!.isNotEmpty) ? branch.images!.first : null;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
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
          children: [
            // Image header
            _BranchImageHeader(image: _firstImg, heroTag: heroTag),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          branch.branchName?.trim().isNotEmpty == true
                              ? branch.branchName!.trim()
                              : 'Branch',
                          style: txt.titleMedium?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Actions (call / website)
                      if ((branch.phoneNumber ?? '').isNotEmpty)
                        _IconAction(
                          tooltip: 'Call',
                          icon: Icons.call_rounded,
                          onTap: () => onCall?.call(branch.phoneNumber!.trim()),
                        ).animate().fadeIn(duration: 150.ms),
                      if ((branch.website ?? '').isNotEmpty) GPSGaps.w8,
                      if ((branch.website ?? '').isNotEmpty)
                        _IconAction(
                          tooltip: 'Open website',
                          icon: Icons.language_rounded,
                          onTap: () => onOpenWebsite?.call(branch.website!.trim()),
                        ).animate(delay: 40.ms).fadeIn(duration: 150.ms),
                    ],
                  ),

                  GPSGaps.h8,

                  // Meta row: phone + website as chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if ((branch.phoneNumber ?? '').isNotEmpty)
                        _MetaChip(
                          icon: Icons.phone_rounded,
                          label: branch.phoneNumber!,
                          onTap: () => onCall?.call(branch.phoneNumber!.trim()),
                        ),
                      if ((branch.website ?? '').isNotEmpty)
                        _MetaChip(
                          icon: Icons.link_rounded,
                          label: _domainOnly(branch.website!),
                          onTap: () => onOpenWebsite?.call(branch.website!.trim()),
                        ),
                    ],
                  ).animate().fadeIn(duration: 200.ms).slideY(begin: .05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _domainOnly(String url) {
    final u = url.trim();
    try {
      final uri = Uri.parse(u.contains('://') ? u : 'https://$u');
      return uri.host.isNotEmpty ? uri.host.replaceFirst('www.', '') : u;
    } catch (_) {
      return u;
    }
  }
}

class _BranchImageHeader extends StatelessWidget {
  const _BranchImageHeader({required this.image, this.heroTag});
  final RestaurantImage? image;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final radius = const BorderRadius.vertical(top: Radius.circular(16));
    final url = image?.path ?? '';

    final imgWidget = CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 160,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder:
          (context, _) => _ShimmerBox(width: double.infinity, height: 160, borderRadius: radius),
      errorWidget: (context, _, __) => _ErrorImageStub(borderRadius: radius),
    );

    final child = ClipRRect(
      borderRadius: radius,
      child: url.isNotEmpty ? imgWidget : _PlaceholderMonogram(borderRadius: radius),
    );

    return heroTag == null ? child : Hero(tag: heroTag!, child: child);
  }
}

/// ——— Small atoms ———

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.onTap, required this.tooltip});
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0x0F111111),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Icon(icon, size: 18, color: GPSColors.text),
        ).animate().scale(begin: const Offset(.95, .95)),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: GPSColors.primary),
          GPSGaps.w8,
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: txt.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );

    return onTap == null ? chip : GestureDetector(onTap: onTap, child: chip);
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.width, required this.height, required this.borderRadius});

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    // Simple animated shimmer using flutter_animate (no extra deps)
    return Animate(
      effects: [
        ShimmerEffect(
          duration: 1200.ms,
          colors: const [Color(0xFFEFEFEF), Color(0xFFF7F7F7), Color(0xFFEFEFEF)],
        ),
      ],
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: borderRadius,
          border: Border.all(color: GPSColors.cardBorder),
        ),
      ),
    );
  }
}

class _ErrorImageStub extends StatelessWidget {
  const _ErrorImageStub({required this.borderRadius});
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: borderRadius,
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: const Center(child: Icon(Icons.broken_image_rounded, color: GPSColors.mutedText)),
    );
  }
}

class _PlaceholderMonogram extends StatelessWidget {
  const _PlaceholderMonogram({required this.borderRadius});
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    // Minimal monogram when no image is available
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius,
      ),
      child: const Center(child: Icon(Icons.store_rounded, color: Colors.white70, size: 36)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_city_rounded, color: GPSColors.mutedText),
            GPSGaps.w12,
            Expanded(
              child: Text(
                'No branches to display.',
                style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
