// features/vendor_onboarding/widgets/proof_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/single_file_upload_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class AddCertificateCard extends StatefulWidget {
  const AddCertificateCard({super.key});

  @override
  State<AddCertificateCard> createState() => _AddCertificateCardState();
}

class _AddCertificateCardState extends State<AddCertificateCard> {
  final _formKey = GlobalKey<FormState>();
  Certification cert = Certification();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
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
                  'Proof • ${cert.title ?? 'Untitled'}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: GPSColors.text,
                  ),
                ),
                const Spacer(),
              ],
            ),
            GPSGaps.h12,

            // Title
            GpsLabeledField(
              label: 'Title',
              child: TextFormField(
                initialValue: cert.title,
                onChanged: (v) => cert.title = v,
                decoration: const InputDecoration(hintText: 'e.g., Health License'),
                validator: (v) => validator(input: v, label: 'Title', isRequired: true),
              ),
            ),
            GPSGaps.h16,

            // Description
            GpsLabeledField(
              label: 'Description (Optional)',
              child: TextFormField(
                initialValue: cert.description,
                onChanged: (v) => cert.description = v,
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
                  cert.file = [RestaurantFile(path: file.path, id: file.id)];
                },
              ),
            ),
            GPSGaps.h8,
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: context.width * 0.5,
                child: AddButton(label: 'Add Certification', onTap: _addCertification),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08),
    );
  }

  Future _addCertification() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<RestaurantsController>();
    final cubit = context.read<RestaurantCubit>();
    cubit.state.data?.certifications ??= [];
    final certs = cubit.state.data?.certifications;
    certs?.add(cert);
    cubit.update(cubit.state.data!);
    Navigator.of(context).pop();
    final res = await controller.addCertification(cert: cert);
    if (mounted) {
      setState(() {
        cert = Certification();
      });
    }
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }
}
