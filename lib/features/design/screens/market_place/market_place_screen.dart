import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  static const _products = [
    {
      'name': 'Organic Coffee Beans',
      'desc': 'Freshly roasted, medium roast.',
      'price': 14.99,
      'image': 'https://picsum.photos/seed/coffee/600/400',
    },
    {
      'name': 'Raw Honey Jar',
      'desc': '100% pure, harvested locally.',
      'price': 12.49,
      'image': 'https://picsum.photos/seed/honey/600/400',
    },
    {
      'name': 'California Medjool Dates',
      'desc': 'Large, sweet, and chewy.',
      'price': 9.99,
      'image': 'https://picsum.photos/seed/dates/600/400',
    },
    {
      'name': 'Extra Virgin Olive Oil',
      'desc': 'Cold-pressed, imported from Spain.',
      'price': 18.75,
      'image': 'https://picsum.photos/seed/oliveoil/600/400',
    },
    {
      'name': 'BBQ Spice Blend',
      'desc': 'Chef’s choice mix for grilling.',
      'price': 6.50,
      'image': 'https://picsum.photos/seed/spices/600/400',
    },
    {
      'name': 'Premium Basmati Rice',
      'desc': 'Long grain, aromatic flavor.',
      'price': 15.25,
      'image': 'https://picsum.photos/seed/rice/600/400',
    },
  ];

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  int _currentTab = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(title: 'Market'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: MarketPlaceScreen._products.length,
                  itemBuilder: (context, index) {
                    final p = MarketPlaceScreen._products[index];
                    return _ProductCard(
                      name: p['name'] as String,
                      desc: p['desc'] as String,
                      price: p['price'] as double,
                      imageUrl: p['image'] as String,
                      onAdd: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added: ${p['name']}'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                      },
                    ).animate().fadeIn(duration: 200.ms).scaleXY(begin: 0.98);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GPSBottomNav(
        currentIndex: _currentTab,
        onChanged: (i) {
          setState(() => _currentTab = i);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
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
