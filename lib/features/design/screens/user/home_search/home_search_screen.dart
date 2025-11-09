import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/featured_resturant_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/incomple_profile_model.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/map/map.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/promo_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/resturant_list_item.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/categories_shortcut.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/search/presentation/search_row.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_main_data.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/most_loved_restaurants.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/most_loved_stores.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
    handleIncompleteProfile();
  }

  final List<CategoryItem> _shortcutItems = const [
    CategoryItem(
      name: 'Farm to Fork',
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1200&auto=format&fit=crop',
    ),
    CategoryItem(
      name: 'Greenhouse Cafe',
      imageUrl:
          'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1200&auto=format&fit=crop',
    ),
    CategoryItem(
      name: 'True Acre',
      imageUrl:
          'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?q=80&w=1200&auto=format&fit=crop',
    ),
    CategoryItem(
      name: 'Roots & Regenerative',
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?q=80&w=1200&auto=format&fit=crop',
    ),
    CategoryItem(
      name: 'Wild Catch',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop',
    ),
    CategoryItem(
      name: 'Pure Pastures',
      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1200&auto=format&fit=crop',
    ),
  ];
  final List<RestaurantMainData> _mostLovedRestaurants = [
    RestaurantMainData(
      vendorName: 'La Bella Vista',
      path:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.8,
      // cuisine: 'Italian',
    ),
    RestaurantMainData(
      vendorName: 'Sakura Sushi',
      path:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.9,
      // cuisine: 'Japanese',
    ),
    RestaurantMainData(
      vendorName: 'El Fuego',
      path:
          'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.7,
      // cuisine: 'Mexican',
    ),
    RestaurantMainData(
      vendorName: 'Le Petit Paris',
      path:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.6,
      // cuisine: 'French',
    ),
    RestaurantMainData(
      vendorName: 'Spice Garden',
      path:
          'https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.5,
      // cuisine: 'Indian',
    ),
    RestaurantMainData(
      vendorName: 'Coastal Grill',
      path:
          'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.8,
      // cuisine: 'Seafood',
    ),
    RestaurantMainData(
      vendorName: 'Golden Wok',
      path:
          'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.4,
      // cuisine: 'Chinese',
    ),
    RestaurantMainData(
      vendorName: 'Mediterranean Breeze',
      path:
          'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?q=80&w=1200&auto=format&fit=crop',
      // rating: 4.7,
      // cuisine: 'Mediterranean',
    ),
  ];
  bool _showMap = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: GPSColors.background,
        body: Stack(
          children: [
            SizedBox(width: context.width, height: context.height),
            if (!_showMap)
              CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TopBar(),

                        GPSGaps.h16,
                        SearchRow(
                          // controller: _searchCtrl,
                          // focusNode: _searchFocus,
                          editable: false,
                          hint: 'Search.....',
                          onTap: () {
                            setState(() {
                              _showMap = true;
                            });
                          },
                          // filtersOnTap: () => _openFilters(isBottomSheet: true),
                          // onChanged: _onQueryChanged,
                          // onClear: () {
                          //   _searchCtrl.clear();
                          //   _exitSearchIfCleared();
                          // },
                        ),
                        // SizedBox(child: _buildFilters()),
                        // GPSGaps.h16,
                        // const FilterChipsRow(),
                        GPSGaps.h16,
                        // CategoryShortcutWidget(items: _shortcutItems),
                        // GPSGaps.h16,
                        MostLovedRestaurantsProvider(),
                        MostLovedStoresProvider(isStore: true),
                        MostLovedStoresProvider(isStore: false),
                        // GPSGaps.h20,
                        const PromoCard(),
                        GPSGaps.h20,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Farm to Fork',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: GPSColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ).animate().fadeIn(duration: 300.ms).slideY(begin: .2),
                        ),
                        GPSGaps.h12,
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      FeaturedRestaurantCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailProvider(enableEdit: false),
                            ),
                          );
                        },
                      ),
                      GPSGaps.h12,
                      RestaurantListItem(
                        title: 'Farm to Fork',
                        subtitle: '100% grass-fed or organic, gluten free',
                        time: '45–10 min',
                        distance: '2.9 mi',
                        verified: true,
                        imageUrl:
                            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1200&auto=format&fit=crop',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
                        },
                      ),
                      GPSGaps.h12,
                      RestaurantListItem(
                        title: 'Greenhouse Cafe',
                        subtitle: '100% organic, gluten free',
                        time: '30–1 hr',
                        distance: '3.0 mi',
                        verified: false,
                        imageUrl:
                            'https://images.unsplash.com/photo-1543353071-10c8ba85a904?q=80&w=1200&auto=format&fit=crop',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
                        },
                      ),
                      GPSGaps.h24,
                      GPSGaps.h24,
                    ]),
                  ),
                ],
              ),
            if (_showMap) ...[
              Positioned(
                bottom: 0,
                top: 0,
                child: SizedBox(
                  width: context.width,
                  height: context.height,
                  child: SizedBox(
                    // onTap: () {
                    //   FocusScope.of(context).unfocus();
                    //   Navigator.of(
                    //     context,
                    //   ).pushNamed(AppRoutesNames.restaurantDetailScreen);
                    // },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image.network(
                        //   'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/3:2/w_2240,c_limit/GoogleMapTA.jpg',
                        //   fit: BoxFit.cover,
                        //   width: context.width,
                        //   height: context.height,
                        // ),
                        MapView(),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       begin: Alignment.topCenter,
                        //       end: Alignment.bottomCenter,
                        //       colors: [
                        //         Colors.black.withOpacity(.20),
                        //         Colors.transparent,
                        //         Colors.black.withOpacity(.15),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 220.ms),

              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TopBar(),
                    GPSGaps.h16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchRow(
                        // controller: _searchCtrl,
                        // focusNode: _searchFocus,
                        editable: true,
                        hint: 'Search.....',

                        onTap: () {
                          setState(() {
                            _showMap = true;
                          });
                        },
                        // onChanged: _onQueryChanged,
                        // onClear: () {
                        //   _searchCtrl.clear();
                        //   _searchFocus.requestFocus();
                        //   _exitSearchIfCleared();
                        // },
                      ),
                    ),

                    // _buildFilters(),
                    // AnimatedSwitcher(
                    //   duration: 200.ms,
                    //   child:
                    //       _showSuggestions
                    //           ? Padding(
                    //             padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    //             child: SuggestionsList(
                    //               items: _filtered,
                    //               onSelect: _selectSuggestion,
                    //               favorites: {},
                    //               onToggleFavorite: (_) {},
                    //             ),
                    //           )
                    //           : const SizedBox.shrink(),
                    // ),
                  ],
                ),
              ),
            ],
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
