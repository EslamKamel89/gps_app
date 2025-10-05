// features/vendor_onboarding/widgets/branch_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/branch_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/select_location_on_the_map.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BranchCard extends StatefulWidget {
  final BranchParam branch;
  final VoidCallback onDelete;

  const BranchCard({super.key, required this.branch, required this.onDelete});

  @override
  State<BranchCard> createState() => _BranchCardState();
}

class _BranchCardState extends State<BranchCard> {
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
                'Branch - ${[null, ""].contains(widget.branch.branchName) ? "Untitled" : widget.branch.branchName}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
                tooltip: 'Delete Branch',
              ),
            ],
          ),
          GPSGaps.h12,

          // Branch Name
          GpsLabeledField(
            label: 'Branch Name',
            child: TextFormField(
              initialValue: widget.branch.branchName,
              onChanged: (v) {
                widget.branch.branchName = v;
                setState(() {});
              },
              decoration: const InputDecoration(hintText: 'e.g., Downtown Branch'),
              validator: (v) => validator(input: v, label: 'Branch Name', isRequired: true),
            ),
          ),
          GPSGaps.h16,

          // Phone Number
          GpsLabeledField(
            label: 'Phone Number',
            child: TextFormField(
              initialValue: widget.branch.phoneNumber,
              onChanged: (v) => widget.branch.phoneNumber = v,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'e.g., +1 212 555 1234'),
              validator: (v) => validator(input: v, label: 'Phone Number', isRequired: true),
            ),
          ),
          GPSGaps.h16,

          // Website
          GpsLabeledField(
            label: 'Website (Optional)',
            child: TextFormField(
              initialValue: widget.branch.website,
              onChanged: (v) => widget.branch.website = v,
              decoration: const InputDecoration(hintText: 'https://yourrestaurant.com'),
            ),
          ),
          GPSGaps.h16,

          SelectableLocationMap(
            onLocationSelected: (loc) {
              widget.branch.latitude = loc.latitude;
              widget.branch.longitude = loc.longitude;
            },
          ),
          GPSGaps.h16,

          // Photos
          Text(
            'Photo (Optional)',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: GPSColors.text),
          ),
          GPSGaps.h8,
          ImageUploadField(
            multiple: false,
            // maxCount: 6,
            resource: UploadResource.branch,
            initial: const [],
            onChanged: (images) {
              if (images.isEmpty) return;
              widget.branch.imageId = images[0].id;
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text('Tap to upload branch image'),
            ),
          ),

          GPSGaps.h16,
          Text(
            'Pick State and city',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: GPSColors.text),
          ),
          GPSGaps.h8,
          StateDistrictProvider(
            onSelect: (SelectedStateAndDistrict s) {
              widget.branch.stateId = s.selectedState?.id;
              widget.branch.districtId = s.selectedDistrict?.id;
            },
          ),
          // Verified Toggle
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
