import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';

import 'package:challenges/services/auth/auth.dart';

class VerifyTheEmailAuth extends StatefulWidget {
  const VerifyTheEmailAuth({super.key});

  @override
  VerifyTheEmailState createState() => VerifyTheEmailState();
}

class VerifyTheEmailState extends State<VerifyTheEmailAuth> {
  final TextEditingController passwordController = TextEditingController();
  final email = FirebaseAuth.instance.currentUser?.email;
  bool isPassword = true;

  Future<void> _loginEmail(context) async {
    String password = passwordController.text.trim();

    setState(() {
      isPassword = password.isNotEmpty;
    });

    if (password.isEmpty) {
      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    await FirebaseAuth.instance.signOut();
    AuthService authService = AuthService();
    await authService.loginEmail(context, email, password);
  }

  Future<void> _rememberPassword(context) async {
    AuthService authService = AuthService();
    await authService.rememberPassword(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reenter your password',
      ),
      body: ContainerGradient(
        child: Center(
          child: Column(
            children: [
              CustomInput(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                isObscureText: true,
                isAutocorrect: false,
                isDisabled: !isPassword,
              ),
              CustomButton(
                onPressed: () => _rememberPassword(context),
                text: 'Forgot password?',
                type: ButtonType.transparent,
                size: ButtonSize.small,
              ),
              CustomButton(
                text: 'Verify',
                onPressed: () => _loginEmail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
