import 'package:barcode_widget/barcode_widget.dart';
import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/widgets/loyalty_card.dart';
import 'package:cafeapp_v2/widgets/profile/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            vertical: CafeAppUI.screenVertical,
            horizontal: CafeAppUI.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/Cafe_Logo.png', scale: 2),
            const Text(
              "Welcome back!",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.left,
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextField(
              controller: emailController,
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextField(
              controller: passwordController,
              obscureText: true,
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextButton(
              onPressed: () async => {
                await authService.emailLogin(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                ),
                if (context.mounted)
                  {
                    Navigator.pop(context),
                  }
              },
              child: const Text("Login"),
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(
                      left: CafeAppUI.screenHorizontal,
                      right: CafeAppUI.screenHorizontal),
                  child: Text("Or", textAlign: TextAlign.center),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
            TextButton(
              onPressed: () => {},
              child: const Text("Login with Facebook"),
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextButton(
              onPressed: () => {},
              child: const Text("Login with Google"),
            ),
            const Padding(
                padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            TextButton(
              onPressed: () => {},
              child: const Text("Login with X"),
            )
          ],
        ),
      ),
    );
  }
}
