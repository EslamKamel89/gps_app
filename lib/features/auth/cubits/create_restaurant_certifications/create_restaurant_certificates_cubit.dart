import 'package:bloc/bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/certificate_param.dart';

part 'create_restaurant_certificates_state.dart';

class CreateRestaurantCertificatesCubit
    extends Cubit<CreateRestaurantCertificatesState> {
  final controller = serviceLocator<AuthController>();
  CreateRestaurantCertificatesCubit()
    : super(CreateRestaurantCertificatesState.initial());
  void addCertificate({required CertificateParam param}) {
    state.certificates.add(param);
    emit(state.copyWith());
  }

  void removeCertificate({required CertificateParam param}) {
    state.certificates.remove(param);
    emit(state.copyWith());
  }

  Future createCertificate() async {
    final t = prt('createCertificate - CreateRestaurantCertificatesCubit');

    pr(state.certificates, 'state.certificates');
    // return;
    emit(
      state.copyWith(
        certificatesResponse: state.certificatesResponse.copyWith(
          response: ResponseEnum.loading,
        ),
      ),
    );
    final ApiResponseModel<bool> response = await controller.createCertificates(
      param: state.certificates,
    );
    pr(response, t);
    emit(state.copyWith(certificatesResponse: response));
  }
}
