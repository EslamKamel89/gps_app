import 'package:bloc/bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_item.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';

part 'create_catalog_section_items_state.dart';

class CreateCatalogSectionItemsCubit extends Cubit<CreateCatalogSectionItemsState> {
  final controller = serviceLocator<AuthController>();
  CreateCatalogSectionItemsCubit() : super(CreateCatalogSectionItemsState.initial());
  void addItem({required CatalogSectionParam sectionParam, required CatalogItemParam itemParam}) {
    sectionParam.catalogItems ??= [];
    sectionParam.catalogItems!.add(itemParam);
    emit(state.copyWith());
  }

  void removeItem({
    required CatalogSectionParam sectionParam,
    required CatalogItemParam itemParam,
  }) {
    sectionParam.catalogItems ??= [];
    sectionParam.catalogItems!.remove(itemParam);
    emit(state.copyWith());
  }

  void addSection({required CatalogSectionParam sectionParam}) {
    state.sections.add(sectionParam);
    emit(state.copyWith());
  }

  void removeSection({required CatalogSectionParam sectionParam}) {
    state.sections.remove(sectionParam);
    emit(state.copyWith());
  }

  Future createCatalogSection() async {
    final t = prt('createCatalogSection - CreateCatalogSectionItemsCubit');
    for (var i = 0; i < state.sections.length; i++) {
      final section = state.sections[i];
      section.position = i + 1;
      for (var k = 0; k < (section.catalogItems?.length ?? 0); k++) {
        final item = section.catalogItems![k];
        item.position = k + 1;
      }
    }
    // pr(state.sections, 'state.sections');
    // return;
    emit(
      state.copyWith(
        sectionsResponse: state.sectionsResponse.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
          data: [],
        ),
      ),
    );
    final ApiResponseModel<List<CatalogSectionModel>> response = await controller
        .createCatalogSection(param: state.sections);
    pr(response, t);
    emit(state.copyWith(sectionsResponse: response));
  }
}
