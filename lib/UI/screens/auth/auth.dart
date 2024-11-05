import 'package:challenges/UI/router/router.dart';
import 'package:challenges/components/card.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/divider.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/utils/colors.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isGoogle = state.event is AuthEventGoogleLogIn;
        bool isLoadingGoogle = state.isLoading && isGoogle;
        bool isLoadingLogIn = state.isLoading && state.event is AuthEventLogIn;
        bool isRememberPassword = state.event is AuthEventRememberPassword;
        bool isLoadingRememberPassword = state.isLoading && isRememberPassword;
        bool isLoading =
            isLoadingGoogle || isLoadingLogIn || isLoadingRememberPassword;

        return Scaffold(
          backgroundColor: colorMap['blue']!,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomContainer(
                          colors: [
                            colorMap['blue']!,
                            colorMap['white']!,
                          ],
                          isSingleChildScrollView: false,
                          isFull: true,
                          child: CustomColumn(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomCard(
                                child: CustomRow(
                                  spacing: SpacingType.small,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      width: 100.0,
                                      height: 100.0,
                                    ),
                                    const CustomText(
                                      fontSize: FontSizeType.large,
                                      text:
                                          'Thrive by setting and achieving challenges together',
                                    ),
                                  ],
                                ),
                              ),
                              CustomCard(
                                child: CustomColumn(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: SpacingType.medium,
                                  children: [
                                    CustomButton(
                                      isFullWidth: true,
                                      text: 'Log in',
                                      isLoading: isLoadingLogIn,
                                      disabled: isLoading,
                                      onPressed: () =>
                                          _navigateToLoginScreen(context),
                                    ),
                                    CustomButton(
                                      type: ButtonType.secondary,
                                      isFullWidth: true,
                                      text: 'Create new account',
                                      isLoading: isLoadingLogIn,
                                      disabled: isLoading,
                                      onPressed: () =>
                                          _navigateToSignupScreen(context),
                                    ),
                                    const CustomDivider(
                                      text: 'or',
                                    ),
                                    CustomButton(
                                      isFullWidth: true,
                                      type: ButtonType.secondary,
                                      text: 'Continue with Google',
                                      icon: IconType.google,
                                      isLoading: isLoadingGoogle,
                                      disabled: isLoading,
                                      onPressed: () => _loginGoogle(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
