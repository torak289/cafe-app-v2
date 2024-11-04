import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context, listen: false);
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: CafeAppUI.screenVertical,
            horizontal: CafeAppUI.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( //TODO: Impement SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${user.email}"),
                  Text(user.uid),
                  Text("${authService.appState}"),
                ],
              ),
            ),
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
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  onPressed: () {
                    //TODO: Implement Delete Account Process...
                  },
                  child: const Text('Delete Account'),
                ),
                const SizedBox(
                  height: 32,
                  width: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
