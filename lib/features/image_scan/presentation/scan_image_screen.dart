import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/image_scan/presentation/widgets/hero_card.dart';

class ScanImageScreen extends StatefulWidget {
  const ScanImageScreen({super.key});

  @override
  State<ScanImageScreen> createState() => _ScanImageScreenState();
}

class _ScanImageScreenState extends State<ScanImageScreen> {
  int _currentTab = 2;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: TopBar(title: 'Scan & Analyze'),
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

              Expanded(
                child: HeroCard()
                    .animate()
                    .fadeIn(duration: 420.ms, delay: 120.ms)
                    .slideY(begin: .06, curve: Curves.easeOut),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
