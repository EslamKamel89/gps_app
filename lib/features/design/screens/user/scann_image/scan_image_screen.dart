import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class ScanImageScreen extends StatefulWidget {
  const ScanImageScreen({super.key});

  @override
  State<ScanImageScreen> createState() => _ScanImageScreenState();
}

class _ScanImageScreenState extends State<ScanImageScreen> {
  int _currentTab = 2;
  void _onPickFromCamera() {
    Navigator.pop(context); // close sheet
  }

  void _onPickFromGallery() {
    Navigator.pop(context); // close sheet
  }

  void _openSourceSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final t = Theme.of(context).textTheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose a source', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _SourceTile(
                    icon: Icons.camera_alt_rounded,
                    label: 'Use Camera',
                    subtitle: 'Take a clear photo of the product',
                    onTap: _onPickFromCamera,
                  )
                  .animate()
                  .fadeIn(duration: 260.ms, delay: 60.ms)
                  .slideY(begin: .08, curve: Curves.easeOut),
              const SizedBox(height: 12),
              _SourceTile(
                    icon: Icons.photo_library_rounded,
                    label: 'Pick from Gallery',
                    subtitle: 'Choose an existing image',
                    onTap: _onPickFromGallery,
                  )
                  .animate()
                  .fadeIn(duration: 260.ms, delay: 120.ms)
                  .slideY(begin: .08, curve: Curves.easeOut),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: TopBar(title: 'Scan & Analyze'), // same TopBar you already use
        ),
        bottomNavigationBar: GPSBottomNav(
          currentIndex: _currentTab,
          onChanged: (i) {
            setState(() => _currentTab = i);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Point. Snap. Learn.',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ).animate().fadeIn(duration: 350.ms).moveY(begin: 14, curve: Curves.easeOut),
              const SizedBox(height: 6),
              Text(
                'Take a photo of any product and we’ll analyze it for ingredients, nutrition, and suitability—soon!',
                style: t.bodyMedium?.copyWith(color: t.bodyMedium?.color?.withOpacity(.75)),
              ).animate().fadeIn(duration: 400.ms, delay: 80.ms),

              const SizedBox(height: 20),

              // Hero card
              Expanded(
                child: _HeroCard(onPrimary: _openSourceSheet)
                    .animate()
                    .fadeIn(duration: 420.ms, delay: 120.ms)
                    .slideY(begin: .06, curve: Curves.easeOut),
              ),

              const SizedBox(height: 12),

              // Secondary CTA
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                          onPressed: _openSourceSheet,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: GPSColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.image_search_rounded),
                          label: const Text('Select Image'),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 160.ms)
                        .moveY(begin: 10, curve: Curves.easeOut),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onPrimary;
  const _HeroCard({required this.onPrimary});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [GPSColors.primary.withOpacity(.85), GPSColors.primary.withOpacity(.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          // playful background circles
          Positioned(
            right: -12,
            top: -12,
            child: _Blob(size: 120, opacity: .18, color: GPSColors.cardBorder),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: _Blob(size: 160, opacity: .12, color: GPSColors.cardBorder),
          ),

          // content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              Icon(
                Icons.document_scanner_rounded,
                size: 84,
                color: GPSColors.cardSelected,
              ).animate(onPlay: (c) => c.repeat(period: 3.seconds)).shimmer(duration: 1200.ms),
              const SizedBox(height: 16),
              Text(
                'Scan a product photo',
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'We’ll extract labels and details (soon). For now, try the UI!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: GPSColors.cardSelected),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                    onPressed: onPrimary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GPSColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: Icon(Icons.camera_enhance_rounded, color: GPSColors.cardBorder),
                    label: const Text('Scan a product'),
                  )
                  .animate()
                  .scale(begin: const Offset(.98, .98), curve: Curves.easeOutBack, duration: 320.ms)
                  .then(delay: 120.ms)
                  .shake(hz: 2, offset: const Offset(.5, 0), duration: 380.ms),
            ],
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final double opacity;
  final Color color;
  const _Blob({required this.size, required this.opacity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(color: color.withOpacity(opacity * .6), blurRadius: 30, spreadRadius: 8),
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          // color: GPSColors.primary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardSelected),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: GPSColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: GPSColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: t.bodySmall?.copyWith(color: t.bodySmall?.color?.withOpacity(.75)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
