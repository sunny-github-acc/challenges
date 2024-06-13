import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  void _resendVerificationEmail(context) {
    BlocProvider.of<AuthBloc>(context)
        .add(const AuthEventResendVerificationEmail());
  }

  void _verifyEmail(context) {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventVerifyEmail());
  }

  void _logout(context) {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventLogOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerGradient(
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'The email is not yet verified. Please check your email for a verification link.'),
                    CustomButton(
                      type: ButtonType.secondary,
                      text: "I've verified the email",
                      onPressed: () => _verifyEmail(context),
                      // handle loading
                    ),
                    CustomButton(
                      type: ButtonType.secondary,
                      text: 'Resend', // the verification email',
                      onPressed: () => _resendVerificationEmail(context),
                      // handle loading
                    ),
                    CustomButton(
                      text: 'Logout',
                      onPressed: () => _logout(context),
                      // handle loading
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
