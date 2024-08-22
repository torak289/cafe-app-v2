import 'package:flutter/material.dart';

@immutable
class CafeAppUI {
  //Main Colors
  static const Color primaryColor = Colors.white;
  static const Color secondaryColor = Colors.black;
  static const Color backgroundColor = Colors.white;

  //Text
  static const Color primaryText = CafeAppUI.primaryColor;
  static const Color secondaryText = CafeAppUI.secondaryColor;
  static const Color errorText = Colors.red;
  static const double textSize = 14;

  //Marker Colors
  static const Color cafeMarkerColor = Colors.black;
  static const Color roasterMarkerColor = Colors.pinkAccent;

  //Main Element Padding
  static const double screenVertical = 32;
  static const double screenHorizontal = 16;

  //BUTTONS
  static const Color buttonTextColor = CafeAppUI.primaryText;
  static const Color buttonBackgroundColor = Colors.black;
  static const Color buttonShadowColor = Colors.black;
  static const double buttonShadowHeight = 2;
  static const double buttonHorizontalPadding = 32;
  static const double buttonVerticalPadding = 4;
  static const double buttonSpacing = 8;
  //Icon Buttoms
  static const Color iconButtonIconColor = Colors.black;
  static const Color iconButtonIconBGColor = Colors.white;
  static const double iconButtonIconSize = 20;
}
