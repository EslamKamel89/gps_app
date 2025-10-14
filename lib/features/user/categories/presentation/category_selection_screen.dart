import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';
import 'package:gps_app/features/user/categories/cubits/category_onboarding_cubit/category_onboarding_cubit.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_card.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late CategoryOnboardingCubit cubit;
  @override
  void initState() {
    cubit = context.read<CategoryOnboardingCubit>();
    cubit.categoriesIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryOnboardingCubit, CategoryOnboardingState>(
      builder: (context, state) {
        final categories = state.categories.data ?? [];
        return Scaffold(
          backgroundColor: GPSColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GPSGaps.h24,
                  const GpsHeader(
                    title: 'Which categories are you interested in?',
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: .2, curve: Curves.easeOutQuad),
                  GPSGaps.h24,

                  Builder(
                    builder: (context) {
                      if (state.categories.response == ResponseEnum.loading) {
                        return Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.05,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1000.ms);
                            },
                          ),
                        );
                      }
                      return Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 1.05,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final selected =
                                state.selectedCategories
                                    .where((cat) => cat.id == category.id)
                                    .isNotEmpty;

                            final card = CategoryCard(
                              label: category.name ?? '',
                              description: category.description ?? '', // NEW
                              imageUrl: "${EndPoint.baseUrl}/${category.image?.path}",

                              selected: selected,
                              onTap: () => cubit.toggleSelectedCategory(category),
                            );

                            return card
                                .animate(delay: (80 * index).ms)
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: .15)
                                .scale(begin: const Offset(.98, .98), curve: Curves.easeOutBack);
                          },
                        ),
                      );
                    },
                  ),

                  GPSGaps.h12,

                  Footer(
                    onSkip:
                        () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.subcategorySelectionScreen),
                    onNext:
                        state.selectedCategories.isNotEmpty
                            ? () {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       'Selected: ${state.selectedCategories.map((c) => c.name).join(', ')}',
                              //     ),
                              //   ),
                              // );
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutesNames.subcategorySelectionScreen);
                            }
                            : null,
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
