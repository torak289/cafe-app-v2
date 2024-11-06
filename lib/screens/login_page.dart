import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  late String errorString = '';

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Builder(builder: (context) {
        if (authService.appState == AppState.Authenticating) {
          return const Center(
            //TODO: Improve look/feel of progress indicator location etc...
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          return Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: CafeAppUI.screenVertical, horizontal: CafeAppUI.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
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
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email!';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email!';
                            }
                            return null;
                          },
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password!';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        Builder(builder: (context) {
                          if (errorString.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  errorString,
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
                        }),
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              String response = await authService.emailLogin(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (context.mounted) {
                                if (response == 'Success') {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    errorString = response;
                                  });
                                }
                              }
                            }
                          },
                          child: const Text("Login"),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
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
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
                        TextButton(
                          onPressed: () => authService.facebookSSO(),
                          child: const Row(
                            children: [
                              Icon(Icons.facebook_rounded),
                              Padding(padding: EdgeInsets.all(8)),
                              Text("Login with Facebook"),
                            ],
                          ),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        TextButton(
                          onPressed: () => authService.googleSSO(),
                          child: const Row(
                            children: [
                              Icon(Icons.circle),
                              Padding(padding: EdgeInsets.all(8)),
                              Text("Login with Google"),
                            ],
                          ),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        TextButton(
                          onPressed: () => authService.twitterSSO(),
                          child: const Row(
                            children: [
                              Icon(Icons.circle),
                              Padding(padding: EdgeInsets.all(8)),
                              Text("Login with Twitter / X"),
                            ],
                          ),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
