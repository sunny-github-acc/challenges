import 'package:flutter/material.dart';

import 'package:challenges/screens/auth/signupPassword.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';

import 'package:challenges/utils/helpers.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isUsername = true;
  bool isEmail = true;

  void _navigateToSignupPasswordScreen(
      BuildContext context, String username, String email) {
    if (username.isEmpty || email.isEmpty) {
      setState(() {
        isUsername = username.isNotEmpty;
        isEmail = email.isNotEmpty;
      });

      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    if (!isValidEmail(email)) {
      setState(() {
        isEmail = false;
      });

      return Modal.show(context, 'Oops', 'Please fill in a valid email');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SignupPassword(
                username: username,
                email: email,
              )),
    );
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
                labelText: 'Username',
                hintText: 'Enter your username',
                controller: userNameController,
                isDisabled: !isUsername,
              ),
              CustomInput(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isDisabled: !isEmail,
              ),
              CustomButton(
                text: 'Next',
                onPressed: () => _navigateToSignupPasswordScreen(
                  context,
                  userNameController.text.trim(),
                  emailController.text.trim(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
