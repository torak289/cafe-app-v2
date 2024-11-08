import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/widgets/loyalty_card.dart';
import 'package:cafeapp_v2/widgets/profile%20page%20tabs/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: CafeAppUI.screenVertical,
            horizontal: CafeAppUI.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LoyaltyCard(),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.qrCodePage),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_rounded),
                  Padding(padding: EdgeInsets.all(4)),
                  Text('Scan QR Code')
                ],
              ),
            ),
            const ProfileTabs(),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 32,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    authService.signOut();
                    Navigator.pop(context);
                  },
                  child: const Text('Logout'),
                ),
                GestureDetector(
                  child: const SizedBox(
                    height: 32,
                    width: 32,
                    child: Icon(
                      Icons.settings_rounded,
                      color: CafeAppUI.iconButtonIconColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.userSettingsPage);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
