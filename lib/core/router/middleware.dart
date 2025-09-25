import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMiddleWare {
  SharedPreferences sharedPreferences;
  AppMiddleWare({required this.sharedPreferences});
  UserModel? _user;
  List<String> publicRoutes = [
    AppRoutesNames.gpsSplashScreen,
    AppRoutesNames.loginScreen,
    AppRoutesNames.registerScreen,
    AppRoutesNames.vendorRegisterScreen,
  ];
  String? middleware(String? routeName) {
    if (publicRoutes.contains(routeName)) {
      return routeName;
    }
    final localStorage = serviceLocator<LocalStorage>();
    _user ??= localStorage.cachedUser;
    if (_user == null) {
      return AppRoutesNames.loginScreen;
    }
    if (_user?.emailVerifiedAt == null) {
      return AppRoutesNames.otpScreen;
    }
    // todo handle if the vendor didn't complete his profile.
    if (routeName == AppRoutesNames.loginScreen) {
      return AppRoutesNames.homeSearchScreen;
    }
    return routeName;
  }
}
