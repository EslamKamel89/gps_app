import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/filter_dialog.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_square_buttom.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SearchRow extends StatefulWidget {
  const SearchRow({super.key, this.hint = '', required this.onTap, required this.editable});

  final String hint;
  final VoidCallback? onTap;

  final bool editable;

  @override
  State<SearchRow> createState() => _SearchRowState();
}

bool _showMap = false;

class _SearchRowState extends State<SearchRow> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  HomeFilters? _filters;

  bool _showSuggestions = false;
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

  List<RestaurantSuggestion> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allRestaurants;
    return _allRestaurants.where((r) {
      return r.name.toLowerCase().contains(q) || r.address.toLowerCase().contains(q);
    }).toList();
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

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field =
        widget.editable
            ? TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: (v) {},
              decoration: _decoration(widget.hint).copyWith(
                prefixIcon: const Icon(Icons.search_rounded, color: GPSColors.primary),
                suffixIcon:
                    _searchCtrl.text.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close_rounded, color: GPSColors.mutedText),
                          // onPressed: widget.onClear,
                          onPressed: () {},
                        ),
              ),
            )
            : GestureDetector(
              // onTap: widget.onTap,
              onTap: () {
                if (widget.onTap != null) widget.onTap!();
                _enterSearchMode();
              },
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
                        widget.hint,
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
        if (!widget.editable) ...[
          GPSGaps.w12,
          RoundSquareButton(
            icon: Icons.tune_rounded,
            // onTap: widget.filtersOnTap
            onTap: () {},
          ),
        ],
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
