import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
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
            Expanded(
              //TODO: Impement SingleChildScrollView
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
                  onPressed: () => showDialog<String>(
                    //TODO: Implement Async Stream to listen to database events fired on Scan from Cafe Account...
                    //TODO: Implement this for both available QR Codes...
                    //TODO: Pop context and update UI state on Scan...
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Are you sure you want to delete your account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingSmall),
                          ),
                          Text(
                              'This is a permanent action and cannot be undone. Make sure you want to do this!'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            //TODO: Implement authService account deletion...
                            
                            Navigator.popUntil(context, (route) {
                              return route.settings.name == Routes.mapPage;
                            });
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                          ),
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, "Closed"),
                          child: const Text("No"),
                        ),
                      ],
                    ),
                  ),
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
