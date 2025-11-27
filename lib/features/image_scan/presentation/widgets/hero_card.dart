import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/image_scan/controllers/image_scan_controller.dart';
import 'package:gps_app/features/image_scan/presentation/widgets/blob.dart';
import 'package:gps_app/features/image_scan/presentation/widgets/scan_image_button.dart';
import 'package:gps_app/features/image_scan/presentation/widgets/show_result.dart';

class HeroCard extends StatefulWidget {
  const HeroCard({super.key});

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  String? path;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            GPSColors.primary.withOpacity(.85),
            GPSColors.primary.withOpacity(.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image:
            path != null
                ? DecorationImage(
                  image: NetworkImage(path!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25),
                    BlendMode.darken,
                  ),
                )
                : null,
      ),

      height: context.height * 0.6,
      alignment: Alignment.center,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.2),
        ),
        child: Stack(
          children: [
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

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                Icon(
                      Icons.document_scanner_rounded,
                      size: 84,
                      color: GPSColors.cardSelected,
                    )
                    .animate(onPlay: (c) => c.repeat(period: 3.seconds))
                    .shimmer(duration: 1200.ms),
                const SizedBox(height: 16),
                Text(
                  'Scan a product photo',
                  textAlign: TextAlign.center,
                  style: t.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18, width: double.infinity),
                ImageUploadField(
                  multiple: false,
                  showPreview: false,
                  resource: UploadResource.common,
                  initial: const [],
                  onChanged: (images) async {
                    if (images.isEmpty) return;
                    setState(() {
                      loading = true;
                      path = "${EndPoint.baseUrl}/${images[0].path}";
                      // path =
                      // "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
                      // "https://plus.unsplash.com/premium_photo-1675252369719-dd52bc69c3df?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
                    });
                    final res = await serviceLocator<ImageScanController>()
                        .scan(imageUrl: path!);
                    if (res.response == ResponseEnum.success &&
                        res.data?.isNotEmpty == true) {
                      showResult(res.data ?? '');
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  child: ScanImageButton(loading: loading),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
