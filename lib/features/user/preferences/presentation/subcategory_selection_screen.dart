import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';
import 'package:gps_app/features/user/preferences/cubits/preferences/preferences_cubit.dart';
import 'package:gps_app/features/user/preferences/models/category_model/category_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/sub_category_model.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/selected_sub_categories_info_widget.dart';

class SubCategorySelectionScreen extends StatefulWidget {
  const SubCategorySelectionScreen({super.key});

  @override
  State<SubCategorySelectionScreen> createState() =>
      _SubCategorySelectionScreenState();
}

class _SubCategorySelectionScreenState
    extends State<SubCategorySelectionScreen> {
  late PreferencesCubit cubit;
  @override
  void initState() {
    cubit = context.read<PreferencesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        final selectedCategories = state.selectedCategories;
        final subCategories = _mergeSubCategory(selectedCategories);
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
                        title: 'Which sub-categories are you interested in?',
                      )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: .2, curve: Curves.easeOutQuad),
                  GPSGaps.h24,

                  Builder(
                    builder: (context) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // GridView.builder(
                              //   padding: EdgeInsets.zero,
                              //   physics: NeverScrollableScrollPhysics(),
                              //   shrinkWrap: true,
                              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              //     crossAxisCount: 2,
                              //     mainAxisSpacing: 14,
                              //     crossAxisSpacing: 14,
                              //     childAspectRatio: 1.05,
                              //   ),
                              //   itemCount: selectedCategories.length,
                              //   itemBuilder: (context, index) {
                              //     final category = selectedCategories[index];
                              //     final card = CategoryCard(
                              //       label: category.name ?? '',
                              //       description: category.description ?? '',
                              //       imageUrl: "${EndPoint.baseUrl}/${category.image?.path}",

                              //       selected: true,
                              //       onTap: () {},
                              //     );

                              //     return card
                              //         .animate(delay: (80 * index).ms)
                              //         .fadeIn(duration: 300.ms)
                              //         .slideY(begin: .15)
                              //         .scale(
                              //           begin: const Offset(.98, .98),
                              //           curve: Curves.easeOutBack,
                              //         );
                              //   },
                              // ),
                              // GPSGaps.h12,
                              SelectedSubcategoriesInfo(
                                count: state.selectedSubCategories.length,
                              ),
                              GPSGaps.h12,
                              Builder(
                                builder: (context) {
                                  if (subCategories.isEmpty) {
                                    return Text(
                                      'There are no subcategories found',
                                    );
                                  }
                                  return Wrap(
                                    runSpacing: 10,
                                    spacing: 5,
                                    children: List.generate(
                                      pr(
                                        subCategories,
                                        'sub categories',
                                      ).length,
                                      (index) {
                                        final subCat = subCategories[index];
                                        final selected =
                                            state.selectedSubCategories
                                                .where(
                                                  (cat) => cat.id == subCat.id,
                                                )
                                                .isNotEmpty;
                                        return InkWell(
                                              onTap: () {
                                                cubit.toggleSelectedSubCategory(
                                                  subCat,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      selected
                                                          ? GPSColors.primary
                                                          : GPSColors.primary
                                                              .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                // margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 10,
                                                  left: 5,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color:
                                                          selected
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                    Text(
                                                      subCat.name ?? '',
                                                      style: TextStyle(
                                                        color:
                                                            selected
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .animate(delay: (80 * index).ms)
                                            .fadeIn(duration: 300.ms)
                                            .slideY(begin: .15)
                                            .scale(
                                              begin: const Offset(.98, .98),
                                              curve: Curves.easeOutBack,
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  GPSGaps.h12,

                  Footer(
                    onSkip:
                        () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.dietSelectionScreen),
                    onNext: () {
                      cubit.submitSubCategories();
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutesNames.dietSelectionScreen);
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

  List<SubCategoryModel> _mergeSubCategory(List<CategoryModel> categories) {
    List<SubCategoryModel> result = [];
    for (var cat in categories) {
      result.addAll(cat.subCategories ?? []);
    }
    return result;
  }
}
