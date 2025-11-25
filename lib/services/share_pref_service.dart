import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService extends ChangeNotifier {
  static const _firstLaunchKey = 'first_launch';
  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;

  static const _versionNumberKey = 'version_number';
  String _versionNumber = '0.0.0';
  String get versionNumber => _versionNumber;

  static const _hasAccountKey = 'has_account';
  bool _hasAccount = false;
  bool get hasAccount => _hasAccount;

  SharePrefService() {
    if (kDebugMode) {
      _restAll();
    }
    _loadFirstLaunch();
    _loadVersionNumber();
    _loadHasAccount();
  }
  // Has Account
  Future<void> _loadHasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAccount = prefs.getBool(_hasAccountKey) ?? false;
  }

  Future<void> _resetHasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasAccountKey, _hasAccount);
  }

  Future<void> setHasAccount(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasAccountKey, newValue);
    _loadHasAccount();
    notifyListeners();
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
    await prefs.setBool(_firstLaunchKey, _isFirstLaunch);
    notifyListeners();
  }

  // Reset All
  Future<void> _restAll() async {
    _resetFirstLaunch();
    _resetHasAccount();
  }
}
