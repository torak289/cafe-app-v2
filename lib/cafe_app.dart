import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:flutter/material.dart';

class CafeApp extends StatelessWidget {
  const CafeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Force Portrait Experience because we have no landscape UI
    SystemUiUtils.setPortrait();

    //Force android navbar edge to edge for better looking UI (Seamless)
    SystemUiUtils.toggleSystemUi(true);
    return MaterialApp(
      title: 'Cafe App',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      routes: Routes.routes,
      initialRoute: Routes.mapPage,
    );
  }
}
