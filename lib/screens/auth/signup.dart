import 'package:flutter/material.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';

import 'package:challenges/services/auth/auth.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController = TextEditingController();

  bool isUsername = false;
  bool isEmail = false;
  bool isPassword = false;
  bool isPasswordRepeat = false;

  Future<void> _signup(context) async {
    String username = userNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String passwordRepeat = passwordRepeatController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || passwordRepeat.isEmpty) {
      setState(() {
        isUsername = !username.isEmpty;
        isEmail = !email.isEmpty;
        isPassword = !password.isEmpty;
        isPasswordRepeat = !password.isEmpty;
      });

      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    if (password != passwordRepeat) {
      setState(() {
        isPasswordRepeat = false;
      });

      return Modal.show(context, 'Oops', 'Passwords should match');
    }

    AuthService authService = AuthService();
    await authService.signupEmail(context, username, email, password);
  }

  Future<void> _loginGoogle(context) async {
    AuthService authService = AuthService();
    await authService.loginGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nice to meet you',
      ),
      body: ContainerGradient(
        child: Center(
          child: Column(
            children: [
              InputCustom(
                labelText: 'Username',
                hintText: 'Enter your username',
                controller: userNameController,
                disabled: isUsername,
              ),
              InputCustom(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                disabled: isEmail,
              ),
              InputCustom(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                obscureText: true,
                disabled: isPassword,
              ),
              InputCustom(
                labelText: 'Repeat Password',
                hintText: 'Repeat your password',
                controller: passwordRepeatController,
                obscureText: true,
                disabled: isPasswordRepeat,
              ),
              ButtonCustom(
                text: 'Signup',
                onPressed: () => _signup(context),
              ),
              ButtonCustom(
                type: ButtonType.secondary,
                text: 'Signup with google',
                icon: IconType.google,
                onPressed: () => _loginGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
