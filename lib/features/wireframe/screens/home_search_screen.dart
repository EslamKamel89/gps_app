import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';
import 'package:gps_app/features/wireframe/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/wireframe/widgets/restrunats_shortcut.dart';
import 'package:gps_app/utils/assets/assets.dart';

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
                        const _TopBar(),
                        GPSGaps.h16,
                        _SearchRow(
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
                        const _FilterChipsRow(),
                        GPSGaps.h16,
                        RestrunatsShortcut(items: _shortcutItems),
                        GPSGaps.h20,
                        const _PromoCard(),
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
                      _FeaturedRestaurantCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
                        },
                      ),
                      GPSGaps.h12,
                      _RestaurantListItem(
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
                      _RestaurantListItem(
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
                  const _TopBar(),
                  GPSGaps.h16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SearchRow(
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
                              child: _SuggestionsList(
                                items: _filtered,
                                onSelect: _selectSuggestion,
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
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: GPSColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          _RoundIcon(icon: Icons.menu_rounded, onTap: () {}),
          GPSGaps.w12,
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsData.logo3d, width: 30, height: 30),
                GPSGaps.w4,
                Text(
                  'GPS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
              ],
            ),
          ),
          GPSGaps.w12,
          _RoundIcon(icon: Icons.person_outline, onTap: () {}),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: -.2, curve: Curves.easeOut);
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ).animate().fadeIn().scale(begin: const Offset(.95, .95)),
    );
  }
}

/// Search row used in both feed mode (non-editable) and map mode (editable)
class _SearchRow extends StatelessWidget {
  const _SearchRow({
    this.hint = '',
    this.onTap,
    this.onChanged,
    this.onClear,
    required this.controller,
    required this.focusNode,
    required this.editable,
  });

  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final field =
        editable
            ? TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: _decoration(hint).copyWith(
                prefixIcon: const Icon(Icons.search_rounded, color: GPSColors.primary),
                suffixIcon:
                    controller.text.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close_rounded, color: GPSColors.mutedText),
                          onPressed: onClear,
                        ),
              ),
            )
            : GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EFE9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: GPSColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: GPSColors.primary),
                    GPSGaps.w12,
                    Expanded(
                      child: Text(
                        hint,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                      ),
                    ),
                  ],
                ),
              ),
            );

    return Row(
      children: [
        Expanded(child: field.animate().fadeIn(duration: 300.ms).slideY(begin: .1)),
        if (!editable) ...[GPSGaps.w12, _RoundSquareButton(icon: Icons.tune_rounded, onTap: () {})],
      ],
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.primary, width: 1.6),
      ),
    );
  }
}

class _RoundSquareButton extends StatelessWidget {
  const _RoundSquareButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EFE9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Icon(icon, color: GPSColors.primary),
      ),
    ).animate().fadeIn().scale(begin: const Offset(.95, .95));
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChipPill(label: 'Filters', icon: Icons.filter_list, onTap: () {}),
          GPSGaps.w12,
          const _TagChip(label: '100% Grass-fed'),
          GPSGaps.w12,
          const _TagChip(label: 'Organic'),
        ].animate(interval: 80.ms).fadeIn(duration: 280.ms).slideX(begin: .1),
      ),
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  const _FilterChipPill({required this.label, this.icon, this.onTap});
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 18, color: GPSColors.primary), GPSGaps.w8],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EFE9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: GPSColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: GPSColors.primary,
          borderRadius: BorderRadius.circular(18),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?q=80&w=1200&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              right: 16,
              child: Text(
                'Earn Points with Verified Restaurants',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: GPSColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: const Text('Learn more'),
              ).animate().fadeIn(duration: 250.ms).slideX(begin: -.1),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).slideY(begin: .1).shimmer(delay: 1200.ms, duration: 1200.ms),
    );
  }
}

class _FeaturedRestaurantCard extends StatelessWidget {
  const _FeaturedRestaurantCard({required this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1466637574441-749b8f19452f?q=80&w=1200&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _VerifiedBadge(verified: true),
                        GPSGaps.w8,
                        Text(
                          'GPS Verified',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: GPSColors.mutedText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    GPSGaps.h8,
                    Text(
                      'Farm to Fork',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GPSGaps.h8,
                    _MetaRow(time: '45–10 min', distance: '2.9 mi'),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 320.ms).slideY(begin: .1),
      ),
    );
  }
}

class _RestaurantListItem extends StatelessWidget {
  const _RestaurantListItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.distance,
    required this.verified,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String time;
  final String distance;
  final bool verified;
  final String imageUrl;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (verified) const _VerifiedBadge(verified: true),
                          if (verified) ...[
                            GPSGaps.w8,
                            Text(
                              'GPS Verified',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: GPSColors.mutedText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                      GPSGaps.h8,
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GPSGaps.h8,
                      Text(
                        subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: GPSColors.mutedText),
                      ),
                      GPSGaps.h8,
                      _MetaRow(time: time, distance: distance),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 320.ms).slideX(begin: .1),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.verified});
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.ms,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified ? GPSColors.cardSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 16,
            color: verified ? GPSColors.primary : GPSColors.mutedText,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.time, required this.distance});
  final String time;
  final String distance;

  @override
  Widget build(BuildContext context) {
    TextStyle s = Theme.of(
      context,
    ).textTheme.labelMedium!.copyWith(color: GPSColors.mutedText, fontWeight: FontWeight.w600);
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: GPSColors.mutedText),
        GPSGaps.w8,
        Text(time, style: s),
        GPSGaps.w12,
        const Icon(Icons.place_rounded, size: 16, color: GPSColors.mutedText),
        GPSGaps.w8,
        Text(distance, style: s),
      ],
    );
  }
}

/// Suggestions dropdown used in search overlay
class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({required this.items, required this.onSelect});
  final List<String> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: _box,
        padding: const EdgeInsets.all(14),
        child: Text(
          'No matches. Try a different term.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 150.ms);
    }

    return Container(
      decoration: _box,
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: GPSColors.cardBorder),
        itemBuilder: (context, i) {
          final label = items[i];
          return InkWell(
            onTap: () => onSelect(label),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.place_rounded, size: 18, color: GPSColors.primary),
                  GPSGaps.w12,
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 180.ms).slideY(begin: -.06);
  }

  BoxDecoration get _box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: GPSColors.cardBorder),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 16, offset: const Offset(0, 6)),
    ],
  );
}
