import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/featured_resturant_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/incomple_profile_model.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/map/map.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/promo_card.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/resturant_list_item.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_square_buttom.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/top_bar.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/search/presentation/search_row.dart';
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

  bool _showMap = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                        TopBar(),

                        GPSGaps.h16,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showMap = true;
                              });
                            },
                            child: SearchRowPlaceholder(hint: 'Search....'),
                          ),
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
                  child: SizedBox(child: Stack(fit: StackFit.expand, children: [MapView()])),
                ),
              ).animate().fadeIn(duration: 220.ms),

              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TopBar(
                      action: RoundSquareButton(
                        icon: Icons.arrow_back_ios,
                        color: Colors.white,
                        onTap:
                            () => setState(() {
                              _showMap = false;
                            }),
                      ),
                    ),
                    GPSGaps.h16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchRow(
                        hint: 'Search.....',
                        closeSearch: () {
                          setState(() {
                            setState(() {
                              _showMap = false;
                            });
                          });
                        },
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
