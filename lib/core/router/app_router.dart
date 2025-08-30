import 'package:flutter/material.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/router/middleware.dart';
import 'package:gps_app/features/design/screens/user/category_selection/category_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/diet_selection/diet_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/food_selection/food_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/home_search/home_search_screen.dart';
import 'package:gps_app/features/design/screens/user/login/login_screen.dart';
import 'package:gps_app/features/design/screens/user/market_category_selection/market_category_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/market_place/market_place_screen.dart';
import 'package:gps_app/features/design/screens/user/register/register_screen.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/resturant_details_screen.dart';
import 'package:gps_app/features/design/screens/user/scann_image/scan_image_screen.dart';
import 'package:gps_app/features/design/screens/user/splash/splash_screen.dart';
import 'package:gps_app/features/design/screens/vendor/login/login_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_branches_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_certifications_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_menu_screen.dart';
import 'package:gps_app/features/design/screens/vendor/register/register_screen.dart';

class AppRouter {
  AppMiddleWare appMiddleWare;
  AppRouter({required this.appMiddleWare});
  Route? onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    String? routeName = appMiddleWare.middlleware(routeSettings.name);
    switch (routeName) {
      case AppRoutesNames.dietSelectionScreen:
        return CustomPageRoute(
          builder: (context) => DietSelectionScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.homeSearchScreen:
        return CustomPageRoute(builder: (context) => HomeSearchScreen(), settings: routeSettings);
      case AppRoutesNames.restaurantDetailScreen:
        return CustomPageRoute(
          builder: (context) => RestaurantDetailScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.gpsSplashScreen:
        return CustomPageRoute(builder: (context) => GPSSplashScreen(), settings: routeSettings);
      case AppRoutesNames.loginScreen:
        return CustomPageRoute(builder: (context) => LoginScreen(), settings: routeSettings);
      case AppRoutesNames.registerScreen:
        return CustomPageRoute(builder: (context) => RegisterScreen(), settings: routeSettings);
      case AppRoutesNames.marketPlaceScreen:
        return CustomPageRoute(builder: (context) => MarketPlaceScreen(), settings: routeSettings);
      case AppRoutesNames.categorySelectionScreen:
        return CustomPageRoute(
          builder: (context) => CategorySelectionScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.foodSelectionScreen:
        return CustomPageRoute(
          builder: (context) => FoodSelectionScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.scanImageScreen:
        return CustomPageRoute(builder: (context) => ScanImageScreen(), settings: routeSettings);
      case AppRoutesNames.marketCategorySelectionScreen:
        return CustomPageRoute(
          builder: (context) => MarketCategorySelectionScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.restaurantLoginScreen:
        return CustomPageRoute(
          builder: (context) => RestaurantLoginScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.restaurantRegisterScreen:
        return CustomPageRoute(
          builder: (context) => VendorRegisterScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.restaurantOnboardingBranchesScreen:
        return CustomPageRoute(
          builder: (context) => RestaurantOnboardingBranchesScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.restaurantOnboardingMenuScreen:
        return CustomPageRoute(
          builder: (context) => RestaurantOnboardingMenuScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.restaurantOnboardingCertificationsScreen:
        return CustomPageRoute(
          builder: (context) => RestaurantOnboardingCertificationsScreen(),
          settings: routeSettings,
        );

      default:
        return null;
    }
  }
}

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({required super.builder, required RouteSettings super.settings});
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
