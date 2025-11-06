import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/category_card.dart';
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

const _categories = <CategoryOption>[
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
];

class MarketCategorySelectionScreen extends StatefulWidget {
  const MarketCategorySelectionScreen({super.key});

  @override
  State<MarketCategorySelectionScreen> createState() => _MarketCategorySelectionScreenState();
}

class _MarketCategorySelectionScreenState extends State<MarketCategorySelectionScreen> {
  final Set<String> _selected = <String>{};
  int _currentTab = 1;

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: GPSColors.background,
        body:
            false
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TopBar(title: 'Pick Categories?')
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: .2, curve: Curves.easeOutQuad),

                    // const GpsHeader(
                    //   title: 'Which categories are you interested in?',
                    // ).animate().fadeIn(duration: 300.ms).slideY(begin: .2, curve: Curves.easeOutQuad),
                    // GPSGaps.h24,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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

                            final card = CategoryCard(
                              label: item.label,
                              description: item.description, // NEW
                              imageUrl: item.assetPath,
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
                    ),

                    GPSGaps.h12,

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Footer(
                        onSkip:
                            () => Navigator.of(context).pushNamed(AppRoutesNames.marketPlaceScreen),
                        onNext:
                            _selected.isNotEmpty
                                ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Selected: ${_selected.join(', ')}')),
                                  );
                                  Future.delayed(300.ms, () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(AppRoutesNames.marketPlaceScreen);
                                  });
                                }
                                : null,
                      ),
                    ),
                    GPSGaps.h12,
                  ],
                )
                : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'This functionality is currently in development and will be available in a future update.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        bottomNavigationBar: GPSBottomNav(
          currentIndex: _currentTab,
          onChanged: (i) {
            setState(() => _currentTab = i);
          },
        ),
      ),
    );
  }
}
