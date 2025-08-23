import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
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
  static const _items = <_FoodItem>[
    _FoodItem(
      id: 'pizza',
      name: 'Pizza',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    _FoodItem(
      id: 'burger',
      name: 'Burger',
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1200',
    ),
    _FoodItem(
      id: 'sushi',
      name: 'Sushi',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1200',
    ),
    _FoodItem(
      id: 'pasta',
      name: 'Pasta',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    _FoodItem(
      id: 'salad',
      name: 'Salad',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1673590981774-d9f534e0c617?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    _FoodItem(
      id: 'steak',
      name: 'Steak',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=1200',
    ),
    _FoodItem(
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
              _Header(title: 'Select your foods', subtitle: 'Pick as many as you like'),
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
                    return _FoodCard(
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

class _FoodItem {
  final String id;
  final String name;
  final String imageUrl;
  const _FoodItem({required this.id, required this.name, required this.imageUrl});
}

class _Header extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _Header({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: t.bodyMedium?.copyWith(color: t.bodyMedium?.color?.withOpacity(0.7)),
          ),
        ],
      ],
    );
  }
}

class _FoodCard extends StatelessWidget {
  final _FoodItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color borderSelected;
  final Color borderNormal;
  final Color selectedTint;

  const _FoodCard({
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
                      child: const _DotsLoader(),
                    );
                  },
                  errorBuilder: (context, error, stack) => _ImageErrorFallback(name: item.name),
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
                      _CheckBadge(isSelected: isSelected),
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

class _CheckBadge extends StatelessWidget {
  final bool isSelected;
  const _CheckBadge({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? Theme.of(context).colorScheme.primary : Colors.white70;
    final fg = isSelected ? Colors.white : Colors.black87;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: 28,
      height: 28,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Icon(isSelected ? Icons.check : Icons.add, size: 18, color: fg),
    );
  }
}

class _ImageErrorFallback extends StatelessWidget {
  final String name;
  const _ImageErrorFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_not_supported_outlined, size: 32),
          const SizedBox(height: 6),
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();
  @override
  void dispose() => _c.dispose();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = (_c.value * 3).floor() % 3;
        return Text('.' * (v + 1), style: Theme.of(context).textTheme.titleLarge);
      },
    );
  }
}
