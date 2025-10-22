// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/widgets/inputs.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/categories/cubits/category_selector_cubit/category_selector_cubit.dart';
import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';

class CategorySelector {
  CategoryModel? selectedCategory;
  SubCategoryModel? selectedSubCategory;
  CategorySelector({this.selectedCategory, this.selectedSubCategory});

  CategorySelector copyWith({
    CategoryModel? selectedCategory,
    SubCategoryModel? selectedSubCategory,
  }) {
    return CategorySelector(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
    );
  }

  @override
  String toString() =>
      'CategorySelector(selectedCategory: $selectedCategory, selectedSubCategory: $selectedSubCategory)';
}

class CategorySelectorProvider extends StatelessWidget {
  const CategorySelectorProvider({super.key, required this.onSelect, this.isRequired = true});
  final Function(CategorySelector) onSelect;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategorySelectorCubit()..categoriesIndex(),
      child: CategorySelectorWidget(onSelect, isRequired: isRequired),
    );
  }
}

class CategorySelectorWidget extends StatefulWidget {
  const CategorySelectorWidget(this.onSelect, {super.key, this.isRequired = true});
  final Function(CategorySelector) onSelect;
  final bool isRequired;

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorySelectorCubit, CategorySelectorState>(
      builder: (context, state) {
        final cubit = context.read<CategorySelectorCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.categories.data?.isNotEmpty == true)
              SearchableDropdownWidget(
                key: Key('category'),
                label: 'Category',
                hintText: 'Select category',
                isRequired: widget.isRequired,
                options:
                    state.categories.data?.map((category) => category.name ?? '').toList() ?? [],
                handleSelectOption: (String option) {
                  final category = cubit.selectCategory(option);
                  widget.onSelect(
                    CategorySelector(selectedCategory: category, selectedSubCategory: null),
                  );
                },
              ),
            if (state.categories.data?.isNotEmpty == true && state.selectedCategory != null)
              GPSGaps.h16,
            if (state.categories.data?.isNotEmpty == true && state.selectedCategory != null)
              SearchableDropdownWidget(
                key: Key('subCategory'),
                label: 'Sub Category',
                hintText: 'Select Sub category',
                isRequired: widget.isRequired,
                options:
                    state.selectedCategory?.subCategories
                        ?.map((subCat) => subCat.name ?? '')
                        .toList() ??
                    [],
                handleSelectOption: (String option) async {
                  final subCat = cubit.selectSubCategory(option);
                  widget.onSelect(
                    CategorySelector(
                      selectedCategory: state.selectedCategory,
                      selectedSubCategory: subCat,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
