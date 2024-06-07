import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.login);
  }

  void _navigateToSignupScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.signup);
  }

  Future<void> _loginGoogle() async {
    context.read<AuthBloc>().add(const AuthEventGoogleLogIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerGradient(
        child: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading =
                  state.isLoading && state.event is AuthEventGoogleLogIn;

              return CustomColumn(
                children: [
                  CustomButton(
                    onPressed: () => _navigateToSignupScreen(context),
                    text: 'Join',
                    disabled: isLoading,
                  ),
                  CustomButton(
                    type: ButtonType.secondary,
                    text: 'Welcome back',
                    disabled: isLoading,
                    onPressed: () => _navigateToLoginScreen(context),
                  ),
                  CustomButton(
                    type: ButtonType.transparent,
                    text: 'Join with Google',
                    icon: IconType.google,
                    isLoading: isLoading,
                    disabled: isLoading,
                    onPressed: () => _loginGoogle(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
