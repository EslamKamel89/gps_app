import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/router/middleware.dart';
import 'package:gps_app/features/auth/cubits/login_cubit.dart';
import 'package:gps_app/features/auth/cubits/user_register_cubit.dart';
import 'package:gps_app/features/auth/cubits/vendor_register_cubit.dart';
import 'package:gps_app/features/auth/presentation/login_screen.dart';
import 'package:gps_app/features/auth/presentation/user_register_screen.dart';
import 'package:gps_app/features/auth/presentation/vendor_register_screen.dart';
import 'package:gps_app/features/design/screens/empty_screen.dart';
import 'package:gps_app/features/design/screens/user/diet_selection/diet_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/food_selection/food_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/home_search/home_search_screen.dart';
import 'package:gps_app/features/design/screens/user/market_category_selection/market_category_selection_screen.dart';
import 'package:gps_app/features/design/screens/user/market_place/market_place_screen.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/resturant_details_screen.dart';
import 'package:gps_app/features/design/screens/user/scann_image/scan_image_screen.dart';
import 'package:gps_app/features/design/screens/user/splash/splash_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/farm_onboarding_products.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_branches_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_certifications_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/restaurant_onboarding_menu_screen.dart';
import 'package:gps_app/features/design/screens/vendor/on_boarding/screens/store_onboarding_products.dart';
import 'package:gps_app/features/user/categories/presentation/category_selection_screen.dart';
import 'package:gps_app/features/user/categories/presentation/subcategory_selection_screen.dart';

class AppRouter {
  AppMiddleWare appMiddleWare;
  AppRouter({required this.appMiddleWare});
  Route? onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    String? routeName = appMiddleWare.middlleware(routeSettings.name);
    switch (routeName) {
      case AppRoutesNames.emptyScreen:
        return CustomPageRoute(builder: (context) => EmptyScreen(), settings: routeSettings);
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
        return CustomPageRoute(
          builder:
              (context) => BlocProvider(create: (context) => LoginCubit(), child: LoginScreen()),
          settings: routeSettings,
        );
      case AppRoutesNames.registerScreen:
        return CustomPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => UserRegisterCubit(),
                child: UserRegisterScreen(),
              ),
          settings: routeSettings,
        );
      case AppRoutesNames.marketPlaceScreen:
        return CustomPageRoute(builder: (context) => MarketPlaceScreen(), settings: routeSettings);
      case AppRoutesNames.categorySelectionScreen:
        return CustomPageRoute(
          builder: (context) => CategorySelectionScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.subcategorySelectionScreen:
        return CustomPageRoute(
          builder: (context) => SubCategorySelectionScreen(),
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

      case AppRoutesNames.restaurantRegisterScreen:
        return CustomPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => VendorRegisterCubit(),
                child: VendorRegisterScreen(),
              ),
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
      case AppRoutesNames.storeOnboardingProductsScreen:
        return CustomPageRoute(
          builder: (context) => StoreOnboardingProductsScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.farmOnboardingProductsScreen:
        return CustomPageRoute(
          builder: (context) => FarmOnboardingProductsScreen(),
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
