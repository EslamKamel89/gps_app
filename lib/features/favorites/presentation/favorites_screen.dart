import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/favorites/models/favourtie_model.dart';
import 'package:gps_app/features/favorites/presentation/widgets/empty_state.dart';
import 'package:gps_app/features/favorites/presentation/widgets/favorite_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final List<FavoriteModel> _favorites;

  @override
  void initState() {
    super.initState();
    // Dummy Unsplash data (varied types)
    _favorites = [
      FavoriteModel(
        id: 1,
        favoriteType: 'restaurant',
        favoriteId: 101,
        user: UserModel(
          id: 1001,
          fullName: 'Layla Mahmoud',
          email: 'layla@example.com',
          mobile: '+20 100 123 4567',
          vendor: VendorModel(
            id: 501,
            vendorName: 'Nile Breeze Restaurant',
            address: '12 Corniche El Nile, Maadi, Cairo',
            seatingCapacity: 120,
          ),
          images: [
            ImageModel(
              id: 9001,
              path:
                  'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      FavoriteModel(
        id: 2,
        favoriteType: 'store',
        favoriteId: 102,
        user: UserModel(
          id: 1002,
          fullName: 'Omar Hassan',
          email: 'omar@example.com',
          mobile: '+20 122 555 7788',
          vendor: VendorModel(
            id: 502,
            vendorName: 'Green Valley Market',
            address: '45 El-Nozha St, Heliopolis, Cairo',
            seatingCapacity: null,
          ),
          images: [
            ImageModel(
              id: 9002,
              path:
                  'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      FavoriteModel(
        id: 3,
        favoriteType: 'farm',
        favoriteId: 103,
        user: UserModel(
          id: 1003,
          fullName: 'Sara Youssef',
          email: 'sara@example.com',
          mobile: '+20 111 222 3344',
          vendor: VendorModel(
            id: 503,
            vendorName: 'Al-Fayoum Organic Farm',
            address: 'Wadi El Rayan Rd, Fayoum',
            seatingCapacity: 30,
          ),
          images: [
            ImageModel(
              id: 9003,
              path:
                  'https://images.unsplash.com/photo-1500937386664-56f3d81d41b2?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      // One with no image to show fallback:
      FavoriteModel(
        id: 4,
        favoriteType: 'restaurant',
        favoriteId: 104,
        user: UserModel(
          id: 1004,
          fullName: 'Mostafa Adel',
          email: 'mostafa@example.com',
          mobile: '+20 109 888 9090',
          vendor: VendorModel(
            id: 504,
            vendorName: 'Koshary Corner',
            address: '15 Talaat Harb, Downtown, Cairo',
            seatingCapacity: 60,
          ),
          images: const [],
        ),
      ),
    ];
  }

  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        backgroundColor: GPSColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '💖 Favorites',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child:
            _favorites.isEmpty
                ? EmptyState()
                    .animate()
                    .fade(duration: 300.ms)
                    .move(
                      begin: const Offset(0, 12),
                      end: Offset.zero,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                : Column(
                  children: [
                    ..._favorites.indexed.map((entry) {
                      final i = entry.$1;
                      final fav = entry.$2;
                      return FavoriteCard(key: ValueKey('fav_$i'), favorite: fav)
                          .animate(delay: (50 * i).ms)
                          .fadeIn(duration: 300.ms)
                          .move(
                            begin: const Offset(0, 16),
                            end: Offset.zero,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          );
                    }),
                    GPSGaps.h24,
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

extension SeparatedBy on List<Widget> {
  List<Widget> separatedBy(Widget Function() separatorBuilder) {
    final out = <Widget>[];
    for (var i = 0; i < length; i++) {
      out.add(this[i]);
      if (i != length - 1) out.add(separatorBuilder());
    }
    return out;
  }
}
