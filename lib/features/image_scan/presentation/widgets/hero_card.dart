import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/image_scan/presentation/widgets/blob.dart';

class HeroCard extends StatefulWidget {
  const HeroCard({super.key});

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  String? path;
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
        image:
            path != null
                ? DecorationImage(
                  image: NetworkImage(path!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25), // optional soft dark overlay
                    BlendMode.darken,
                  ),
                )
                : null,
      ),
      // padding: const EdgeInsets.all(18),
      height: context.height * 0.6,
      alignment: Alignment.center,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Stack(
          children: [
            // playful background circles
            Positioned(
              right: -12,
              top: -12,
              child: Blob(size: 120, opacity: .18, color: GPSColors.cardBorder),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Blob(size: 160, opacity: .12, color: GPSColors.cardBorder),
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
                const SizedBox(height: 18, width: double.infinity),
                ImageUploadField(
                  multiple: false,
                  showPreview: false,
                  resource: UploadResource.common,
                  initial: const [],
                  onChanged: (images) {
                    if (images.isEmpty) return;
                    setState(() {
                      path = "${EndPoint.baseUrl}/${images[0].path}";
                    });
                  },
                  child: Container(
                        decoration: BoxDecoration(
                          color: GPSColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_enhance_rounded, color: GPSColors.cardBorder),
                            GPSGaps.w4,
                            const Text('Scan a product', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(.98, .98),
                        curve: Curves.easeOutBack,
                        duration: 320.ms,
                      )
                      .then(delay: 120.ms)
                      .shake(hz: 2, offset: const Offset(.5, 0), duration: 380.ms),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
