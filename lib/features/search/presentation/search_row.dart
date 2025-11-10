import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_square_buttom.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/presentation/filter_dialog.dart';
import 'package:gps_app/features/search/presentation/filters_row.dart';

class SearchRow extends StatefulWidget {
  const SearchRow({super.key, this.hint = '', required this.closeSearch});

  final String hint;
  final VoidCallback closeSearch;

  @override
  State<SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late final SearchCubit cubit;

  @override
  void initState() {
    cubit = context.read<SearchCubit>();
    super.initState();
  }

  void _onQueryChanged(String s) {
    cubit.state.search = s;
    final hasText = _searchCtrl.text.trim().isNotEmpty;
    if (hasText) {
      cubit.search();
    } else {
      cubit.update();
    }
  }

  void _clearText() {
    _searchCtrl.clear();
    _exitSearchIfCleared();
    _searchFocus.requestFocus();
  }

  void _exitSearchIfCleared() {
    if (_searchCtrl.text.trim().isEmpty) {}
  }

  Future<void> _openFilters() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(child: FilterDialog());
      },
    );
    cubit.update();
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
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextButton(
            //   onPressed: () {
            //     pr(state, 'state');
            //   },
            //   child: Text('test'),
            // ),
            searchRow,
            FiltersRow(),

            GPSGaps.h8,
            if (pr(state.search, 'search value')?.isNotEmpty == true)
              SuggestionsList(
                items: state.suggestions?.data ?? [],
                onSelect: (_) {},
                favorites: {},
                onToggleFavorite: (value) {},
                // onClose: () => setState(() => _showSuggestions = false),
              ),
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
