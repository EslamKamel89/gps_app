import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/categories/controllers/category_controller.dart';
import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';

part 'category_onboarding_state.dart';

class CategoryOnboardingCubit extends Cubit<CategoryOnboardingState> {
  CategoryOnboardingCubit() : super(CategoryOnboardingState.initial());
  final CategoryController controller = serviceLocator<CategoryController>();
  Future categoriesIndex() async {
    final t = prt('categoriesIndex - CategoryOnboardingCubit');

    emit(
      state.copyWith(
        categories: state.categories.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
          data: [],
        ),
      ),
    );
    final ApiResponseModel<List<CategoryModel>> response = await controller.categoriesIndex();
    pr(response, t);
    emit(state.copyWith(categories: response));
  }

  void toggleSelectedCategory(CategoryModel category) {
    bool categoryExist = state.selectedCategories.where((cat) => cat.id == category.id).isNotEmpty;
    if (categoryExist) {
      state.selectedCategories.removeWhere((cat) => cat.id == category.id);
    } else {
      state.selectedCategories.add(category);
    }
    emit(state.copyWith());
  }

  void toggleSelectedSubCategory(SubCategoryModel subCat) {
    bool subCategoryExist =
        state.selectedSubCategories.where((cat) => cat.id == subCat.id).isNotEmpty;
    if (subCategoryExist) {
      state.selectedSubCategories.removeWhere((cat) => cat.id == subCat.id);
    } else {
      state.selectedSubCategories.add(subCat);
    }
    emit(state.copyWith());
  }
}
