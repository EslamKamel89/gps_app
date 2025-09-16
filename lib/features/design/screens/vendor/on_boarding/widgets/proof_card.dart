// features/vendor_onboarding/widgets/proof_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/proof.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/image_upload_button.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ProofCard extends StatefulWidget {
  final VendorProof proof;
  final VoidCallback onDelete;
  final ValueChanged<VendorProof> onChanged;

  const ProofCard({
    super.key,
    required this.proof,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<ProofCard> createState() => _ProofCardState();
}

class _ProofCardState extends State<ProofCard> {
  late VendorProof _proof;

  @override
  void initState() {
    _proof = widget.proof;
    super.initState();
  }

  void _update(String field, dynamic value) {
    // _proof = _proof.copyWith({field: value});
    // widget.onChanged(_proof);
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
                'Proof • ${_proof.title.isEmpty ? 'Untitled' : _proof.title}',
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
              initialValue: _proof.title,
              onChanged: (v) => _update('title', v),
              decoration: const InputDecoration(
                hintText: 'e.g., Health License',
              ),
            ),
          ),
          GPSGaps.h16,

          // Description
          GpsLabeledField(
            label: 'Description (Optional)',
            child: TextFormField(
              initialValue: _proof.description,
              onChanged: (v) => _update('description', v),
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g., Issued by City Health Dept.',
              ),
            ),
          ),
          GPSGaps.h16,

          // Image Upload
          ImageUploadButton(
            imageUrl: _proof.imageUrl,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Image picker not implemented yet"),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
