// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_restaurant_certificates_cubit.dart';

class CreateRestaurantCertificatesState {
  ApiResponseModel<bool> certificatesResponse;
  List<CertificateParam> certificates;
  CreateRestaurantCertificatesState({
    required this.certificatesResponse,
    required this.certificates,
  });

  CreateRestaurantCertificatesState copyWith({
    ApiResponseModel<bool>? certificatesResponse,
    List<CertificateParam>? certificates,
  }) {
    return CreateRestaurantCertificatesState(
      certificatesResponse: certificatesResponse ?? this.certificatesResponse,
      certificates: certificates ?? this.certificates,
    );
  }

  @override
  String toString() =>
      'CreateRestaurantCertificatesState(response: $certificatesResponse, certificates: $certificates)';
  factory CreateRestaurantCertificatesState.initial() {
    return CreateRestaurantCertificatesState(
      certificates: [CertificateParam()],
      certificatesResponse: ApiResponseModel(),
    );
  }
}
