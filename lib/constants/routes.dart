import 'package:cafeapp_v2/screens/add_cafe_page.dart';
import 'package:cafeapp_v2/screens/login_page.dart';
import 'package:cafeapp_v2/screens/map_page.dart';
import 'package:cafeapp_v2/screens/registration_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._(); //prevents instantiation

  static const String mapPage = '/mapPage';
  static const String loginPage = '/loginPage';
  static const String registrationPage = '/registrationPage';
  static const String addCafePage = 'addCafePage';
  static final routes = <String, WidgetBuilder>{
    mapPage: (BuildContext context) => MapPage(),
    loginPage: (BuildContext context) => LoginPage(),
    registrationPage: (BuildContext context) => RegistrationPage(),
    addCafePage: (BuildContext context) => AddCafePage(),
  };
}
