import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context, listen: false);
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmPassword = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(CafeAppUI.screenHorizontal, 0,
            CafeAppUI.screenHorizontal, CafeAppUI.screenVertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              //TODO: Impement SingleChildScrollView
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.all(8)),
                    const Center(
                      //TODO: Fix centre align on Profile
                      child: Icon(
                        Icons.account_circle_sharp,
                        color: CafeAppUI.buttonBackgroundColor,
                        size: 164,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Account Settings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
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
                        /*GestureDetector(
                          child: const Icon(
                            Icons.edit_rounded,
                            color: CafeAppUI.iconButtonIconColor,
                            size: 16,
                          ),
                        )*/
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("New Password"),
                        SizedBox(
                          width: 220,
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: newPassword,
                            validator: (value) {}, //TODO: Implement local password validation???
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Confirm Password"),
                        SizedBox(
                          width: 220,
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: confirmPassword,
                            validator: (value) {
                              if (value != newPassword.text) {
                                return "Ensure both passwords match!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (newPassword.text == confirmPassword.text) {
                            String res = await authService
                                .changePassword(newPassword.text);
                            if (res == "Success") {
                              //TODO: Handle Successful password change...
                            } else {
                              setState(() {
                                String errorString =
                                    res; //TODO: Implement Error string display
                              });
                            }
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(16)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
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
                              'This is a permanent action and cannot be undone! Are you sure you want to do this?'),
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
