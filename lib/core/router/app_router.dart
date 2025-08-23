import 'package:flutter/material.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/router/middleware.dart';
import 'package:gps_app/features/design/screens/category_selection/category_selection_screen.dart';
import 'package:gps_app/features/design/screens/diet_selection/diet_selection_screen.dart';
import 'package:gps_app/features/design/screens/food_selection/food_selection_screen.dart';
import 'package:gps_app/features/design/screens/home_search/home_search_screen.dart';
import 'package:gps_app/features/design/screens/login/login_screen.dart';
import 'package:gps_app/features/design/screens/market_category_selection/market_category_selection_screen.dart';
import 'package:gps_app/features/design/screens/market_place/market_place_screen.dart';
import 'package:gps_app/features/design/screens/register/register_screen.dart';
import 'package:gps_app/features/design/screens/resturant_details/resturant_details_screen.dart';
import 'package:gps_app/features/design/screens/scann_image/scan_image_screen.dart';
import 'package:gps_app/features/design/screens/splash/splash_screen.dart';

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
