import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/food_selection/widgets/food_card.dart';
import 'package:gps_app/features/design/screens/user/food_selection/widgets/header.dart';
import 'package:gps_app/features/design/widgets/footer.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({super.key});

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  // Keep selection minimal in parent
  final Set<String> _selected = <String>{};

  // Example data — replace with your real categories and image URLs
  static const _items = <FoodItem>[
    FoodItem(
      id: 'pizza',
      name: 'Pizza',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    FoodItem(
      id: 'burger',
      name: 'Burger',
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1200',
    ),
    FoodItem(
      id: 'sushi',
      name: 'Sushi',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1200',
    ),
    FoodItem(
      id: 'pasta',
      name: 'Pasta',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    FoodItem(
      id: 'salad',
      name: 'Salad',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1673590981774-d9f534e0c617?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    FoodItem(
      id: 'steak',
      name: 'Steak',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=1200',
    ),
    FoodItem(
      id: 'tacos',
      name: 'Tacos',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1661730329741-b3bf77019b39?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
  ];

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

    // Replace these with your design tokens if you have them
    const double hPad = 16;
    const double vPad = 16;
    const double gap = 12;
    final Color selectedTint = theme.colorScheme.primary.withOpacity(0.18);
    final Color borderSelected = theme.colorScheme.primary;
    final Color borderNormal = theme.dividerColor.withOpacity(0.2);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(title: 'Select your foods', subtitle: 'Pick as many as you like'),
              const SizedBox(height: gap),
              Expanded(
                child: GridView.builder(
                  itemCount: _items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isSelected = _selected.contains(item.id);
                    return FoodCard(
                      key: ValueKey(item.id), // semantic/stable id
                      item: item,
                      isSelected: isSelected,
                      onTap: () => _toggle(item.id),
                      borderSelected: borderSelected,
                      borderNormal: borderNormal,
                      selectedTint: selectedTint,
                    );
                  },
                ),
              ),
              const SizedBox(height: gap),
              Footer(
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
