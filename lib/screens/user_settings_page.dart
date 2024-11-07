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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          Text("${user.email}"),
                        ],
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.edit_rounded,
                          color: CafeAppUI.iconButtonIconColor,
                          size: 16,
                        ),
                      )
                    ],
                  ),
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
                    backgroundColor: WidgetStatePropertyAll(Colors.pinkAccent),
                  ),
                  onPressed: () => showDialog<String>(
                    //TODO: Implement Async Stream to listen to database events fired on Scan from Cafe Account...
                    //TODO: Implement this for both available QR Codes...
                    //TODO: Pop context and update UI state on Scan...
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        "Are you sure you want to delete your account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.pinkAccent,
                            size: 96,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingSmall),
                          ),
                          Text(
                              'This is a permanent action and cannot be undone. Make sure you want to do this!'),
                        ],
                      ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          onPressed: () async {
                            //TODO: Implement authService account deletion...
                            //bool res = await authService.deleteUser(user.uid);
                            if (context.mounted) {
                              if (false) {
                                Navigator.popUntil(context, (route) {
                                  return route.settings.name == Routes.mapPage;
                                });
                              } else {
                                //TODO: Implement error handling...
                                //debugPrint(res.toString());
                                Navigator.pop(context, "Closed");
                              }
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.pinkAccent),
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
