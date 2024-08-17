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
  //Search
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.zero,
    filled: true,
    fillColor: AppColours.backgroundColor,
    border: OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(
        width: 2.0,
        strokeAlign: BorderSide.strokeAlignCenter,
        color: AppColours.buttonBackgroundColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(32),
      ),
    ),
  ),
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
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(EdgeInsets.zero)
    )
  )
);
