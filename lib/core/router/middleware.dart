import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMiddleWare {
  SharedPreferences sharedPreferences;
  AppMiddleWare({required this.sharedPreferences});
  UserModel? _user;

  List<String> guestOnlyRoutes = [
    AppRoutesNames.loginScreen,
    AppRoutesNames.registerScreen,
    AppRoutesNames.vendorRegisterScreen,
  ];
  String? middleware(String? routeName) {
    // top priority routes
    if (routeName == AppRoutesNames.gpsSplashScreen) {
      return routeName;
    }
    // when public routes not allowed
    final localStorage = serviceLocator<LocalStorage>();
    _user ??= localStorage.cachedUser;
    if (_user != null && _user?.emailVerifiedAt == null) {
      return AppRoutesNames.otpScreen;
    }
    if (_user != null && _user?.emailVerifiedAt != null && guestOnlyRoutes.contains(routeName)) {
      return AppRoutesNames.homeSearchScreen;
    }
    //allow public routes
    if (guestOnlyRoutes.contains(routeName)) {
      return routeName;
    }
    // protected routes
    if (_user == null) {
      return AppRoutesNames.loginScreen;
    }

    // todo handle if the vendor didn't complete his profile.
    if (routeName == AppRoutesNames.loginScreen) {
      return AppRoutesNames.homeSearchScreen;
    }
    return routeName;
  }
}
