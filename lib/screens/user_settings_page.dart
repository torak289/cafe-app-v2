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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("${user.email}"),
          Text("${user.uid}"),
          Text("${authService.appState}"),
        ],
      ),
    );
  }
}
