import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/place_card_skelton.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/suggestion_list.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';

class NearestVendors extends StatefulWidget {
  const NearestVendors({super.key});

  @override
  State<NearestVendors> createState() => _NearestVendorsState();
}

class _NearestVendorsState extends State<NearestVendors> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.allLocations?.response == ResponseEnum.loading ||
            (state.allLocations?.data ?? []).isEmpty == true) {
          return PlaceCardSkeletonList();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "📌 Nearest Locations",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GPSColors.text,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(duration: 250.ms).slideY(begin: .15),
            ),
            GPSGaps.h12,
            SuggestionsList(
              items: sortAndLimitSuggestions(state.allLocations?.data, 5),
              onSelect: (_) {},
              favorites: {},
              onToggleFavorite: (_) {},
              isScrollable: false,
            ),
          ],
        );
      },
    );
  }
}

List<SuggestionModel> sortAndLimitSuggestions(List<SuggestionModel>? suggestions, int limit) {
  if (suggestions == null || suggestions.isEmpty) {
    return [];
  }

  final sortedList = List<SuggestionModel>.from(suggestions)..sort((a, b) {
    final aDist = a.distance ?? double.infinity;
    final bDist = b.distance ?? double.infinity;
    return aDist.compareTo(bDist);
  });

  return sortedList.take(limit).toList();
}
