// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_catalog_section_items_cubit.dart';

class CreateCatalogSectionItemsState {
  ApiResponseModel<List<CatalogSectionModel>> sectionsResponse;
  List<CatalogSectionParam> sections;
  CreateCatalogSectionItemsState({
    required this.sectionsResponse,
    required this.sections,
  });

  CreateCatalogSectionItemsState copyWith({
    ApiResponseModel<List<CatalogSectionModel>>? sectionsResponse,
    List<CatalogSectionParam>? sections,
  }) {
    return CreateCatalogSectionItemsState(
      sectionsResponse: sectionsResponse ?? this.sectionsResponse,
      sections: sections ?? this.sections,
    );
  }

  @override
  String toString() =>
      'CreateCatalogSectionItemsState(sectionsResponse: $sectionsResponse, sections: $sections)';

  factory CreateCatalogSectionItemsState.initial() {
    return CreateCatalogSectionItemsState(
      sections: [
        CatalogSectionParam(catalogItems: [CatalogItemParam()]),
      ],
      sectionsResponse: ApiResponseModel(),
    );
  }
}
