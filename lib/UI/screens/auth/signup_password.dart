import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/input.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPassword extends StatefulWidget {
  const SignupPassword({
    Key? key,
  }) : super(key: key);

  @override
  SignupPasswordState createState() => SignupPasswordState();
}

class SignupPasswordState extends State<SignupPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();

  bool isPassword = true;
  bool isPasswordRepeat = true;

  Future<void> _signup(context) async {
    String password = passwordController.text.trim();
    String passwordRepeat = passwordRepeatController.text.trim();

    if (password.isEmpty || passwordRepeat.isEmpty) {
      setState(() {
        isPassword = password.isNotEmpty;
        isPasswordRepeat = password.isNotEmpty;
      });

      return Modal.show(context, 'Oops', 'Please fill out all input fields');
    }

    if (password != passwordRepeat) {
      setState(() {
        isPasswordRepeat = false;
      });

      return Modal.show(context, 'Oops', 'Passwords should match');
    }

    BlocProvider.of<AuthBloc>(context).add(AuthEventRegister(
      password: password,
    ));
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
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                isObscureText: true,
                isAutocorrect: false,
                isDisabled: !isPassword,
              ),
              CustomInput(
                labelText: 'Repeat Password',
                hintText: 'Repeat your password',
                controller: passwordRepeatController,
                isObscureText: true,
                isAutocorrect: false,
                isDisabled: !isPasswordRepeat,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Signup',
                    onPressed: () => _signup(context),
                    isLoading: state.isLoading,
                    disabled: state.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
