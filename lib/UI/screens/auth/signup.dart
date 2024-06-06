import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isUsername = true;
  bool isEmail = true;

  void _navigateToSignupPasswordScreen(
    BuildContext context,
    String username,
    String email,
  ) {
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

    BlocProvider.of<AuthBloc>(context).add(AuthEventSaveName(
      username: username,
      email: email,
    ));
    Navigator.of(context).pushNamed(Routes.signupPassword);
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
                controller: usernameController,
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
                  usernameController.text.trim(),
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
