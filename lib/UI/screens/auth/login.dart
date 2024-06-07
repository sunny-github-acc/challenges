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

    BlocProvider.of<AuthBloc>(context).add(AuthEventLogIn(
      email: email,
      password: password,
    ));
  }

  Future<void> _rememberPassword(context) async {
    String email = _emailController.text.trim();

    setState(() {
      isEmail = email.isNotEmpty;
    });

    if (!isValidEmail(email)) {
      return Modal.show(context, 'Oops', 'Please enter a valid email');
    }

    BlocProvider.of<AuthBloc>(context).add(AuthEventRememberPassword(
      email: email,
    ));
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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Forgot password?',
                  type: ButtonType.transparent,
                  size: ButtonSize.small,
                  isLoading: state.isLoading &&
                      state.event is AuthEventRememberPassword,
                  onPressed: () => _rememberPassword(context),
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Login',
                  isLoading: state.isLoading && state.event is AuthEventLogIn,
                  onPressed: () => _loginEmail(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
