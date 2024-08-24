import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

String _fontFamily = "Ubuntu";
BorderRadius _searchBorderRadius = BorderRadius.circular(32);
double _searchBorderWidth = 2;
double _searchGapPadding = 0;

ThemeData cafeLightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: CafeAppUI.primaryColor,
  canvasColor: CafeAppUI.backgroundColor,
  scaffoldBackgroundColor: CafeAppUI.backgroundColor,
  //Icons
  iconTheme: const IconThemeData(
    color: CafeAppUI.primaryColor,
  ),
  //Text
  fontFamily: _fontFamily,
  //Tab
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 3),
    ),
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: CafeAppUI.secondaryText,
    ),
    dividerColor: CafeAppUI.primaryColor,
    indicatorColor: CafeAppUI.secondaryColor,
  ),
  //Search
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: CafeAppUI.secondaryText,
    selectionColor: CafeAppUI.secondaryText,
    selectionHandleColor: CafeAppUI.secondaryText,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
    isDense: true,
    filled: true,
    fillColor: CafeAppUI.backgroundColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(
      color: CafeAppUI.secondaryColor,
      fontWeight: FontWeight.bold,
      fontFamily: _fontFamily,
      fontSize: CafeAppUI.textSize,
    ),
    focusedBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      borderRadius: _searchBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      borderRadius: _searchBorderRadius,
    ),
    border: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        width: _searchBorderWidth,
        strokeAlign: BorderSide.strokeAlignCenter,
        color: CafeAppUI.buttonBackgroundColor,
      ),
      borderRadius: _searchBorderRadius,
    ),
  ),
  //Buttons
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: WidgetStatePropertyAll(Size.zero),
      shadowColor: WidgetStatePropertyAll(CafeAppUI.buttonShadowColor),
      elevation: WidgetStatePropertyAll(CafeAppUI.buttonShadowHeight),
      backgroundColor: WidgetStatePropertyAll(CafeAppUI.buttonBackgroundColor),
      foregroundColor: WidgetStatePropertyAll(CafeAppUI.buttonTextColor),
      iconColor: WidgetStatePropertyAll(CafeAppUI.primaryColor),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
            vertical: CafeAppUI.buttonVerticalPadding,
            horizontal: CafeAppUI.buttonHorizontalPadding),
      ),
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      shadowColor: WidgetStatePropertyAll(CafeAppUI.secondaryColor),
      elevation: WidgetStatePropertyAll(CafeAppUI.buttonShadowHeight),
      backgroundColor: WidgetStatePropertyAll(CafeAppUI.iconButtonIconBGColor),
      iconColor: WidgetStatePropertyAll(CafeAppUI.iconButtonIconColor),
      iconSize: WidgetStatePropertyAll(CafeAppUI.iconButtonIconSize),
      minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(
        EdgeInsets.all(CafeAppUI.buttonVerticalPadding),
      ),
    ),
  ),
);
