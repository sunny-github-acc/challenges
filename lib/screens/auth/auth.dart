import 'package:flutter/material.dart';

import 'package:challenges/screens/auth/login.dart';
import 'package:challenges/screens/auth/signup.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
  }

  void _navigateToSignupScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerGradient(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(''),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/grow.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                Column(
                  children: [
                    ButtonCustom(
                      onPressed: () => _navigateToSignupScreen(context),
                      text: 'Join',
                    ),
                    ButtonCustom(
                      type: ButtonType.secondary,
                      text: 'Welcome back',
                      onPressed: () => _navigateToLoginScreen(context),
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