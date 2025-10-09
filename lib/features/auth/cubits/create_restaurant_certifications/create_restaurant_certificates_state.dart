// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_restaurant_certificates_cubit.dart';

class CreateRestaurantCertificatesState {
  ApiResponseModel<bool> response;
  List<CertificateParam> certificates;
  CreateRestaurantCertificatesState({required this.response, required this.certificates});

  CreateRestaurantCertificatesState copyWith({
    ApiResponseModel<bool>? response,
    List<CertificateParam>? certificates,
  }) {
    return CreateRestaurantCertificatesState(
      response: response ?? this.response,
      certificates: certificates ?? this.certificates,
    );
  }

  @override
  String toString() =>
      'CreateRestaurantCertificatesState(response: $response, certificates: $certificates)';
  factory CreateRestaurantCertificatesState.initial() {
    return CreateRestaurantCertificatesState(
      certificates: [CertificateParam()],
      response: ApiResponseModel(),
    );
  }
}
