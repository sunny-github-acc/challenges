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
import 'package:flutter/scheduler.dart';
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

    BlocProvider.of<AuthBloc>(context).add(
      AuthEventLogIn(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> _rememberPassword(context) async {
    String email = _emailController.text.trim();

    setState(() {
      isEmail = email.isNotEmpty;
    });

    if (!isValidEmail(email)) {
      return Modal.show(
        context,
        'Oops',
        'Please enter a valid email address where you would like the password reset link sent',
      );
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
      body: CustomContainer(
        child: CustomColumn(
          spacing: SpacingType.medium,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInput(
              hintText: 'Email',
              labelText: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              isDisabled: !isEmail,
            ),
            CustomInput(
              hintText: 'Password',
              labelText: 'Enter your password',
              controller: _passwordController,
              isObscureText: true,
              isAutocorrect: false,
              isDisabled: !isPassword,
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                bool isLoading =
                    state.isLoading && state.event is AuthEventRememberPassword;
                bool isRememberPassword =
                    state.event is AuthEventRememberPassword;
                bool isError = state.error != null;
                String email = _emailController.text.trim();

                if (!isLoading &&
                    !isError &&
                    isRememberPassword &&
                    isValidEmail(email)) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Modal.show(
                      context,
                      'Success',
                      'A password reset link has been sent to $email',
                    );
                  });
                }

                return CustomButton(
                  text: 'Forgot password?',
                  type: ButtonType.secondary,
                  size: ButtonSize.small,
                  isLoading: isLoading,
                  disabled: isLoading,
                  onPressed: () => _rememberPassword(context),
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                bool isLoading =
                    state.isLoading && state.event is AuthEventLogIn;

                return CustomButton(
                  text: 'Login',
                  isLoading: isLoading,
                  disabled: isLoading,
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
