import 'package:flutter/material.dart';

import 'package:challenges/screens/auth/login.dart';
import 'package:challenges/screens/auth/signup.dart';

import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoading = false;

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const login()),
    );
  }

  void _navigateToSignupScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  Future<void> _loginGoogle(context) async {
    setState(() {
      isLoading = true;
    });

    AuthService authService = AuthService();
    await authService.loginGoogle(context);

    setState(() {
      isLoading = false;
    });
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
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/grow.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              Column(
                children: [
                  CustomButton(
                    onPressed: () => _navigateToSignupScreen(context),
                    text: 'Join',
                  ),
                  CustomButton(
                    type: ButtonType.secondary,
                    text: 'Welcome back',
                    onPressed: () => _navigateToLoginScreen(context),
                  ),
                  CustomButton(
                    type: ButtonType.transparent,
                    text: 'Join with Google',
                    icon: IconType.google,
                    isLoading: isLoading,
                    onPressed: () => _loginGoogle(context),
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
