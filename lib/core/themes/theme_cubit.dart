import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/cache_keys.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/themes/themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme) {
    _loadTheme();
  }

  void toggleTheme() {
    final prefs = serviceLocator<SharedPreferences>();
    if (state.brightness == Brightness.light) {
      emit(darkTheme);
      prefs.setBool(CacheKeys.isDarkMode, true);
    } else {
      emit(lightTheme);
      prefs.setBool(CacheKeys.isDarkMode, false);
    }
  }

  void _loadTheme() {
    final prefs = serviceLocator<SharedPreferences>();
    final isDarkMode = prefs.getBool(CacheKeys.isDarkMode) ?? false;
    emit(isDarkMode ? darkTheme : lightTheme);
  }
}

bool isDarkTheme() {
  return serviceLocator<SharedPreferences>().getBool(CacheKeys.isDarkMode) ??
      false;
}
