import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/share_pref_service.dart';
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
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(
      context,
      listen: true,
    );
    SharePrefService sharePrefService = Provider.of<SharePrefService>(
      context,
      listen: true,
    );

    // Determine color based on current auth state
    final Color currentColor = authService.appState == AppState.Authenticated
        ? Colors.pinkAccent
        : Colors.black;

    return Positioned(
      right: CafeAppUI.profileRightPadding,
      top: CafeAppUI.probileTopPadding,
      child: GestureDetector(
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: CafeAppUI.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            Icons.person,
            color: currentColor,
          ),
        ),
        onTap: () async {
          switch (authService.appState) {
            case AppState.Authenticated:
              await authService.manualRefresh();
              if (context.mounted) {
                Navigator.pushNamed(context, Routes.userSettingsPage);
              }
              break;
            default:
              debugPrint("Account State: ${sharePrefService.hasAccount}");
              if (sharePrefService.hasAccount) {
                Navigator.pushNamed(context, Routes.loginPage);
              } else {
                Navigator.pushNamed(context, Routes.registrationPage);
              }
              break;
          }
        },
      ),
    );
  }
}
