import 'package:barcode_widget/barcode_widget.dart';
import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/widgets/loyalty_card.dart';
import 'package:cafeapp_v2/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    if (authService.appState == AppState.Authenticated) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: CafeAppUI.screenVertical, horizontal: CafeAppUI.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoyaltyCard(),
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
              ProfileTabs(),
              TextButton(
                onPressed: () {
                  authService.signOut();
                  Navigator.pop(context);
                },
                child: const Text('Logout'),
              ),
              Text('${authService.appState}', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: CafeAppUI.screenVertical, horizontal: CafeAppUI.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/Cafe_Logo.png', scale: 2),
              const Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              TextField(
                controller: emailController,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
              ),
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
              TextButton(
                onPressed: () => {},
                child: Text("Login with Facebook"),
              ),
              TextButton(
                onPressed: () => {},
                child: Text("Login with Google"),
              ),
              TextButton(
                onPressed: () => {},
                child: Text("Login with X"),
              )
            ],
          ),
        ),
      );
    }
  }
}
