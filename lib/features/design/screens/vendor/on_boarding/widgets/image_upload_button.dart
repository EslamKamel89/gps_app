// features/vendor_onboarding/widgets/image_upload_button.dart

import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ImageUploadButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ImageUploadButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Image',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: GPSColors.text,
          ),
        ),
        GPSGaps.h8,
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GPSColors.cardBorder),
              color: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
        GPSGaps.h8,
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: GPSColors.primary),
            icon: const Icon(Icons.upload_rounded, size: 16),
            label: const Text('Upload Photo'),
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
