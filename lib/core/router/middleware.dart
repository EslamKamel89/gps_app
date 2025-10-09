import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMiddleWare {
  SharedPreferences sharedPreferences;
  AppMiddleWare({required this.sharedPreferences});
  final _storage = serviceLocator<LocalStorage>();
  UserModel? _user;

  List<String> guestOnlyRoutes = [
    AppRoutesNames.loginScreen,
    AppRoutesNames.registerScreen,
    AppRoutesNames.vendorRegisterScreen,
  ];
  List<String> signedInButNotVerifiedRoutes = [AppRoutesNames.otpScreen];
  List<String> verifiedRoutes = [
    AppRoutesNames.dietSelectionScreen,
    AppRoutesNames.homeSearchScreen,
    AppRoutesNames.restaurantDetailScreen,
    AppRoutesNames.marketPlaceScreen,
    AppRoutesNames.categorySelectionScreen,
    AppRoutesNames.subcategorySelectionScreen,
    AppRoutesNames.foodSelectionScreen,
    AppRoutesNames.scanImageScreen,
    AppRoutesNames.marketCategorySelectionScreen,
    AppRoutesNames.restaurantOnboardingBranchesScreen,
    AppRoutesNames.restaurantOnboardingMenuScreen,
    AppRoutesNames.restaurantOnboardingCertificationsScreen,
    AppRoutesNames.storeFarmOnboardingProductsScreen,
  ];
  List<String> publicRoutes = [AppRoutesNames.gpsSplashScreen];
  String? middleware(String? routeName) {
    if (routeName == AppRoutesNames.entryPoint) {
      return _handleEntryPoint();
    }
    if (detectConflict(routeName)) {
      final newRoute = _handleEntryPoint();
      pr('conflict detected, original route : $routeName , newRoute: $newRoute', 'AppMiddleware');
      return newRoute;
    }
    return routeName;
  }

  bool detectConflict(String? routeName) {
    return (guestOnlyRoutes.contains(routeName) && !_storage.isGuest) ||
        (signedInButNotVerifiedRoutes.contains(routeName) &&
            !_storage.isSignedIn &&
            _storage.isVerified) ||
        (verifiedRoutes.contains(routeName) && !_storage.isSignedIn && !_storage.isVerified);
  }

  String _handleEntryPoint() {
    if (_storage.isGuest) {
      return AppRoutesNames.loginScreen;
    }
    if (!_storage.isVerified) {
      return AppRoutesNames.loginScreen;
      // return AppRoutesNames.otpScreen;
    }
    // handle not complete profile logic
    if (_storage.isFarm && !_storage.isFarmProfileComplete) {
      showSnackbar(
        'Info',
        "Unlock your farm's full potential. A complete profile helps you reach more buyers.",
        false,
      );
      return AppRoutesNames.storeFarmOnboardingProductsScreen;
    }
    if (_storage.isStore && !_storage.isStoreProfileComplete) {
      showSnackbar(
        'Info',
        "A complete store profile is key to making sales. Finish yours now!",
        false,
      );
      return AppRoutesNames.storeFarmOnboardingProductsScreen;
    }
    if (_storage.isRestaurant && !_storage.isRestaurantProfileComplete) {
      showSnackbar(
        'Info',
        "Complete your restaurant profile to appear in more searches and get more reservations.",
        false,
      );
      return AppRoutesNames.restaurantOnboardingBranchesScreen;
    }

    // todo: later each type of user will have his own screen
    if (_storage.isUser) {
      return AppRoutesNames.homeSearchScreen;
    }
    if (_storage.isFarm) {
      return AppRoutesNames.homeSearchScreen;
    }
    if (_storage.isStore) {
      return AppRoutesNames.homeSearchScreen;
    }
    if (_storage.isRestaurant) {
      return AppRoutesNames.homeSearchScreen;
    }
    return AppRoutesNames.loginScreen;
  }
}
