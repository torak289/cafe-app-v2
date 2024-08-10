import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiUtils {
  /// A workaround for iOS to get dark status bar icons without needing
  /// to use an [AppBar] in a [Scaffold].
  ///
  /// This also enables seamless navigation bars in Android.
  static void setStatusBarIconColors(BuildContext context, bool darkIconsOnLightBackground) {
    SystemUiOverlayStyle _style;

    if (Theme.of(context).brightness == Brightness.light) {
      if (darkIconsOnLightBackground) {
        _style = SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        );
      } else {
        _style = SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        );
      }
    } else {
      if (darkIconsOnLightBackground) {
        _style = SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        );
      } else {
        _style = SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        );
      }
    }

    SystemChrome.setSystemUIOverlayStyle(_style);
  }

  static void toggleSystemUi(bool enabled) {
    SystemChrome.setEnabledSystemUIMode(enabled ? SystemUiMode.edgeToEdge : SystemUiMode.immersive);
  }

  static void setLandscape() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
  }

  static void setPortrait() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
  }
}
