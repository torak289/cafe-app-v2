import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/widgets/loyalty_card.dart';
import 'package:cafeapp_v2/widgets/profile/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: CafeAppUI.screenVertical, horizontal: CafeAppUI.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LoyaltyCard(),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            const ProfileTabs(),
            TextButton(
              onPressed: () {
                authService.signOut();
                Navigator.pop(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
