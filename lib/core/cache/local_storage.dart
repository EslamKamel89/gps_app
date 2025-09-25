import 'dart:convert';

import 'package:gps_app/core/cache/cache_keys.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);
  final SharedPreferences _prefs;

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  UserModel? get cachedUser {
    final raw = getString(CacheKeys.userJson);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }
}
