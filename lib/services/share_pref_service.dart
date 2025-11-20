import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService extends ChangeNotifier {
  static const _firstLaunchKey = 'first_launch';
  bool _isFirstLaunch = true;
  bool get isFirstLauncher => _isFirstLaunch;

  SharePrefService() {
    _restAll();
    _loadFirstLaunch();
  }

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

  Future<void> _restAll() async {
    _resetFirstLaunch();
  }
}
