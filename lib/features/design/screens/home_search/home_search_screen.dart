import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/featured_resturant_card.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/filter_chip_row.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/promo_card.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/resturant_list_item.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/search_row.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/screens/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/design/widgets/restrunats_shortcut.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  int _currentTab = 0;

  // Map/search overlay state
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  bool _showMap = false; // becomes true when user starts typing or taps search
  bool _showSuggestions = false; // visible while typing and query not empty

  // Dummy suggestion data
  final List<String> _allRestaurants = const [
    'Farm to Fork',
    'Greenhouse Cafe',
    'True Acre',
    'Grass & Grain',
    'Wild Catch Kitchen',
    'Roots & Regenerative',
    'Pure Pastures',
  ];
  // NEW: demo images for the shortcut row (replace with your assets or CDN)
  final List<RestaurantMini> _shortcutItems = const [
    RestaurantMini(
      name: 'Farm to Fork',
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1200&auto=format&fit=crop',
    ),
    RestaurantMini(
      name: 'Greenhouse Cafe',
      imageUrl:
          'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1200&auto=format&fit=crop',
    ),
    RestaurantMini(
      name: 'True Acre',
      imageUrl:
          'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?q=80&w=1200&auto=format&fit=crop',
    ),
    RestaurantMini(
      name: 'Roots & Regenerative',
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?q=80&w=1200&auto=format&fit=crop',
    ),
    RestaurantMini(
      name: 'Wild Catch',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop',
    ),
    RestaurantMini(
      name: 'Pure Pastures',
      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1200&auto=format&fit=crop',
    ),
  ];

  List<String> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allRestaurants;
    return _allRestaurants.where((r) => r.toLowerCase().contains(q)).toList();
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
      _showMap = hasText || _showMap; // once shown, keep it unless explicitly cleared
      _showSuggestions = hasText;
    });
  }

  void _selectSuggestion(String value) {
    _searchCtrl.text = value;
    setState(() {
      _showSuggestions = false; // hide list
      _showMap = true; // keep map visible
    });
    // Close keyboard
    FocusScope.of(context).unfocus();
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
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: Stack(
        children: [
          SizedBox(width: context.width, height: context.height),
          if (!_showMap)
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TopBar(),
                        GPSGaps.h16,
                        SearchRow(
                          controller: _searchCtrl,
                          focusNode: _searchFocus,
                          editable: false,
                          hint: 'Search by city or zip code',
                          onTap: _enterSearchMode,
                          onChanged: _onQueryChanged,
                          onClear: () {
                            _searchCtrl.clear();
                            _exitSearchIfCleared();
                          },
                        ),
                        GPSGaps.h16,
                        const FilterChipsRow(),
                        GPSGaps.h16,
                        RestrunatsShortcut(items: _shortcutItems),
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
            ),

          // Map overlay (when typing / after selection)
          if (_showMap) ...[
            // Map image as full background; whole map is tappable → go to details
            Positioned(
              bottom: 0,
              top: 0,
              child: SizedBox(
                width: context.width,
                height: context.height,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus(); // just in case
                    Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Replace with GoogleMap later — for now a static map with markers vibe
                      Image.network(
                        // royalty-free looking map w/ markers vibe
                        'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/3:2/w_2240,c_limit/GoogleMapTA.jpg',
                        fit: BoxFit.cover,
                        width: context.width,
                        height: context.height,
                      ),
                      // slight vignette so top UI remains readable
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(.20),
                              Colors.transparent,
                              Colors.black.withOpacity(.15),
                            ],
                          ),
                        ),
                      ),
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
                  // Suggestions list
                  AnimatedSwitcher(
                    duration: 200.ms,
                    child:
                        _showSuggestions
                            ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                              child: SuggestionsList(items: _filtered, onSelect: _selectSuggestion),
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
    );
  }
}
