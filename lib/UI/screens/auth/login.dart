import 'package:flutter/material.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/column.dart';

import 'package:challenges/services/auth/auth.dart';

import 'package:challenges/utils/helpers.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isEmail = true;
  bool isPassword = true;
  bool isLoadingRememberPassword = false;
  bool isLoadingLogin = false;

  Future<void> _loginEmail(context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      isEmail = email.isNotEmpty;
      isPassword = password.isNotEmpty;
    });

    if (email.isEmpty || password.isEmpty) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    setState(() {
      isLoadingLogin = true;
    });

    AuthService authService = AuthService();
    await authService.loginEmail(context, email, password);

    setState(() {
      isLoadingLogin = false;
    });
  }

  Future<void> _rememberPassword(context) async {
    String email = _emailController.text.trim();

    if (!isValidEmail(email)) {
      return Modal.show(context, 'Oops', 'Please enter a valid email');
    }
    setState(() {
      isLoadingRememberPassword = true;
    });

    AuthService authService = AuthService();
    await authService.rememberPassword(context, email);

    setState(() {
      isLoadingRememberPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Welcome back',
      ),
      body: ContainerGradient(
        child: CustomColumn(
          children: [
            CustomInput(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              isDisabled: !isEmail,
            ),
            CustomInput(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: _passwordController,
              isObscureText: true,
              isAutocorrect: false,
              isDisabled: !isPassword,
            ),
            CustomButton(
              text: 'Forgot password?',
              type: ButtonType.transparent,
              size: ButtonSize.small,
              isLoading: isLoadingRememberPassword,
              onPressed: () => _rememberPassword(context),
            ),
            CustomButton(
              text: 'Login',
              isLoading: isLoadingLogin,
              onPressed: () => _loginEmail(context),
            ),
          ],
        ),
      ),
    );
  }
}
