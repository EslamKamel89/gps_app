import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageUrl,
    required this.onAdd,
  });

  final String name;
  final String desc;
  final double price;
  final String imageUrl;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onAdd,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GPSColors.cardSelected, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area with fixed aspect ratio to avoid layout shift
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                // AspectRatio(
                //   aspectRatio: 16 / 10,
                //   child:
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: GPSColors.cardBorder,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  // Fallback UI if image fails
                  errorBuilder:
                      (context, error, stack) => Container(
                        color: GPSColors.cardBorder,
                        alignment: Alignment.center,
                        child: Icon(Icons.image_not_supported_outlined, color: GPSColors.mutedText),
                      ),
                ),
              ),
              // ),
              GPSGaps.h8,
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              GPSGaps.h8,
              Text(
                desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.25),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    _formatPrice(price),
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: GPSColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onAdd,
                    tooltip: 'Add to cart',
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    splashRadius: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatPrice(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
