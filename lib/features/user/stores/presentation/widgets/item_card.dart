import 'package:flutter/material.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.heroTag});

  final CatalogItemModel item;
  final String heroTag;

  String _imageUrl() {
    final path = item.image?.path;
    if (path == null) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    return "${EndPoint.baseUrl}/$path";
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final price = (item.price ?? '').isEmpty ? null : item.price;

    return Ink(
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Hero(
              tag: heroTag,
              child: Image.network(
                _imageUrl(),
                width: 110,
                height: 110,
                fit: BoxFit.cover,
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
                  Text(
                    item.name ?? 'Item',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GPSGaps.h8,
                  if ((item.description ?? '').isNotEmpty)
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: txt.bodyMedium?.copyWith(
                        color: GPSColors.mutedText,
                        height: 1.35,
                      ),
                    ),
                  GPSGaps.h8,
                  if (price != null)
                    Text(
                      price,
                      style: txt.titleSmall?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
