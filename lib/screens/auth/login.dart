import 'package:flutter/material.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';

import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/utils/helpers.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Debounce _debounce = Debounce();
  bool isEmail = true;
  bool isPassword = true;

  Future<void> _loginEmail(context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      isEmail = email.isNotEmpty;
      isPassword = password.isNotEmpty;
    });

    if (email.isEmpty || password.isEmpty) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    AuthService authService = AuthService();
    await authService.loginEmail(context, email, password);
  }

  Future<void> _rememberPassword(context) async {
    String email = emailController.text.trim();

    if (!isValidEmail(email)) {
      return Modal.show(context, 'Oops', 'Please enter a valid email');
    }

    AuthService authService = AuthService();
    await authService.rememberPassword(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Welcome back',
      ),
      body: ContainerGradient(
        child: Center(
          child: Column(
            children: [
              CustomInput(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                disabled: !isEmail,
              ),
              CustomInput(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                obscureText: true,
                disabled: !isPassword,
              ),
              CustomButton(
                onPressed: () =>
                    _debounce.run(() => _rememberPassword(context)),
                text: 'Forgot password?',
                type: ButtonType.transparent,
                size: ButtonSize.small,
              ),
              CustomButton(
                text: 'Login',
                onPressed: () => _debounce.run(() => _loginEmail(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
