import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();

  bool isUsername = true;
  bool isEmail = true;
  bool isPassword = true;
  bool isPasswordRepeat = true;

  Future<void> _signup(context) async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String passwordRepeat = passwordRepeatController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordRepeat.isEmpty) {
      setState(() {
        isUsername = username.isNotEmpty;
        isEmail = email.isNotEmpty;
        isPassword = password.isNotEmpty;
        isPasswordRepeat = password.isNotEmpty;
      });

      return Modal.show(
        context,
        'Oops',
        'Please fill out all input fields',
      );
    }

    if (!isValidEmail(email)) {
      setState(() {
        isEmail = false;
      });

      return Modal.show(context, 'Oops', 'Please fill in a valid email');
    }

    if (password != passwordRepeat) {
      setState(() {
        isPasswordRepeat = false;
      });

      return Modal.show(context, 'Oops', 'Passwords should match');
    }

    BlocProvider.of<AuthBloc>(context).add(
      AuthEventRegister(
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nice to meet you',
      ),
      body: CustomContainer(
        child: CustomColumn(
          spacing: SpacingType.medium,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInput(
              hintText: 'Username',
              labelText: 'Enter your username',
              controller: usernameController,
              isDisabled: !isUsername,
            ),
            CustomInput(
              hintText: 'Email',
              labelText: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              isDisabled: !isEmail,
            ),
            CustomInput(
              hintText: 'Password',
              labelText: 'Enter your password',
              controller: passwordController,
              isObscureText: true,
              isAutocorrect: false,
              isDisabled: !isPassword,
            ),
            CustomInput(
              hintText: 'Repeat Password',
              labelText: 'Repeat your password',
              controller: passwordRepeatController,
              isObscureText: true,
              isAutocorrect: false,
              isDisabled: !isPasswordRepeat,
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  isFullWidth: true,
                  text: 'Sign up',
                  onPressed: () => _signup(context),
                  isLoading: state.isLoading,
                  disabled: state.isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
