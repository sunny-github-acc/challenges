import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  void _resendVerificationEmail(context) {
    BlocProvider.of<AuthBloc>(context).add(
      const AuthEventResendVerificationEmail(),
    );
  }

  void _verifyEmail(context) {
    BlocProvider.of<AuthBloc>(context).add(
      const AuthEventVerifyEmail(),
    );
  }

  void _logout(context) {
    BlocProvider.of<AuthBloc>(context).add(
      const AuthEventLogOut(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Verify Email',
      ),
      body: CustomContainer(
        child: CustomColumn(
          spacing: SpacingType.medium,
          children: [
            const CustomText(
              text:
                  'You need to verify your email before you can create challenges. Please check your email and click the link to verify your email.',
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading =
                    state.isLoading && state.event is AuthEventVerifyEmail;

                return CustomButton(
                  text: "I've verified the email",
                  onPressed: () => _verifyEmail(context),
                  isLoading: isLoading,
                  disabled: isLoading,
                  // handle loading
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state.isLoading &&
                    state.event is AuthEventResendVerificationEmail;

                return CustomButton(
                  type: ButtonType.secondary,
                  text: 'Resend verification email',
                  onPressed: () => _resendVerificationEmail(context),
                  isLoading: isLoading,
                  disabled: isLoading,
                  // handle loading
                );
              },
            ),
            CustomButton(
              text: 'Logout',
              onPressed: () => _logout(context),
              type: ButtonType.secondary,
              // handle loading
            ),
          ],
        ),
      ),
    );
  }
}
