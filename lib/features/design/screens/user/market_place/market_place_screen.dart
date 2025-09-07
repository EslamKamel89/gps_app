import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/screens/user/market_place/widgets/product_card.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  int _currentTab = 1;
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            const TopBar(title: 'Market'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final p = _products[index];
                    return ProductCard(
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
