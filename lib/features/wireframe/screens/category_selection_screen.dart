import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';
import 'package:gps_app/features/wireframe/widgets/header.dart';
import 'package:gps_app/utils/assets/assets.dart';

class CategoryOption {
  final String id;
  final String label;
  final String description; // NEW
  final String assetPath; // asset image path

  const CategoryOption({
    required this.id,
    required this.label,
    required this.description,
    required this.assetPath,
  });
}

// Example using the 6 icons we just extracted from your screenshot:
const _categories = <CategoryOption>[
  CategoryOption(
    id: 'meat',
    label: 'Meat',
    description: 'Grass-fed, pasture-raised',
    assetPath: AssetsData.meat,
  ),
  CategoryOption(
    id: 'dairy',
    label: 'Dairy',
    description: 'Organic milk, cheese, yogurt',
    assetPath: AssetsData.dairy,
  ),
  CategoryOption(
    id: 'fruits_vegetables',
    label: 'Fruits & Vegetables',
    description: 'Fresh, seasonal, pesticide-free',
    assetPath: AssetsData.fruitsVegetables,
  ),
  CategoryOption(
    id: 'groceries',
    label: 'Groceries',
    description: 'Grains, oils, flour, pantry staples',
    assetPath: AssetsData.groceries,
  ),
  CategoryOption(
    id: 'cookware',
    label: 'Cookware',
    description: 'Cast iron, stainless steel, non-toxic',
    assetPath: AssetsData.cookware,
  ),
  CategoryOption(
    id: 'supplements',
    label: 'Supplements',
    description: 'Vitamins, herbal, natural oils',
    assetPath: AssetsData.supplements,
  ),
];

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final Set<String> _selected = <String>{};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GPSGaps.h24,
              const GpsHeader(
                title: 'Which categories are you interested in?',
              ).animate().fadeIn(duration: 300.ms).slideY(begin: .2, curve: Curves.easeOutQuad),
              GPSGaps.h24,

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final item = _categories[index];
                    final selected = _selected.contains(item.id);

                    final card = _AssetCategoryCard(
                      label: item.label,
                      description: item.description, // NEW
                      assetPath: item.assetPath,
                      selected: selected,
                      onTap: () => _toggle(item.id),
                    );

                    return card
                        .animate(delay: (80 * index).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: .15)
                        .scale(begin: const Offset(.98, .98), curve: Curves.easeOutBack);
                  },
                ),
              ),

              GPSGaps.h12,

              _Footer(
                onSkip: () => Navigator.of(context).pushNamed(AppRoutesNames.homeSearchScreen),
                onNext:
                    _selected.isNotEmpty
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${_selected.join(', ')}')),
                          );
                          Future.delayed(300.ms, () {
                            Navigator.of(context).pushNamed(AppRoutesNames.homeSearchScreen);
                          });
                        }
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetCategoryCard extends StatelessWidget {
  const _AssetCategoryCard({
    required this.label,
    required this.description,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description; // NEW
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? GPSColors.primary : GPSColors.cardBorder;
    final bg = selected ? GPSColors.cardSelected : Colors.white;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(assetPath, fit: BoxFit.contain, width: double.infinity, height: 70),
    );

    final card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image
                  .animate(target: selected ? 1 : 0)
                  .scaleXY(begin: 1, end: 1.04, duration: 180.ms),
              GPSGaps.h12,
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: GPSColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GPSGaps.h8,
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GPSColors.text.withOpacity(.70), // lighter
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return card
        .animate(onPlay: (c) => c.forward())
        .then()
        .shake(hz: selected ? 2 : 0, duration: selected ? 200.ms : 1.ms);
  }
}

// Same footer pattern you use
class _Footer extends StatelessWidget {
  const _Footer({required this.onSkip, required this.onNext});
  final VoidCallback onSkip;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final nextEnabled = onNext != null;

    return Row(
      children: [
        TextButton(
          onPressed: onSkip,
          child: const Text('Skip'),
        ).animate().fadeIn(duration: 250.ms).slideX(begin: -.1, curve: Curves.easeOut),
        const Spacer(),
        ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: nextEnabled ? GPSColors.primary : GPSColors.cardBorder,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Next'),
            )
            .animate(target: nextEnabled ? 1 : 0)
            .scaleXY(begin: 1.0, end: 1.03, duration: 300.ms, curve: Curves.easeInOut)
            .then(delay: 1200.ms)
            .tint(
              color: nextEnabled ? GPSColors.primary.withOpacity(.05) : Colors.transparent,
              duration: 500.ms,
            ),
      ],
    );
  }
}
