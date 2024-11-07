import 'package:cafeapp_v2/screens/add_cafe_page.dart';
import 'package:cafeapp_v2/screens/cafe_verification_page.dart';
import 'package:cafeapp_v2/screens/login_page.dart';
import 'package:cafeapp_v2/screens/map_page.dart';
import 'package:cafeapp_v2/screens/profile_page.dart';
import 'package:cafeapp_v2/screens/qr_code_scanner_page.dart';
import 'package:cafeapp_v2/screens/registration_page.dart';
import 'package:cafeapp_v2/screens/user_settings_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._(); //prevents instantiation

  static const String mapPage = '/mapPage';
  static const String loginPage = '/loginPage';
  static const String registrationPage = '/registrationPage';
  static const String addCafePage = 'addCafePage';
  static const String profilePage = '/profilePage';
  static const String qrCodePage = '/qrCodePage';
  static const String userSettingsPage = '/userSettingsPage';
  static const String cafeVerificationPage = '/cafeVerificationPage';

  static final routes = <String, WidgetBuilder>{
    mapPage: (BuildContext context) => const MapPage(),
    loginPage: (BuildContext context) => const LoginPage(),
    registrationPage: (BuildContext context) => const RegistrationPage(),
    addCafePage: (BuildContext context) => const AddCafePage(),
    profilePage: (BuildContext context) => const ProfilePage(),
    qrCodePage: (BuildContext context) => QrCodeScannerPage(),
    userSettingsPage: (BuildContext context) => UserSettingsPage(),
    cafeVerificationPage: (BuildContext context) => const CafeVerificationPage(),
  };
}
