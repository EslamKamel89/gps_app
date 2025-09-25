// features/vendor_onboarding/screens/vendor_onboarding_certifications_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/models/proof.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/proof_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantOnboardingCertificationsScreen extends StatefulWidget {
  const RestaurantOnboardingCertificationsScreen({super.key});

  @override
  State<RestaurantOnboardingCertificationsScreen> createState() =>
      _RestaurantOnboardingCertificationsScreenState();
}

class _RestaurantOnboardingCertificationsScreenState
    extends State<RestaurantOnboardingCertificationsScreen> {
  final List<VendorProof> _proofs = [VendorProof.empty()];

  void _addProof() {
    setState(() {
      _proofs.add(VendorProof.empty());
    });
  }

  void _removeProof(VendorProof proof) {
    setState(() {
      _proofs.remove(proof);
    });
  }

  void _onProofChanged(VendorProof updated) {
    final index = _proofs.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      setState(() {
        _proofs[index] = updated;
      });
    }
  }

  bool get _isDoneEnabled => _proofs.any((p) => p.title.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  Text(
                    'Step 3 of 3',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GPSColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      '📄 Add Your Certifications & Proofs',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    GPSGaps.h8,
                    Text(
                      'Upload licenses, permits, or certifications that verify your business or farm practices.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GPSColors.mutedText,
                        height: 1.4,
                      ),
                    ),
                    GPSGaps.h24,

                    // Proof Cards
                    ..._proofs.map((proof) {
                      return ProofCard(
                        proof: proof,
                        onDelete: () => _removeProof(proof),
                        onChanged: _onProofChanged,
                      );
                    }),

                    // Add Another Proof
                    GPSGaps.h12,
                    AddButton(label: 'Add Another Proof', onTap: _addProof),
                    GPSGaps.h24,
                  ],
                ),
              ),
            ),

            // Footer Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('← Previous'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        _isDoneEnabled
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Onboarding complete!"),
                                ),
                              );
                              // Navigate to dashboard
                              // Navigator.pushReplacementNamed(context, AppRoutesNames.vendorDashboard);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
      ),
    );
  }
}
