import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService extends ChangeNotifier {
  static const _firstLaunchKey = 'first_launch';
  bool _isFirstLaunch = true;
  bool get isFirstLauncher => _isFirstLaunch;

  static const _versionNumberKey = 'version_number';
  String _versionNumber = '0.0.0';
  String get versionNumber => _versionNumber;

  SharePrefService() {
    if (kDebugMode) {
      _restAll();
    }
    _loadFirstLaunch();
    _loadVersionNumber();
  }

  // Version Number
  Future<void> _loadVersionNumber() async {
    final prefs = await SharedPreferences.getInstance();
    _versionNumber = prefs.getString(_versionNumberKey) ?? "0.0.0";
    notifyListeners();
  }

  Future<void> setVersionNumber(String newVersionNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_versionNumberKey, newVersionNumber);
    notifyListeners();
  }

  // First Launch
  Future<void> _loadFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    notifyListeners();
  }

  Future<void> hasFirstLaunched() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, _isFirstLaunch);
    notifyListeners();
  }

  Future<void> _resetFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, isFirstLauncher);
    notifyListeners();
  }

  // Reset All
  Future<void> _restAll() async {
    _resetFirstLaunch();
  }
}
