import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/themes/cafe_light.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CafeApp extends StatelessWidget {
  const CafeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Force Portrait Experience because we have no landscape UI
    SystemUiUtils.setPortrait();
    //Force android navbar edge to edge for better looking UI (Seamless)
    SystemUiUtils.toggleSystemUi(true);

    return MultiProvider(
      providers: [
        //Auth Service
        Provider<AuthService>(create: (context) => AuthService()),
        //User Data
        //Provider<UserModel>.value(value: user)
        //Database Service
        Provider<DatabaseService>(create: (context) => DatabaseService(uid: '-1')),
        //Location Service
        Provider<LocationService>(create: (context) => LocationService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cafe App',
        theme: cafeLightTheme,
        routes: Routes.routes,
        initialRoute: Routes.mapPage,
      ),
    );
  }
}
