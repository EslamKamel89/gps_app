import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_square_buttom.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/presentation/filter_dialog.dart';

class SearchRow extends StatefulWidget {
  const SearchRow({super.key, this.hint = '', required this.onClear});

  final String hint;
  final VoidCallback onClear;

  @override
  State<SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  HomeFilters? _filters;

  bool _showSuggestions = false; // show the dropdown list

  void _onQueryChanged(String _) {
    final hasText = _searchCtrl.text.trim().isNotEmpty;
    // Once user starts typing, keep map visible and show suggestions
    setState(() {
      _showSuggestions = hasText;
    });
    if (!hasText) {
      widget.onClear();
    }
  }

  void _selectSuggestion(SuggestionModel value) {
    _searchCtrl.text = value.name; // keep UX consistent
    setState(() {
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();

    // Optional: navigate to details
    // Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
  }

  void _clearText() {
    _searchCtrl.clear();
    _exitSearchIfCleared();
    // Keep focus so user can type again
    _searchFocus.requestFocus();
  }

  void _exitSearchIfCleared() {
    if (_searchCtrl.text.trim().isEmpty) {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  // -------- Filters --------
  Future<void> _openFilters() async {
    HomeFilters? result;

    result = await showModalBottomSheet<HomeFilters>(
      context: context,
      builder: (_) {
        return FilterDialog(initial: _filters ?? HomeFilters());
      },
    );

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

  // -------- Demo data / filtering --------
  final List<SuggestionModel> _allSuggestions = const [
    SuggestionModel(
      id: 'rt-farm-to-fork',
      name: 'Farm to Fork',
      rating: 4.7,
      address: '241 Cedar Ave, Springfield',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 2.9,
    ),
    SuggestionModel(
      id: 'rt-greenhouse-cafe',
      name: 'Greenhouse Cafe',
      rating: 4.4,
      address: '88 Maple St, Brookfield',
      imageUrl:
          'https://images.unsplash.com/photo-1543353071-10c8ba85a904?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 3.0,
    ),
    SuggestionModel(
      id: 'rt-true-acre',
      name: 'True Acre',
      rating: 4.6,
      address: '19 Harvest Rd, Riverton',
      imageUrl:
          'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 1.4,
    ),
    SuggestionModel(
      id: 'rt-grass-grain',
      name: 'Grass & Grain',
      rating: 4.5,
      address: '501 Oak Blvd, Lakeside',
      imageUrl:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 0.8,
    ),
    SuggestionModel(
      id: 'rt-wild-catch-kitchen',
      name: 'Wild Catch Kitchen',
      rating: 4.3,
      address: '12 Marina Way, Bayshore',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 4.6,
    ),
    SuggestionModel(
      id: 'rt-roots-regenerative',
      name: 'Roots & Regenerative',
      rating: 4.8,
      address: '702 Orchard Ln, Meadowview',
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 2.1,
    ),
    SuggestionModel(
      id: 'rt-pure-pastures',
      name: 'Pure Pastures',
      rating: 4.2,
      address: '330 Willow Dr, Hillcrest',
      imageUrl:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1200&auto=format&fit=crop',
      distanceMiles: 3.8,
    ),
  ];

  List<SuggestionModel> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allSuggestions;
    return _allSuggestions.where((r) {
      return r.name.toLowerCase().contains(q) || r.address.toLowerCase().contains(q);
    }).toList();
  }

  Widget _buildFilters() {
    final f = _filters;
    final hasFilters =
        f != null &&
        (f.distance != null ||
            f.category != null ||
            f.subcategory != null ||
            f.diets.isNotEmpty == true);

    if (!hasFilters) return const SizedBox();

    return Column(
      children: [
        GPSGaps.h16,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (f.distance != null)
              InputChip(label: Text('Distance: ${f.distance}'), onDeleted: _clearDistance),
            if (f.category != null)
              InputChip(label: Text('Category: ${f.category}'), onDeleted: _clearCategory),
            if (f.subcategory != null)
              InputChip(label: Text('Sub: ${f.subcategory}'), onDeleted: _clearSubcategory),
            ...((f.diets ?? {}).map(
              (d) => InputChip(label: Text(d), onDeleted: () => _removeDiet(d)),
            )),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _searchCtrl,
      focusNode: _searchFocus,
      onChanged: _onQueryChanged,
      onSubmitted: (_) => setState(() => _showSuggestions = false),
      decoration: _decoration(widget.hint).copyWith(
        prefixIcon: const Icon(Icons.search_rounded, color: GPSColors.primary),
        suffixIcon:
            _searchCtrl.text.isEmpty
                ? null
                : IconButton(
                  icon: const Icon(Icons.close_rounded, color: GPSColors.mutedText),
                  onPressed: _clearText,
                ),
      ),
    );

    final searchRow = Row(
      children: [
        Expanded(child: field.animate().fadeIn(duration: 300.ms).slideY(begin: .1)),

        GPSGaps.w12,
        RoundSquareButton(icon: Icons.tune_rounded, onTap: () => _openFilters()),
      ],
    );

    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            searchRow,
            _buildFilters(),
            if (_showSuggestions) ...[
              GPSGaps.h8,
              // Your SuggestionList should support `items`, `onSelect`, maybe `onClose`
              SuggestionsList(
                items: _filtered,
                onSelect: _selectSuggestion,
                favorites: {},
                onToggleFavorite: (value) {},
                // onClose: () => setState(() => _showSuggestions = false),
              ),
            ],
          ],
        );
      },
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

class SearchRowPlaceholder extends StatelessWidget {
  const SearchRowPlaceholder({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
            ),
          ),
        ],
      ),
    );
  }
}
