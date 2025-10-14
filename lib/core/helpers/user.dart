import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';

UserModel? user() {
  return serviceLocator<LocalStorage>().cachedUser;
}
