import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0), //TODO: Move to a const file
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
            const TextField(),
            const TextField(),
            TextButton(
              onPressed: () => {},
              child: const Text("Register"),
            ),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(left:16, right: 16), //TODO: Move padding to a const file
                  child: Text("Or", textAlign: TextAlign.center),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),
            TextButton(
                onPressed: () => {}, child: const Text("Register with Facebook")),
            TextButton(
                onPressed: () => {}, child: const Text("Register with Google")),
            TextButton(onPressed: () => {}, child: const Text("Register with X"))
          ],
        ),
      ),
    );
  }
}
