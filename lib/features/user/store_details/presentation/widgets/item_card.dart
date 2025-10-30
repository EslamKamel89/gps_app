import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.section,
    required this.item,
    required this.heroTag,
    required this.enableEdit,
  });
  final bool enableEdit;
  final CatalogSectionModel section;
  final CatalogItemModel item;
  final String heroTag;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _imageUrl() {
    final path = widget.item.image?.path;
    if (path == null) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    return "${EndPoint.baseUrl}/$path";
  }

  bool _showEdit = false;
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final price = (widget.item.price ?? '').isEmpty ? null : widget.item.price;

    return CustomStack(
      enableEdit: widget.enableEdit,
      actionWidget: EditButton(
        onPressed: () {
          setState(() {
            _showEdit = !_showEdit;
          });
        },
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              spreadRadius: -4,
              offset: Offset(0, 6),
              color: Color(0x1A000000),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            CustomStack(
              enableEdit: widget.enableEdit && _showEdit,
              actionWidget: EditButton(
                onPressed: () {
                  _updateItemImage(widget.item);
                },
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Hero(
                  tag: widget.heroTag,
                  child: Image.network(_imageUrl(), width: 110, height: 110, fit: BoxFit.cover),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomStack(
                      enableEdit: widget.enableEdit && _showEdit,
                      actionWidget: EditButton(
                        onPressed: () {
                          _updateItemName(widget.item);
                        },
                      ),
                      child: Text(
                        widget.item.name ?? 'Item',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: txt.titleSmall?.copyWith(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    GPSGaps.h8,
                    if ((widget.item.description ?? '').isNotEmpty)
                      CustomStack(
                        enableEdit: widget.enableEdit && _showEdit,
                        actionWidget: EditButton(
                          onPressed: () {
                            _updateItemDescription(widget.item);
                          },
                        ),
                        child: Text(
                          widget.item.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.35),
                        ),
                      ),
                    GPSGaps.h8,
                    if (price != null)
                      CustomStack(
                        enableEdit: widget.enableEdit && _showEdit,
                        actionWidget: EditButton(
                          onPressed: () {
                            _updateItemPrice(widget.item);
                          },
                        ),
                        child: Text(
                          price,
                          style: txt.titleSmall?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _updateItemName(CatalogItemModel item) async {
    final storage = serviceLocator<LocalStorage>();
    final cubit = context.read<StoreCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) =>
              ProfileTextForm(initialValue: item.name, controller: ctl, label: 'Update Item Name'),
    );
    if (newVal == null) return;
    item.name = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'catalog-items/${item.id}',
      data: {'name': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateItemDescription(CatalogItemModel item) async {
    final storage = serviceLocator<LocalStorage>();
    final cubit = context.read<StoreCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: item.description,
            controller: ctl,
            label: 'Update Item Description',
            isRequired: true,
          ),
    );
    if (newVal == null) return;
    item.description = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'catalog-items/${item.id}',
      data: {'description': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateItemPrice(CatalogItemModel item) async {
    final storage = serviceLocator<LocalStorage>();
    final cubit = context.read<StoreCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: item.price,
            controller: ctl,
            label: 'Update Item Price',
            isNumeric: true,
            isRequired: true,
          ),
    );
    if (newVal == null) return;
    item.price = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'catalog-items/${item.id}',
      data: {'price': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateItemImage(CatalogItemModel item) async {
    final storage = serviceLocator<LocalStorage>();
    final cubit = context.read<StoreCubit>();
    final UploadedImage? newVal = await showFormBottomSheet<UploadedImage>(
      context,
      builder: (ctx, ctl) => ProfileImageForm(controller: ctl, label: 'Update Item image'),
    );
    if (newVal == null) return;
    item.image?.path = newVal.path;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'catalog-items/${item.id}',
      data: {'image_id': newVal.id},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }
}
