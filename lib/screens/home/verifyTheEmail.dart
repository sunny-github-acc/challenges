import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/screens/auth/verifyTheEmailAuth.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/modal.dart';

class VerifyTheEmail extends StatelessWidget {
  final User? user;

  VerifyTheEmail({super.key}) : user = FirebaseAuth.instance.currentUser;

  void _resendVerificationEmail(context) async {
    try {
      await user?.sendEmailVerification();

      return Modal.show(context, 'Success', 'Verification email has been send');
    } catch (e) {
      print(e);
    }
  }

  void _checkTheEmail(context) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyTheEmailAuth()
        ),
      );    } catch (e) {
      Modal.show(context, 'Oops', 'Check again if your email has been verified');
    }
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
                    const Text('The email is not yet verified. Please check your email for a verification link.'),
                    ButtonCustom(
                      type: ButtonType.secondary,
                      text: "I've verified the email",
                      onPressed: () => _checkTheEmail(context),
                    ),
                    ButtonCustom(
                      type: ButtonType.secondary,
                      text: 'Resend the verification email',
                      onPressed: () => _resendVerificationEmail(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}