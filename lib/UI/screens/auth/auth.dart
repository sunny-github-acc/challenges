import 'package:challenges/components/column.dart';
import 'package:flutter/material.dart';

import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';

import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoading = false;

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
  }

  void _navigateToSignupScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/signup');
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
          child: CustomColumn(
            children: [
              CustomButton(
                onPressed: () => _navigateToSignupScreen(context),
                text: 'Join',
                disabled: isLoading,
              ),
              CustomButton(
                type: ButtonType.secondary,
                text: 'Welcome back',
                disabled: isLoading,
                onPressed: () => _navigateToLoginScreen(context),
              ),
              CustomButton(
                type: ButtonType.transparent,
                text: 'Join with Google',
                icon: IconType.google,
                isLoading: isLoading,
                disabled: isLoading,
                onPressed: () => _loginGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
