// features/vendor_onboarding/widgets/branch_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/auth/presentation/widgets/select_location_on_the_map.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class AddBranchCard extends StatefulWidget {
  const AddBranchCard({super.key});

  @override
  State<AddBranchCard> createState() => _AddBranchCardState();
}

class _AddBranchCardState extends State<AddBranchCard> {
  Branch branch = Branch();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                    'Meal • ${(branch.branchName?.trim().isNotEmpty ?? false) ? branch.branchName! : 'Untitled'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: GPSColors.text,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              GPSGaps.h12,

              // Branch Name
              GpsLabeledField(
                label: 'Branch Name',
                child: TextFormField(
                  initialValue: branch.branchName,
                  onChanged: (v) {
                    setState(() {
                      branch.branchName = v;
                    });
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
                  initialValue: branch.phoneNumber,
                  onChanged: (v) => branch.phoneNumber = v,
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
                  initialValue: branch.website,
                  onChanged: (v) => branch.website = v,
                  decoration: const InputDecoration(hintText: 'https://yourrestaurant.com'),
                ),
              ),
              GPSGaps.h16,

              SelectableLocationMap(
                onLocationSelected: (loc) {
                  branch.latitude = loc.latitude.toString();
                  branch.longitude = loc.longitude.toString();
                },
              ),
              GPSGaps.h16,

              // Photos
              Text(
                'Photo (Optional)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: GPSColors.text,
                ),
              ),
              GPSGaps.h8,
              ImageUploadField(
                multiple: false,
                // maxCount: 6,
                resource: UploadResource.branch,
                initial: const [],
                onChanged: (images) {
                  if (images.isEmpty) return;
                  branch.images = [RestaurantImage(id: images[0].id, path: images[0].path)];
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: GPSColors.text,
                ),
              ),
              StateDistrictProvider(
                onSelect: (SelectedStateAndDistrict s) {
                  branch.stateId = s.selectedState?.id;
                  branch.districtId = s.selectedDistrict?.id;
                  branch.state = s.selectedState;
                  branch.district = s.selectedDistrict;
                },
              ),
              GPSGaps.h8,
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: context.width * 0.5,
                  child: AddButton(label: 'Add Branch', onTap: _addBranch),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08),
      ),
    );
  }

  Future _addBranch() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<RestaurantsController>();
    final cubit = context.read<RestaurantCubit>();
    cubit.state.data?.branches ??= [];
    final branches = cubit.state.data?.branches;
    branches?.add(branch);
    cubit.update(cubit.state.data!);
    Navigator.of(context).pop();
    final res = await controller.addBranch(branch: branch);
    if (mounted) {
      setState(() {
        branch = Branch();
      });
    }
    cubit.restaurant(restaurantId: (userInMemory()?.restaurant?.id)!);
  }
}
