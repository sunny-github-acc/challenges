import 'package:flutter/material.dart';

import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/utils/helpers.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';

class SignupPassword extends StatefulWidget {
  final String username;
  final String email;

  const SignupPassword({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  _SignupPasswordState createState() => _SignupPasswordState();
}

class _SignupPasswordState extends State<SignupPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final Debounce _debounce = Debounce();

  bool isPassword = true;
  bool isPasswordRepeat = true;

  Future<void> _signup(context) async {
    String username = widget.username;
    String email = widget.email;
    String password = passwordController.text.trim();
    String passwordRepeat = passwordRepeatController.text.trim();

    if (password.isEmpty || passwordRepeat.isEmpty) {
      setState(() {
        isPassword = password.isNotEmpty;
        isPasswordRepeat = password.isNotEmpty;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nice to meet you',
      ),
      body: ContainerGradient(
        child: Center(
          child: Column(
            children: [
              CustomInput(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                obscureText: true,
                disabled: !isPassword,
              ),
              CustomInput(
                labelText: 'Repeat Password',
                hintText: 'Repeat your password',
                controller: passwordRepeatController,
                obscureText: true,
                disabled: !isPasswordRepeat,
              ),
              CustomButton(
                text: 'Signup',
                onPressed: () => _debounce.run(() => _signup(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
