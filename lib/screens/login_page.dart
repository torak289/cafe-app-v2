import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    final UserModel? user = Provider.of(context, listen: false);
    if (authService.appState == AppState.Authenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('${authService.appState}'),
              Text('${user?.email}'),
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
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0), //TODO: Move to a const file
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
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
                        left: AppColours.screenHorizontal,
                        right: AppColours.screenHorizontal),
                    child: Text("Or", textAlign: TextAlign.center),
                  ),
                  Expanded(child: Divider(color: Colors.black)),
                ],
              ),
              TextButton(
                  onPressed: () => {}, child: Text("Login with Facebook")),
              TextButton(onPressed: () => {}, child: Text("Login with Google")),
              TextButton(onPressed: () => {}, child: Text("Login with X"))
            ],
          ),
        ),
      );
    }
  }
}
