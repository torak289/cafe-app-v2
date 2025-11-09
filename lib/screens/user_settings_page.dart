import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSettingsPage extends StatefulWidget {
  UserSettingsPage({super.key});
  late String errorString = "";
  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  Future<void> _launchInAppBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context, listen: false);
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmPassword = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(CafeAppUI.screenHorizontal, 0,
              CafeAppUI.screenHorizontal, CafeAppUI.screenVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                      const Center(
                        child: Icon(
                          Icons.account_circle_sharp,
                          color: CafeAppUI.buttonBackgroundColor,
                          size: 164,
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
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
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Padding(
                                  padding: EdgeInsets.all(
                                      CafeAppUI.buttonSpacingMedium)),
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
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
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
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
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
                              validator:
                                  (value) {}, //TODO: Implement local password validation???
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Confirm Password"),
                          SizedBox(
                            width: 220,
                            child: TextFormField(
                              //TODO: Implement on keyboard enter action submit
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
                      const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                      Builder(
                        //TODO: Fix reformatting issue on error text shown...
                        builder: (context) {
                          if (widget.errorString.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.errorString,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(
                                        CafeAppUI.buttonSpacingMedium)),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (newPassword.text == confirmPassword.text) {
                              String res = await authService
                                  .changePassword(newPassword.text);
                              if (res == "Success") {
                                if (context.mounted) {
                                  //TODO: Handle Successful password change...
                                  Navigator.popUntil(context,
                                      (Route<dynamic> route) => route.isFirst);
                                  debugPrint("Password Changed");
                                }
                              } else {
                                setState(() {
                                  debugPrint(res);
                                  widget.errorString =
                                      res; //TODO: Implement Error string display
                                });
                              }
                            } else {
                              debugPrint("Passwords do not match!");
                              setState(() {
                                widget.errorString = "Passwords do not match!";
                              });
                            }
                          },
                          child: const Text("Change Password"),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final Uri toLaunch = Uri(
                                  scheme: 'https',
                                  host: 'robusta-app.com',
                                  path: '/privacy');
                              _launchInAppBrowser(toLaunch);
                            },
                            child: const Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Padding(
                              padding:
                                  EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                          GestureDetector(
                            onTap: () {
                              final Uri toLaunch = Uri(
                                  scheme: 'https',
                                  host: 'robusta-app.com',
                                  path: '/terms-conditions');
                              _launchInAppBrowser(toLaunch);
                            },
                            child: const Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                      child: Text('Logout')),
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
      ),
    );
  }
}
