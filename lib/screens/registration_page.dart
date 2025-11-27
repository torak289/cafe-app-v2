import 'dart:io';

import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/share_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  late String errorString = '';

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: true);
    final SharePrefService sharePrefService =
        Provider.of(context, listen: true);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Builder(builder: (context) {
        if (authService.appState == AppState.Authenticated) {
          if (context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted && Navigator.canPop(context)) {
                sharePrefService.setHasAccount(true);
                Navigator.pop(context);
              }
            });
          }
        }
        if (authService.appState == AppState.Registering) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CafeAppUI.screenVertical,
              horizontal: CafeAppUI.screenHorizontal,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please confirm your email address, before clicking below',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:
                      EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingMedium),
                ),
                TextButton(
                  onPressed: () async {
                    sharePrefService.setHasAccount(true);
                    await authService.emailLogin(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        }
        if (authService.appState == AppState.Authenticating) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingMedium),
              ),
              Text('Authenticating...'),
            ],
          );
        } else {
          return Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: CafeAppUI.screenVertical,
                        horizontal: CafeAppUI.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/Cafe_Logo.png', scale: 2),
                        const Text(
                          "Welcome to Robusta!",
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
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email!';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]+)+$")
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
                          autocorrect: false,
                          validator: (value) {
                            //TODO: Implement local password validation???
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
                              String response = await authService.emailRegister(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (context.mounted) {
                                if (response == 'Success') {
                                  //Navigator.pop(context);
                                } else {
                                  setState(() {
                                    errorString = response;
                                  });
                                }
                              }
                            }
                          },
                          child: const Text("Register"),
                        ),
                        const Padding(
                            padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingMedium)),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              sharePrefService.setHasAccount(true);
                              Navigator.popAndPushNamed(
                                context,
                                Routes.loginPage,
                              );
                            },
                            child: Text(
                              'Already have an account? Click here to login',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(CafeAppUI.buttonSpacingLarge),
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
                        Builder(builder: (context) {
                          if (Platform.isIOS) {
                            return Column(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.all(
                                        CafeAppUI.buttonSpacingLarge)),
                                TextButton(
                                  onPressed: () async {
                                    final response =
                                        await authService.appleSSO();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.apple_rounded,
                                        size: 24,
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Text("Register with Apple"),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                        TextButton(
                          onPressed: () async {
                            final response = await authService.googleSSO();
                          },
                          child: Row(
                            children: [
                              Image.asset('assets/images/google-logo.png',
                                  scale: 24),
                              Padding(padding: EdgeInsets.all(8)),
                              Text("Register with Google"),
                            ],
                          ),
                        ),
                        const Padding(
                            padding:
                                EdgeInsets.all(CafeAppUI.buttonSpacingLarge)),
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
