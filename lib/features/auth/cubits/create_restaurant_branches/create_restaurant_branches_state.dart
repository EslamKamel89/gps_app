// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_restaurant_branches_cubit.dart';

class CreateRestaurantBranchesState {
  ApiResponseModel<List<BranchModel>> branchesResponse;
  List<BranchParam> branches;
  CreateRestaurantBranchesState({required this.branchesResponse, required this.branches});

  CreateRestaurantBranchesState copyWith({
    ApiResponseModel<List<BranchModel>>? branchesResponse,
    List<BranchParam>? branches,
  }) {
    return CreateRestaurantBranchesState(
      branchesResponse: branchesResponse ?? this.branchesResponse,
      branches: branches ?? this.branches,
    );
  }

  @override
  String toString() =>
      'CreateRestaurantBranchesState(branchesResponse: $branchesResponse, branches: $branches)';

  factory CreateRestaurantBranchesState.initial() {
    return CreateRestaurantBranchesState(
      branches: [BranchParam()],
      branchesResponse: ApiResponseModel(),
    );
  }
}
