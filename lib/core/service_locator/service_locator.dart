import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/dio_consumer.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/router/app_router.dart';
import 'package:gps_app/core/router/middleware.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/blogs/controllers/blog_controller.dart';
import 'package:gps_app/features/favorites/controller/favorites_controller.dart';
import 'package:gps_app/features/item_info/controllers/item_info_controller.dart';
import 'package:gps_app/features/search/controllers/suggestions_controller.dart';
import 'package:gps_app/features/user/preferences/controllers/preferences_controller.dart';
import 'package:gps_app/features/user/restaurant_details/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/store_details/controllers/store_controller.dart';
import 'package:gps_app/features/wishlist/controllers/wishlist_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future initServiceLocator() async {
  serviceLocator.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: serviceLocator()));
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<LocalStorage>(() => LocalStorage(prefs));
  serviceLocator.registerLazySingleton<ImagePicker>(() => ImagePicker());
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);
  serviceLocator.registerLazySingleton<AppMiddleWare>(
    () => AppMiddleWare(sharedPreferences: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AppRouter>(() => AppRouter(appMiddleWare: serviceLocator()));

  serviceLocator.registerLazySingleton<PreferencesController>(() => PreferencesController());
  serviceLocator.registerLazySingleton<AuthController>(() => AuthController());
  serviceLocator.registerLazySingleton<RestaurantsController>(() => RestaurantsController());
  serviceLocator.registerLazySingleton<WishListController>(() => WishListController());
  serviceLocator.registerLazySingleton<ItemInfoController>(() => ItemInfoController());
  serviceLocator.registerLazySingleton<StoreController>(() => StoreController());
  serviceLocator.registerLazySingleton<BlogController>(() => BlogController());
  serviceLocator.registerLazySingleton<FavoritesController>(() => FavoritesController());
  serviceLocator.registerLazySingleton<SuggestionsController>(() => SuggestionsController());

  // serviceLocator.registerLazySingleton<HomeRepo>(() => HomeRepoImp(homeRemoteDataSource: serviceLocator()));
}
