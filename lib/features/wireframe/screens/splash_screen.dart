import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';

class GPSSplashScreen extends StatefulWidget {
  const GPSSplashScreen({
    super.key,
    this.onFinished,
    this.autoNavigate = false,
    this.duration = const Duration(milliseconds: 1800),
  });

  final VoidCallback? onFinished;
  final bool autoNavigate;
  final Duration duration;

  @override
  State<GPSSplashScreen> createState() => _GPSSplashScreenState();
}

class _GPSSplashScreenState extends State<GPSSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoNavigate && widget.onFinished != null) {
      Future.delayed(widget.duration + const Duration(milliseconds: 600), widget.onFinished);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo mark
              const _PinLeafLogo(size: 140)
                  .animate()
                  .fadeIn(duration: 550.ms)
                  .scale(begin: const Offset(.85, .85), curve: Curves.easeOutBack)
                  .then()
                  .shake(hz: 1.5, duration: 350.ms),
              GPSGaps.h24,
              // Title
              Text(
                    'GPS',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: const Color(0xFFF2E9D8), // creamy text like mock
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: .2, curve: Curves.easeOutQuad),
              GPSGaps.h8,
              // Subtitle
              Text(
                    'GPS FOR HEALTH',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFF2E9D8),
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 350.ms)
                  .slideY(begin: .2)
                  .shimmer(duration: 1200.ms, delay: 900.ms),
              GPSGaps.h24,
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomSwipeHint(),
    );
  }
}

/// ------------------------------ LOGO --------------------------------------
/// A teardrop (map pin) with a circular field and two leaves. No images.
class _PinLeafLogo extends StatelessWidget {
  const _PinLeafLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _PinLeafPainter());
  }
}

class _PinLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Colors from brand palette
    const gold = Color(0xFFE7D4A7); // pin color (warm sand)
    const cream = Color(0xFFF2E9D8); // inner ring
    const leaf = Color(0xFF2B6E5F); // darker green for leaves

    final paint = Paint()..isAntiAlias = true;

    // 1) Teardrop (map pin)
    final pinPath = Path();
    final r = w * 0.36; // radius of circle part
    final cx = w / 2;
    final cy = h * 0.42; // center of circular part

    // Draw circle
    pinPath.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    // Draw tail (triangle-ish) blending into circle
    pinPath.moveTo(cx - r * .55, cy + r * .6);
    pinPath.quadraticBezierTo(cx, h * .98, cx + r * .55, cy + r * .6);

    paint.color = gold;
    canvas.drawPath(pinPath, paint);

    // 2) Inner cream circle
    paint.color = cream;
    canvas.drawCircle(Offset(cx, cy), r * 0.72, paint);

    // 3) Leaves (two simple bezier leaves)
    paint.color = leaf;
    final leafPathLeft =
        Path()
          ..moveTo(cx, cy)
          ..quadraticBezierTo(cx - r * .6, cy - r * .2, cx - r * .22, cy - r * .52)
          ..quadraticBezierTo(cx - r * .05, cy - r * .6, cx, cy)
          ..close();
    final leafPathRight =
        Path()
          ..moveTo(cx, cy)
          ..quadraticBezierTo(cx + r * .6, cy - r * .25, cx + r * .22, cy - r * .55)
          ..quadraticBezierTo(cx + r * .05, cy - r * .62, cx, cy)
          ..close();
    canvas.drawPath(leafPathLeft, paint);
    canvas.drawPath(leafPathRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ------------------------- BOTTOM SWIPE HINT -------------------------------
class _BottomSwipeHint extends StatelessWidget {
  const _BottomSwipeHint();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GPSColors.primary,
      padding: const EdgeInsets.only(bottom: 12, top: 6),
      child: Center(
        child: Container(
              width: 110,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.35),
                borderRadius: BorderRadius.circular(4),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .slideX(begin: -.02, end: .02, duration: 900.ms)
            .tint(color: Colors.white.withOpacity(.15), duration: 900.ms),
      ),
    );
  }
}

/// ------------------------------ EXAMPLE -----------------------------------
/// Use like:
/// MaterialApp(
///   theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: GPSColors.primary)),
///   home: GPSSplashScreen(
///     autoNavigate: true,
///     onFinished: () => Navigator.of(context).pushReplacement(
///       MaterialPageRoute(builder: (_) => const HomeSearchScreen()),
///     ),
///   ),
/// );
