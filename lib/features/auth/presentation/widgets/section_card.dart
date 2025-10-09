// features/vendor_onboarding/widgets/menu_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/cubits/create_catalog_section_items/create_catalog_section_items_cubit.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';
import 'package:gps_app/features/auth/presentation/widgets/add_button.dart';
import 'package:gps_app/features/auth/presentation/widgets/gps_label_field.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/widgets/product_item_form.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/resturant_details_screen.dart';

class SectionCard extends StatefulWidget {
  final CatalogSectionParam section;
  final VoidCallback onDelete;

  const SectionCard({super.key, required this.section, required this.onDelete});

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  late CreateCatalogSectionItemsCubit cubit;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreateCatalogSectionItemsCubit cubit = context.watch<CreateCatalogSectionItemsCubit>();

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
                "Category • ${widget.section.name ?? 'Untitled'}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GPSColors.text,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
                tooltip: 'Delete Category',
              ),
            ],
          ),
          GPSGaps.h12,

          // Menu Name
          GpsLabeledField(
            label: 'Category Name',
            child: TextFormField(
              initialValue: widget.section.name,
              onChanged: (v) => widget.section.name = v,
              decoration: const InputDecoration(hintText: 'e.g., Organic'),
              validator: (v) => validator(input: v, label: 'Category Name', isRequired: true),
            ),
          ),
          GPSGaps.h16,
          ImageUploadField(
            multiple: false,
            resource: UploadResource.section,
            initial: const [],
            onChanged: (images) {
              if (images.isEmpty) return;
              widget.section.imageId = images[0].id;
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text('Tap to upload category image'),
            ),
          ),

          // GPSGaps.h16,

          // Description
          // GpsLabeledField(
          //   label: 'Description (Optional)',
          //   child: TextFormField(
          //     initialValue: _menu.description,
          //     onChanged: (v) => _update('description', v),
          //     maxLines: 2,
          //     decoration: const InputDecoration(
          //       hintText: 'e.g., Weekday lunch specials',
          //     ),
          //   ),
          // ),
          GPSGaps.h20,

          const SectionHeader(title: 'Category Items'),
          GPSGaps.h12,
          if (widget.section.catalogItems?.isEmpty == true)
            Text(
              'No items added yet.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: GPSColors.mutedText),
            ),
          ...(widget.section.catalogItems ?? []).map((item) {
            return ProductItemForm(
              item: item,
              onRemove: () => cubit.removeItem(sectionParam: widget.section, itemParam: item),
            );
          }),

          GPSGaps.h12,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: context.width * 0.5,
              child: AddButton(
                label: 'Add Category Item',
                onTap:
                    () =>
                        cubit.addItem(sectionParam: widget.section, itemParam: CatalogItemParam()),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
