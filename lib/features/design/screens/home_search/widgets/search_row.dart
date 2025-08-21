import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/round_square_buttom.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({
    super.key,
    this.hint = '',
    this.onTap,
    this.onChanged,
    this.onClear,
    this.filtersOnTap,
    required this.controller,
    required this.focusNode,
    required this.editable,
  });

  final String hint;
  final VoidCallback? onTap;
  final VoidCallback? filtersOnTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final field =
        editable
            ? TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: _decoration(hint).copyWith(
                prefixIcon: const Icon(Icons.search_rounded, color: GPSColors.primary),
                suffixIcon:
                    controller.text.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close_rounded, color: GPSColors.mutedText),
                          onPressed: onClear,
                        ),
              ),
            )
            : GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EFE9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: GPSColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: GPSColors.primary),
                    GPSGaps.w12,
                    Expanded(
                      child: Text(
                        hint,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                      ),
                    ),
                  ],
                ),
              ),
            );

    return Row(
      children: [
        Expanded(child: field.animate().fadeIn(duration: 300.ms).slideY(begin: .1)),
        if (!editable) ...[
          GPSGaps.w12,
          RoundSquareButton(icon: Icons.tune_rounded, onTap: filtersOnTap),
        ],
      ],
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.primary, width: 1.6),
      ),
    );
  }
}
