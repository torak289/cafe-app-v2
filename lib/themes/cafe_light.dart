import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:flutter/material.dart';

String _fontFamily = "Ubuntu";
BorderRadius _searchBorderRadius = BorderRadius.circular(32);
double _searchBorderWidth = 1.5;
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
  tabBarTheme: const TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 3),
    ),
    dividerColor: CafeAppUI.primaryColor,
    indicatorColor: CafeAppUI.secondaryColor,
    labelPadding: EdgeInsets.all(0),
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: CafeAppUI.secondaryText,
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
    overlayColor: WidgetStatePropertyAll(Colors.white),
  ),
  //Search
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: CafeAppUI.secondaryText,
    selectionColor: CafeAppUI.secondaryText,
    selectionHandleColor: CafeAppUI.secondaryText,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    //isDense: true,
    filled: true,
    fillColor: CafeAppUI.backgroundColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(
      color: CafeAppUI.secondaryColor,
      fontWeight: FontWeight.normal,
      fontFamily: _fontFamily,
      fontSize: CafeAppUI.textSize,
    ),
    errorBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        color: Colors.red,
        width: _searchBorderWidth,
      ),
      borderRadius: _searchBorderRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        color: Colors.red,
        width: _searchBorderWidth,
      ),
      borderRadius: _searchBorderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      gapPadding: _searchGapPadding,
      borderSide: BorderSide(
        color: Colors.pinkAccent,
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
  //Progress Indicator
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.black
  ),
  //Bottom Sheet
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: CafeAppUI.backgroundColor,
  ),
  //Tool Tips
  tooltipTheme: TooltipThemeData(
    margin: EdgeInsets.all(32),
    triggerMode: TooltipTriggerMode.tap,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 4,
        )
      ],
    ),
    padding: EdgeInsets.all(16),
    textStyle: TextStyle(color: Colors.black),
  ),
  //Chips
  chipTheme: ChipThemeData(side: BorderSide(color: Colors.black)),
  //Selectables
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.pinkAccent;
      }
      return Colors.white;
    }),
    side: BorderSide(
      color: Colors.black,
      width: 2,
    ),
    checkColor: WidgetStatePropertyAll(Colors.white),
  ),
  //Buttons
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //minimumSize: WidgetStatePropertyAll(Size.zero),
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
      //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.center,
      shadowColor: WidgetStatePropertyAll(CafeAppUI.secondaryColor),
      elevation: WidgetStatePropertyAll(CafeAppUI.buttonShadowHeight),
      backgroundColor: WidgetStatePropertyAll(CafeAppUI.iconButtonIconBGColor),
      iconColor: WidgetStatePropertyAll(CafeAppUI.iconButtonIconColor),
      iconSize: WidgetStatePropertyAll(CafeAppUI.iconButtonIconSize),
      //minimumSize: WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(
        EdgeInsets.all(CafeAppUI.buttonVerticalPadding),
      ),
    ),
  ),
);
