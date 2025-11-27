import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';
import 'package:gps_app/features/user/preferences/cubits/preferences/preferences_cubit.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/diet_card.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/diet_loading_placeholder.dart';

class DietSelectionScreen extends StatefulWidget {
  const DietSelectionScreen({super.key});

  @override
  State<DietSelectionScreen> createState() => _DietSelectionScreenState();
}

class _DietSelectionScreenState extends State<DietSelectionScreen> {
  late PreferencesCubit cubit;

  @override
  void initState() {
    cubit = context.read<PreferencesCubit>();
    cubit.dietsIndex();
    super.initState();
  }

  String search = '';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferencesCubit, PreferencesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final diets =
            state.diets.data
                ?.where(
                  (c) =>
                      c.name?.toLowerCase().trim().contains(
                        search.toLowerCase().trim(),
                      ) ==
                      true,
                )
                .toList() ??
            [];
        return Scaffold(
          backgroundColor: GPSColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GPSGaps.h24,
                  GpsHeader(
                        title: 'Which of these diets do you follow?',
                        // onBack: () => Navigator.of(context).maybePop(),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: .2, curve: Curves.easeOutQuad),
                  GPSGaps.h24,
                  TextFormField(
                    onChanged: (v) {
                      setState(() {
                        search = v;
                      });
                    },
                    decoration: InputDecoration(hintText: 'Search...'),
                  ),
                  GPSGaps.h12,
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.diets.response == ResponseEnum.loading) {
                          return GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 1.05,
                                ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return DietCardPlaceholder()
                                  .animate(delay: (80 * index).ms)
                                  .fadeIn(duration: 300.ms)
                                  .slideY(begin: .15)
                                  .scale(
                                    begin: const Offset(0.98, 0.98),
                                    curve: Curves.easeOutBack,
                                  );
                            },
                          );
                        }
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.05,
                              ),
                          itemCount: diets.length,
                          itemBuilder: (context, index) {
                            final diet = diets[index];
                            final card = DietCard(
                              diet: diet,
                              selected:
                                  state.selectedDiets
                                      .where((d) => d.id == diet.id)
                                      .isNotEmpty,
                              onTap: () {
                                cubit.toggleSelectedDiet(diet);
                              },
                            );

                            return card
                                .animate(delay: (80 * index).ms)
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: .15)
                                .scale(
                                  begin: const Offset(0.98, 0.98),
                                  curve: Curves.easeOutBack,
                                );
                          },
                        );
                      },
                    ),
                  ),

                  GPSGaps.h12,

                  // Footer actions
                  Footer(
                    onSkip: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutesNames.homeSearchScreen);
                    },
                    onNext: () {
                      cubit.submitDiets();
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutesNames.homeSearchScreen);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
