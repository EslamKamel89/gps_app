import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';
import 'package:gps_app/features/user/categories/cubits/category/category_cubit.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/asset_category_card.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late CategoryCubit cubit;
  @override
  void initState() {
    cubit = context.read<CategoryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CategoryCubit, CategoryState>(
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

                  Expanded(
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

                        final card = AssetCategoryCard(
                          label: category.name ?? '',
                          description: category.description ?? '', // NEW
                          imageUrl: (category.imageUrl ?? ''),
                          // .replaceAll(
                          //   'http://10.0.2.2:8000',
                          //   'http://127.0.0.1:8000',
                          // )
                          selected: selected,
                          onTap: () => cubit.toggleMainCategory(category),
                        );

                        return card
                            .animate(delay: (80 * index).ms)
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: .15)
                            .scale(begin: const Offset(.98, .98), curve: Curves.easeOutBack);
                      },
                    ),
                  ),

                  GPSGaps.h12,

                  Footer(
                    onSkip:
                        () => Navigator.of(context).pushNamed(AppRoutesNames.foodSelectionScreen),
                    onNext:
                        state.selectedCategories.isNotEmpty
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Selected: ${state.selectedCategories.map((c) => c.name).join(', ')}',
                                  ),
                                ),
                              );
                              Future.delayed(300.ms, () {
                                Navigator.of(context).pushNamed(AppRoutesNames.foodSelectionScreen);
                              });
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
