import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/categories/controllers/category_controller.dart';
import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';

part 'category_selector_state.dart';

class CategorySelectorCubit extends Cubit<CategorySelectorState> {
  CategorySelectorCubit() : super(CategorySelectorState.initial());
  final CategoryController controller = serviceLocator<CategoryController>();
  Future categoriesIndex() async {
    final t = prt('categoriesIndex - CategorySelectorCubit');

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

  CategoryModel? selectCategory(String categoryName) {
    final category = state.categories.data?.where((c) => categoryName == c.name).first;
    state.selectedSubCategory = null;
    state.selectedCategory = category;
    emit(state.copyWith());
    return category;
  }

  SubCategoryModel? selectSubCategory(String subCatName) {
    final subCat = state.selectedCategory?.subCategories?.where((c) => subCatName == c.name).first;
    emit(state.copyWith(selectedSubCategory: subCat));
    return subCat;
  }
}
