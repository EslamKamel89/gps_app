// features/vendor_onboarding/widgets/branch_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/branch.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/map_placeholder.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/opening_hours_editor.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BranchCard extends StatefulWidget {
  final VendorBranch branch;
  final VoidCallback onDelete;
  final ValueChanged<VendorBranch> onChanged;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<BranchCard> createState() => _BranchCardState();
}

class _BranchCardState extends State<BranchCard> {
  late VendorBranch _branch;

  @override
  void initState() {
    _branch = widget.branch;
    super.initState();
  }

  void _update(String field, dynamic value) {
    _branch = _branch.copyWith({field: value});
    widget.onChanged(_branch);
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
                'Branch ${_branch.branchName.isEmpty ? '1' : ''}',
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
              initialValue: _branch.branchName,
              onChanged: (v) => _update('branchName', v),
              decoration: const InputDecoration(hintText: 'e.g., Downtown Branch'),
            ),
          ),
          GPSGaps.h16,

          // Phone Number
          GpsLabeledField(
            label: 'Phone Number',
            child: TextFormField(
              initialValue: _branch.phoneNumber,
              onChanged: (v) => _update('phoneNumber', v),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'e.g., +1 212 555 1234'),
            ),
          ),
          GPSGaps.h16,

          // Opening Hours
          OpeningHoursEditor(
            hours: _branch.openingHours,
            onChanged: (hours) => _update('openingHours', hours),
          ),
          GPSGaps.h16,

          // Website
          GpsLabeledField(
            label: 'Website (Optional)',
            child: TextFormField(
              initialValue: _branch.website,
              onChanged: (v) => _update('website', v),
              decoration: const InputDecoration(hintText: 'https://yourrestaurant.com'),
            ),
          ),
          GPSGaps.h16,

          // Map
          MapPlaceholder(
            latitude: _branch.latitude,
            longitude: _branch.longitude,
            onTap: () {
              // Placeholder for map edit dialog
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Map editing not implemented yet")));
            },
          ),
          GPSGaps.h16,

          // Photos
          Text(
            'Photos (Optional)',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: GPSColors.text),
          ),
          GPSGaps.h8,
          SizedBox(
            height: 80,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
              children: List.generate(4, (index) {
                final images = [
                  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  'https://images.unsplash.com/photo-1723744910344-370bc4305972?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  'https://images.unsplash.com/photo-1535850452425-140ee4a8dbae?q=80&w=812&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ];
                if (index == 0) {
                  return Icon(Icons.add);
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: GPSColors.cardBorder,
                  ),
                  child: Image.network(images[index - 1], fit: BoxFit.cover),
                );
              }),
            ),
          ),
          GPSGaps.h16,

          // Verified Toggle
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, size: 16, color: GPSColors.primary),
              GPSGaps.w8,
              const Text('Verified'),
              const Spacer(),
              Switch(
                value: _branch.isVerified,
                onChanged: (v) => _update('isVerified', v),
                activeColor: GPSColors.primary,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
