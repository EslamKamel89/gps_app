import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/capitalize.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/search/cubits/diets_cubit.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/user/preferences/models/diet_model.dart';

class DietsRowProvider extends StatelessWidget {
  const DietsRowProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DietsCubit()..diets(), child: const DietsRowWidget());
  }
}

class DietsRowWidget extends StatefulWidget {
  const DietsRowWidget({super.key});

  @override
  State<DietsRowWidget> createState() => _DietsRowWidgetState();
}

class _DietsRowWidgetState extends State<DietsRowWidget> {
  late final SearchCubit searchCubit;
  @override
  void initState() {
    searchCubit = context.read<SearchCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietsCubit, ApiResponseModel<List<DietModel>>>(
      builder: (context, state) {
        if (state.response == ResponseEnum.loading) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                List.generate(6, (i) => i).map((d) {
                  return FilterChip(
                    label: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      width: (context.width / 3) - 80,
                      height: 20,
                    ),
                    onSelected: (_) {},
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 500.ms);
                }).toList(),
          );
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              (state.data ?? []).map((d) {
                return FilterChip(
                  label: Text(
                    d.name?.toCapitalize ?? '',
                    style: TextStyle(
                      color: searchCubit.state.diet?.id == d.id ? Colors.white : null,
                    ),
                  ),
                  selected: searchCubit.state.diet?.id == d.id,
                  selectedColor: GPSColors.accent,
                  checkmarkColor: searchCubit.state.diet?.id == d.id ? Colors.white : null,
                  // backgroundColor:
                  // searchCubit.state.diet?.id == d.id ? GPSColors.accent : GPSColors.primary,
                  onSelected: (val) {
                    setState(() {
                      if (searchCubit.state.diet?.id == d.id) {
                        searchCubit.state.diet = null;
                      } else {
                        searchCubit.state.diet = d;
                      }
                      // pr()
                    });
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
