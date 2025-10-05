import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/featured_resturant_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/filter_chip_row.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/filter_dialog.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/map/map.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/promo_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/resturant_list_item.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/search_row.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/categories_shortcut.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/design/widgets/most_loved_restaurants.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

HomeFilters? _filters;

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  int _currentTab = 0;

  Future<void> _openFilters({bool isBottomSheet = false}) async {
    HomeFilters? result;
    if (isBottomSheet) {
      result = await showModalBottomSheet<HomeFilters>(
        context: context,
        builder: (_) {
          return FilterDialog(initial: _filters ?? HomeFilters(), isBottomSheet: isBottomSheet);
        },
      );
    } else {
      result = await showDialog<HomeFilters>(
        context: context,
        builder: (_) => FilterDialog(initial: _filters ?? HomeFilters()),
      );
    }
    if (result != null) {
      setState(() => _filters = result);
    }
  }

  void _clearDistance() =>
      setState(() => _filters = (_filters ?? HomeFilters()).copyWith(distance: null));
  void _clearCategory() => setState(
    () => _filters = (_filters ?? HomeFilters()).copyWith(category: null, subcategory: null),
  );
  void _clearSubcategory() =>
      setState(() => _filters = (_filters ?? HomeFilters()).copyWith(subcategory: null));
  void _removeDiet(String d) {
    final f = _filters ?? HomeFilters();
    final next = Set<String>.from(f.diets)..remove(d);
    setState(() => _filters = f.copyWith(diets: next));
  }

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  bool _showMap = false;
  bool _showSuggestions = false;

  final List<RestaurantSuggestion> _allRestaurants = const [
    RestaurantSuggestion(
      id: 'rt-farm-to-fork',
      name: 'Farm to Fork',
      rating: 4.7,
      address: '241 Cedar Ave, Springfield',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 2.9,
    ),
    RestaurantSuggestion(
      id: 'rt-greenhouse-cafe',
      name: 'Greenhouse Cafe',
      rating: 4.4,
      address: '88 Maple St, Brookfield',
      imageUrl:
          'https://images.unsplash.com/photo-1543353071-10c8ba85a904?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 3.0,
    ),
    RestaurantSuggestion(
      id: 'rt-true-acre',
      name: 'True Acre',
      rating: 4.6,
      address: '19 Harvest Rd, Riverton',
      imageUrl:
          'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 1.4,
    ),
    RestaurantSuggestion(
      id: 'rt-grass-grain',
      name: 'Grass & Grain',
      rating: 4.5,
      address: '501 Oak Blvd, Lakeside',
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 0.8,
    ),
    RestaurantSuggestion(
      id: 'rt-wild-catch-kitchen',
      name: 'Wild Catch Kitchen',
      rating: 4.3,
      address: '12 Marina Way, Bayshore',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 4.6,
    ),
    RestaurantSuggestion(
      id: 'rt-roots-regenerative',
      name: 'Roots & Regenerative',
      rating: 4.8,
      address: '702 Orchard Ln, Meadowview',
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 2.1,
    ),
    RestaurantSuggestion(
      id: 'rt-pure-pastures',
      name: 'Pure Pastures',
      rating: 4.2,
      address: '330 Willow Dr, Hillcrest',
      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 3.8,
    ),
  ];
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
  final List<RestaurantItem> _mostLovedRestaurants = const [
    RestaurantItem(
      name: 'La Bella Vista',
      imageUrl:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1200&auto=format&fit=crop',
      rating: 4.8,
      cuisine: 'Italian',
    ),
    RestaurantItem(
      name: 'Sakura Sushi',
      imageUrl:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=1200&auto=format&fit=crop',
      rating: 4.9,
      cuisine: 'Japanese',
    ),
    RestaurantItem(
      name: 'El Fuego',
      imageUrl:
          'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?q=80&w=1200&auto=format&fit=crop',
      rating: 4.7,
      cuisine: 'Mexican',
    ),
    RestaurantItem(
      name: 'Le Petit Paris',
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1200&auto=format&fit=crop',
      rating: 4.6,
      cuisine: 'French',
    ),
    RestaurantItem(
      name: 'Spice Garden',
      imageUrl:
          'https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=1200&auto=format&fit=crop',
      rating: 4.5,
      cuisine: 'Indian',
    ),
    RestaurantItem(
      name: 'Coastal Grill',
      imageUrl:
          'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=1200&auto=format&fit=crop',
      rating: 4.8,
      cuisine: 'Seafood',
    ),
    RestaurantItem(
      name: 'Golden Wok',
      imageUrl:
          'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=1200&auto=format&fit=crop',
      rating: 4.4,
      cuisine: 'Chinese',
    ),
    RestaurantItem(
      name: 'Mediterranean Breeze',
      imageUrl:
          'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?q=80&w=1200&auto=format&fit=crop',
      rating: 4.7,
      cuisine: 'Mediterranean',
    ),
  ];
  List<RestaurantSuggestion> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allRestaurants;
    return _allRestaurants.where((r) {
      return r.name.toLowerCase().contains(q) || r.address.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _enterSearchMode() {
    if (!_showMap) {
      setState(() {
        _showMap = true;
        _showSuggestions = _searchCtrl.text.trim().isNotEmpty;
      });
    }
    _searchFocus.requestFocus();
  }

  void _onQueryChanged(String _) {
    final hasText = _searchCtrl.text.trim().isNotEmpty;
    setState(() {
      _showMap = hasText || _showMap;
      _showSuggestions = hasText;
    });
  }

  void _selectSuggestion(RestaurantSuggestion value) {
    _searchCtrl.text = value.name; // keep UX consistent
    setState(() {
      _showSuggestions = false;
      _showMap = true;
    });
    FocusScope.of(context).unfocus();

    // Optional: navigate to details here if desired
    // Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
  }

  void _exitSearchIfCleared() {
    if (_searchCtrl.text.trim().isEmpty) {
      setState(() {
        _showSuggestions = false;
        _showMap = false;
      });
    }
  }

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
                          controller: _searchCtrl,
                          focusNode: _searchFocus,
                          editable: false,
                          hint: 'Search by district or restaurant name',
                          onTap: _enterSearchMode,
                          filtersOnTap: () => _openFilters(isBottomSheet: true),
                          onChanged: _onQueryChanged,
                          onClear: () {
                            _searchCtrl.clear();
                            _exitSearchIfCleared();
                          },
                        ),
                        SizedBox(child: _buildFilters()),
                        GPSGaps.h16,
                        const FilterChipsRow(),
                        GPSGaps.h16,
                        CategoryShortcutWidget(items: _shortcutItems),
                        GPSGaps.h16,
                        MostLovedRestaurantsWidget(items: _mostLovedRestaurants),
                        GPSGaps.h20,
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
                          Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
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
                        controller: _searchCtrl,
                        focusNode: _searchFocus,
                        editable: true,
                        hint: 'Search by city or zip code',
                        onTap: _enterSearchMode,
                        onChanged: _onQueryChanged,
                        onClear: () {
                          _searchCtrl.clear();
                          _searchFocus.requestFocus();
                          _exitSearchIfCleared();
                        },
                      ),
                    ),
                    _buildFilters(),
                    AnimatedSwitcher(
                      duration: 200.ms,
                      child:
                          _showSuggestions
                              ? Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: SuggestionsList(
                                  items: _filtered,
                                  onSelect: _selectSuggestion,
                                  favorites: {},
                                  onToggleFavorite: (_) {},
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
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

  Widget _buildFilters() {
    return (_filters != null &&
            (_filters?.distance != null ||
                _filters?.category != null ||
                _filters?.subcategory != null ||
                _filters?.diets.isNotEmpty == true))
        ? Column(
          children: [
            GPSGaps.h16,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_filters?.distance != null)
                  InputChip(
                    label: Text('Distance: ${_filters?.distance}'),
                    onDeleted: _clearDistance,
                  ),
                if (_filters?.category != null)
                  InputChip(
                    label: Text('Category: ${_filters?.category}'),
                    onDeleted: _clearCategory,
                  ),
                if (_filters?.subcategory != null)
                  InputChip(
                    label: Text('Sub: ${_filters?.subcategory}'),
                    onDeleted: _clearSubcategory,
                  ),
                ...(_filters?.diets ?? {}).map(
                  (d) => InputChip(label: Text(d), onDeleted: () => _removeDiet(d)),
                ),
              ],
            ),
          ],
        )
        : SizedBox();
  }
}
