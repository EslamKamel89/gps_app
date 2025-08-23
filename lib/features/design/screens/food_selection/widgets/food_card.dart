import 'package:flutter/material.dart';
import 'package:gps_app/features/design/screens/food_selection/widgets/check_badge.dart';
import 'package:gps_app/features/design/screens/food_selection/widgets/dots_loader.dart';
import 'package:gps_app/features/design/screens/food_selection/widgets/image_error_fallback.dart';

class FoodItem {
  final String id;
  final String name;
  final String imageUrl;
  const FoodItem({required this.id, required this.name, required this.imageUrl});
}

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color borderSelected;
  final Color borderNormal;
  final Color selectedTint;

  const FoodCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.borderSelected,
    required this.borderNormal,
    required this.selectedTint,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.name,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isSelected ? borderSelected : borderNormal,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? selectedTint : null,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Network image with graceful loading/error
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  // Simple skeleton/placeholder using Container color during load
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      alignment: Alignment.center,
                      child: const DotsLoader(),
                    );
                  },
                  errorBuilder: (context, error, stack) => ImageErrorFallback(name: item.name),
                ),

                // Subtle gradient overlay for text readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.35)],
                      ),
                    ),
                  ),
                ),

                // Title + check
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CheckBadge(isSelected: isSelected),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
