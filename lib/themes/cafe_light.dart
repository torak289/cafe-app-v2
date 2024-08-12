import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String _fontFamily = "Ubuntu";

ThemeData cafeLightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColours.primaryColor,
  canvasColor: AppColours.backgroundColor,
  scaffoldBackgroundColor: AppColours.backgroundColor,
  //Icons
  iconTheme: const IconThemeData(
    color: AppColours.primaryColor,
  ),
  //Text
  fontFamily: _fontFamily,
  //Buttons
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.zero),
      backgroundColor: WidgetStatePropertyAll(
        AppColours.buttonBackgroundColor,
      ),
      foregroundColor: WidgetStatePropertyAll(
        AppColours.buttonTextColor,
      ),
      iconColor: WidgetStatePropertyAll(
        AppColours.primaryColor,
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.zero,
      ),
    ),
  ),
);
