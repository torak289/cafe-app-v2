import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color currentColor = Colors.white;

  @override
  void initState() {
    currentColor = Colors.white;
    super.initState();
  }

  void _authSuccessState() {
    currentColor = Colors.lightGreen;
  }

  void _authFailState() {
    currentColor = Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    authService.addListener(
      () {
        setState(() {
          if (authService.appState == AppState.Authenticated) {
            _authSuccessState();
          } else{
            _authFailState();
          }
        });
      },
    );

    return Positioned(
      right: CafeAppUI.profileRightPadding,
      top: CafeAppUI.probileTopPadding,
      child: GestureDetector(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: const Icon(
            Icons.person,
            color: CafeAppUI.secondaryColor,
          ),
        ),
        onTap: () {
          switch (authService.appState) {
            case AppState.Authenticated:
              Navigator.pushNamed(context, Routes.profilePage);
              break;
            default:
              Navigator.pushNamed(context, Routes.loginPage);
              break;
          }
        },
      ),
    );
  }
}
