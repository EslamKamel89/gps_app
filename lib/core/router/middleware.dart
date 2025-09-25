import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMiddleWare {
  SharedPreferences sharedPreferences;
  AppMiddleWare({required this.sharedPreferences});

  String? middleware(String? routeName) {
    if (routeName == AppRoutesNames.loginScreen) {}
    return routeName;
  }
}
