import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/tag_chip.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/leaf_badge.dart';

class WishCreateScreen extends StatefulWidget {
  const WishCreateScreen({super.key});

  @override
  State<WishCreateScreen> createState() => _WishCreateScreenState();
}

class _WishCreateScreenState extends State<WishCreateScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        backgroundColor: GPSColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 12,
        title: Row(
          children: [
            const LeafBadge()
                .animate()
                .fadeIn(duration: 220.ms)
                .scale(begin: const Offset(.96, .96)),
            GPSGaps.w12,
            Text(
              'New Wish',
              style: txt.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      body: SafeArea(child: WishListCreateWidget()),
    );
  }
}

class WishTextBox extends StatelessWidget {
  const WishTextBox({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        controller: controller,
        minLines: 3,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
        style: txt.bodyMedium?.copyWith(
          color: GPSColors.text,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        decoration: const InputDecoration(
          hintText: 'e.g., “I love vegan pizza” or “Gluten-free falafel wrap”',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class DietTagSelector extends StatelessWidget {
  const DietTagSelector({
    super.key,
    required this.allTags,
    required this.selected,
    required this.onChanged,
  });

  final List<String> allTags;
  final Set<String> selected;
  final void Function(String tag, bool isSelected) onChanged;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          allTags.map((tag) {
            final bool isOn = selected.contains(tag);
            return InkWell(
              onTap: () => onChanged(tag, !isOn),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isOn ? GPSColors.primary.withOpacity(.10) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isOn ? GPSColors.primary : GPSColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOn ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: isOn ? GPSColors.primary : GPSColors.mutedText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tag,
                      style: txt.labelMedium?.copyWith(
                        color: isOn ? GPSColors.primary : GPSColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}

class WishListCreateWidget extends StatefulWidget {
  const WishListCreateWidget({super.key});

  @override
  State<WishListCreateWidget> createState() => _WishListCreateWidgetState();
}

class _WishListCreateWidgetState extends State<WishListCreateWidget> {
  final _controller = TextEditingController();

  static const List<String> _allDietTags = <String>[
    'Vegan',
    'Vegetarian',
    'Organic',
    'Gluten-free',
    'Dairy-free',
    'Halal',
  ];

  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.wishList, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Describe your wish',
          style: txt.labelMedium?.copyWith(
            color: GPSColors.mutedText,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

        GPSGaps.h8,

        WishTextBox(controller: _controller)
            .animate()
            .fadeIn(duration: 240.ms)
            .slideY(begin: .06)
            .scale(begin: const Offset(.98, .98)),

        GPSGaps.h16,

        Text(
          'Dietary tags',
          style: txt.labelMedium?.copyWith(
            color: GPSColors.mutedText,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

        GPSGaps.h8,

        DietTagSelector(
          allTags: _allDietTags,
          selected: _selectedTags,
          onChanged: (tag, isSelected) {
            setState(() {
              if (isSelected) {
                _selectedTags.add(tag);
              } else {
                _selectedTags.remove(tag);
              }
            });
          },
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        if (_selectedTags.isNotEmpty) ...[
          GPSGaps.h12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((t) => TagChip(label: t)).toList(growable: false),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
        ],

        GPSGaps.h24,

        Row(
          children: [
            OutlinedButton(
              onPressed: _onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: GPSColors.text,
                side: const BorderSide(color: GPSColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
            ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),

            GPSGaps.w12,

            ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: GPSColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800)),
            ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.98, .98)),
          ],
        ),
      ],
    );
  }
}
