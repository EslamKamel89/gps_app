import 'dart:convert';

import 'package:gps_app/core/cache/cache_keys.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
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

  Future login(UserModel? user) async {
    if (user == null) {
      await logout();
      return;
    }
    if (user.token != null) {
      await setString(CacheKeys.token, user.token ?? '');
    }
    await setString(CacheKeys.userJson, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    await _prefs.clear();
  }

  String? get token {
    return getString(CacheKeys.token);
  }

  bool get isGuest {
    return token == null;
  }

  bool get isSignedIn {
    return token != null;
  }

  bool get isBlocked {
    return cachedUser?.vendor?.isActive == 0;
  }

  bool get isVerified {
    return cachedUser?.emailVerifiedAt != null;
  }

  bool get isVendor {
    return ['farm', 'store', 'restaurant'].contains(cachedUser?.userType?.type);
  }

  bool get isUser {
    return !isVendor;
  }

  bool get isFarm {
    return cachedUser?.userType?.type == 'farm';
  }

  bool get isFarmProfileComplete {
    return isFarm &&
        cachedUser?.farm != null &&
        cachedUser?.farm?.sections?.isNotEmpty == true;
  }

  bool get isStore {
    return cachedUser?.userType?.type == 'store';
  }

  bool get isStoreProfileComplete {
    pr(cachedUser?.store, 'store ');
    pr(cachedUser?.store?.sections, 'sections');
    return pr(
      isStore &&
          cachedUser?.store != null &&
          cachedUser?.store?.sections?.isNotEmpty == true,
      'test',
    );
  }

  bool get isRestaurant {
    return cachedUser?.userType?.type == 'restaurant';
  }

  bool get isRestaurantProfileComplete {
    return isRestaurant &&
        cachedUser?.restaurant != null &&
        cachedUser?.restaurant?.branches?.isNotEmpty == true;
  }
}
