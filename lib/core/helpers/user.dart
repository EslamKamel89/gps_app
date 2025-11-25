import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';

UserModel? userInMemory() {
  return serviceLocator<LocalStorage>().cachedUser;
}

int? userId() {
  return userInMemory()?.id;
}

bool auth() {
  return serviceLocator<LocalStorage>().isSignedIn;
}

bool guest() {
  return !serviceLocator<LocalStorage>().isSignedIn;
}
