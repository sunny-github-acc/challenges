import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/container_gradient.dart';

class Home extends StatelessWidget {
  final bool isEmailVerified;
  final User? user;

  Home()
      : user = FirebaseAuth.instance.currentUser,
        isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isEmailVerified ? 'Hello' : 'Please verify your email'),
              ButtonCustom(
                type: ButtonType.secondary,
                text: 'Logout',
                onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
