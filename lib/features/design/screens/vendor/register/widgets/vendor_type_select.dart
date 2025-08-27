// widgets/vendor_type_select.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

enum VendorType {
  restaurant('Restaurant', Icons.restaurant),
  store('Store', Icons.shop),
  farm('Farm', Icons.agriculture);

  const VendorType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class VendorTypeSelect extends StatefulWidget {
  final VendorType? value;
  final ValueChanged<VendorType> onChanged;

  const VendorTypeSelect({super.key, this.value, required this.onChanged});

  @override
  State<VendorTypeSelect> createState() => _VendorTypeSelectState();
}

class _VendorTypeSelectState extends State<VendorTypeSelect> {
  late VendorType _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? VendorType.restaurant;
  }

  @override
  void didUpdateWidget(covariant VendorTypeSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _selected = widget.value!;
    }
  }

  void _onPressed(VendorType type) {
    setState(() {
      _selected = type;
    });
    widget.onChanged(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: GPSColors.text),
        ),
        GPSGaps.h12,
        Row(
          children:
              VendorType.values.map((type) {
                final selected = _selected == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onPressed(type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? GPSColors.primary.withOpacity(0.15) : Colors.transparent,
                        border: Border.all(
                          color: selected ? GPSColors.primary : GPSColors.cardBorder,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            size: 24,
                            color: selected ? GPSColors.primary : GPSColors.mutedText,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            type.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected ? GPSColors.primary : GPSColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95)),
                );
              }).toList(),
        ),
      ],
    );
  }
}
