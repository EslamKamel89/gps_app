import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: GPSColors.primary.withOpacity(.10),
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: txt.labelMedium?.copyWith(
          color: GPSColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
