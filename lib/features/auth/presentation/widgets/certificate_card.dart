// features/vendor_onboarding/widgets/proof_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/single_file_upload_field.dart';
import 'package:gps_app/features/auth/models/certificate_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class CertificateCard extends StatefulWidget {
  final CertificateParam certificate;
  final VoidCallback onDelete;

  const CertificateCard({super.key, required this.certificate, required this.onDelete});

  @override
  State<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<CertificateCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Proof • ${widget.certificate.title ?? 'Untitled'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
                tooltip: 'Delete Proof',
              ),
            ],
          ),
          GPSGaps.h12,

          // Title
          GpsLabeledField(
            label: 'Title',
            child: TextFormField(
              initialValue: widget.certificate.title,
              onChanged: (v) => widget.certificate.title = v,
              decoration: const InputDecoration(hintText: 'e.g., Health License'),
              validator: (v) => validator(input: v, label: 'Title', isRequired: true),
            ),
          ),
          GPSGaps.h16,

          // Description
          GpsLabeledField(
            label: 'Description (Optional)',
            child: TextFormField(
              initialValue: widget.certificate.description,
              onChanged: (v) => widget.certificate.description = v,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'e.g., Issued by City Health Dept.'),
            ),
          ),
          GPSGaps.h16,
          GpsLabeledField(
            label: 'Upload Certificate',
            child: SingleFileUploadField(
              baseUrl: EndPoint.baseUrl,
              dir: 'certificate',
              initialText: 'No file selected',
              onUploaded: (file) {
                widget.certificate.fileId = file.id;
              },
            ),
          ),
          GPSGaps.h16,
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
