import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);
  final SharedPreferences _prefs;

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);
  Future<bool> remove(String key) => _prefs.remove(key);
}
