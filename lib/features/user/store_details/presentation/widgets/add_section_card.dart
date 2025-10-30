// features/vendor_onboarding/widgets/menu_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/store_details/controllers/store_controller.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';

class AddSectionCard extends StatefulWidget {
  const AddSectionCard({super.key});

  @override
  State<AddSectionCard> createState() => _AddSectionCardState();
}

class _AddSectionCardState extends State<AddSectionCard> {
  CatalogSectionModel section = CatalogSectionModel();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              // Header
              Row(
                children: [
                  Text(
                    "Category • ${section.name ?? 'Untitled'}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: GPSColors.text,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              GPSGaps.h12,

              // Menu Name
              GpsLabeledField(
                label: 'Category Name',
                child: TextFormField(
                  initialValue: section.name,
                  onChanged: (v) {
                    setState(() {
                      section.name = v;
                    });
                  },
                  decoration: const InputDecoration(hintText: 'e.g., Organic'),
                  validator: (v) => validator(input: v, label: 'Category Name', isRequired: true),
                ),
              ),

              GPSGaps.h12,
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: context.width * 0.5,
                  child: AddButton(label: 'Add Category', onTap: _addSection),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08),
      ),
    );
  }

  Future _addSection() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<StoreController>();
    final cubit = context.read<StoreCubit>();
    final sections = cubit.state.data?.storeOrFarm()?.sections ?? [];
    sections.add(section);
    cubit.update(cubit.state.data!);
    final res = await controller.addSection(section: section);
    if (res.response == ResponseEnum.success) {
      if (mounted) {
        setState(() {
          section = CatalogSectionModel();
        });
      }
    }
    cubit.user();
  }
}
