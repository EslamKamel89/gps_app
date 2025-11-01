// features/vendor_onboarding/widgets/menu_item_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/store_details/controllers/store_controller.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';

class AddItemCard extends StatefulWidget {
  const AddItemCard({super.key, required this.section});
  final CatalogSectionModel section;

  @override
  State<AddItemCard> createState() => _AddItemCardState();
}

class _AddItemCardState extends State<AddItemCard> {
  late CatalogItemModel item;
  bool _expanded = false;

  void _toggleExpanded([bool? v]) {
    setState(() => _expanded = v ?? !_expanded);
    if (v == false) FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    item = CatalogItemModel(catalogSectionId: widget.section.id);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GPSColors.cardBorder.withOpacity(0.3)),
        ),
        child: AnimatedSwitcher(
          duration: 250.ms,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder:
              (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              ),
          child: _expanded ? _buildExpanded(context) : _buildCollapsed(context),
        ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.06),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return Padding(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
              onPressed: () => _toggleExpanded(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: GPSColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add Item',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 160.ms)
            .scale(begin: const Offset(0.98, 0.98)),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Padding(
          key: const ValueKey('expanded'),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + collapse button
              Row(
                children: [
                  Text(
                    "Item • ${item.name ?? 'Untitled'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GPSColors.text,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Collapse',
                    onPressed: () => _toggleExpanded(false),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.06),
                    ),
                    icon: const Icon(Icons.expand_less, color: GPSColors.text),
                  ),
                ],
              ),
              // subtle divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.14),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              GPSGaps.h12,

              // Name
              GpsLabeledField(
                label: 'Name',
                child: TextFormField(
                  initialValue: item.name,
                  onChanged: (v) {
                    setState(() {
                      item.name = v;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'e.g., Beef Burger',
                  ),
                  validator:
                      (v) =>
                          validator(input: v, label: 'Name', isRequired: true),
                ),
              ),
              GPSGaps.h12,

              // Image upload
              ImageUploadField(
                multiple: false,
                resource: UploadResource.item,
                initial: const [],
                onChanged: (images) {
                  if (images.isEmpty) return;
                  item.image = ImageModel(
                    id: images[0].id,
                    path: images[0].path,
                  );
                },
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Text('Tap to upload product image'),
                ),
              ),
              GPSGaps.h12,

              // Price
              GpsLabeledField(
                label: 'Price',
                child: TextFormField(
                  initialValue: item.price ?? '',
                  onChanged: (v) => item.price = v,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'e.g., 12.95',
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: GPSColors.primary),
                  ),
                  validator:
                      (v) =>
                          validator(input: v, label: 'Price', isRequired: true),
                ),
              ),
              GPSGaps.h12,

              // Description
              GpsLabeledField(
                label: 'Description (Optional)',
                child: TextFormField(
                  initialValue: item.description,
                  onChanged: (v) => item.description = v,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Grass-fed beef, cheddar, lettuce...',
                  ),
                ),
              ),
              GPSGaps.h12,

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: context.width * 0.5,
                  child: AddButton(label: 'Add Item', onTap: _addItem),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.03, curve: Curves.easeOutCubic);
  }

  Future _addItem() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = serviceLocator<StoreController>();
    final cubit = context.read<StoreCubit>();
    widget.section.items ?? [];
    widget.section.items?.add(item);
    cubit.update(cubit.state.data!);
    final res = await controller.addItem(item: item);
    cubit.user();
    if (res.response == ResponseEnum.success) {
      if (mounted) {
        setState(() {
          item = CatalogItemModel(catalogSectionId: widget.section.id);
        });
      }
    }
  }
}
