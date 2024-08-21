import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:flutter/material.dart';

String _fontFamily = "Ubuntu";
BorderRadius _searchBorderRadius = BorderRadius.circular(32);
double _searchBorderWidth = 2;
double _searchGapPadding = 0;

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
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
    isDense: true,
    filled: true,
    fillColor: AppColours.backgroundColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(
      color: AppColours.secondaryColor,
      fontWeight: FontWeight.bold,
      fontFamily: _fontFamily,
      fontSize: 14,
    ),
    focusedBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
      ),
      borderRadius: _searchBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
      ),
      borderRadius: _searchBorderRadius,
    ),
    border: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
        strokeAlign: BorderSide.strokeAlignCenter,
        color: AppColours.buttonBackgroundColor,
      ),
      borderRadius: _searchBorderRadius,
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
        EdgeInsets.fromLTRB(32, 4, 32, 4),
      ),
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      shadowColor: WidgetStatePropertyAll(AppColours.secondaryColor),
      elevation: WidgetStatePropertyAll(2),
      backgroundColor: WidgetStatePropertyAll(AppColours.iconButtonIconBGColor),
      iconColor: WidgetStatePropertyAll(AppColours.iconButtonIconColor),
      iconSize: WidgetStatePropertyAll(20),
      minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(
        EdgeInsets.all(6),
      ),
    ),
  ),
);
