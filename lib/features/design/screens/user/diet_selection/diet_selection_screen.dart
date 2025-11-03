import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/screens/user/diet_selection/widgets/diet_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';
import 'package:gps_app/features/user/categories/cubits/category_onboarding_cubit/category_onboarding_cubit.dart';

class DietSelectionScreen extends StatefulWidget {
  const DietSelectionScreen({super.key});

  @override
  State<DietSelectionScreen> createState() => _DietSelectionScreenState();
}

class _DietSelectionScreenState extends State<DietSelectionScreen> {
  late CategoryOnboardingCubit cubit;

  @override
  void initState() {
    cubit = context.read<CategoryOnboardingCubit>();
    cubit.dietsIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryOnboardingCubit, CategoryOnboardingState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final diets = state.diets.data ?? [];
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
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: .2, curve: Curves.easeOutQuad),
                  GPSGaps.h24,

                  // Grid of options
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: diets.length,
                      itemBuilder: (context, index) {
                        final diet = diets[index];
                        // final selected = _selected.contains(item.id);

                        final card = DietCard(diet: diet, selected: true, onTap: () {});

                        return card
                            .animate(delay: (80 * index).ms)
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: .15)
                            .scale(begin: const Offset(0.98, 0.98), curve: Curves.easeOutBack);
                      },
                    ),
                  ),

                  GPSGaps.h12,

                  // Footer actions
                  Footer(
                    onSkip: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.homeSearchScreen);
                    },
                    onNext: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.homeSearchScreen);
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
