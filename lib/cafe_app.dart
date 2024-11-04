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

    return ListenableProvider<AuthService>(
      //Auth Service
      create: (context) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          return StreamBuilder<UserModel?>(
            stream: authService.user.stream,
            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
              final UserModel? user = snapshot.data;
              return MultiProvider(
                providers: [
                  Provider<UserModel?>.value(value: user),
                  Provider<DatabaseService>(
                    create: (context) => DatabaseService(uid: user?.uid),
                  ),
                  Provider<LocationService>(
                    create: (context) => LocationService(),
                  ),
                ],
                child: SafeArea(
                  left: false,
                  right: false,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Robusta',
                    theme: cafeLightTheme,
                    routes: Routes.routes,
                    initialRoute: Routes.mapPage,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
