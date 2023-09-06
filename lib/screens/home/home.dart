import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/screens/home/createChallenge.dart';

import 'package:challenges/components/button.dart';
import 'package:challenges/components/button_floating.dart';
import 'package:challenges/components/container_gradient.dart';

class Home extends StatelessWidget {
  final bool isEmailVerified;
  final User? user;

  Home({super.key})
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

  void _navigateToCreateChallengeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateChallenge()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerGradient(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          isEmailVerified ? 'Hello' : 'Please verify your email'),
                      ButtonCustom(
                        type: ButtonType.secondary,
                        text: 'Logout',
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ),
              )
            ),
            FloatingButton(
              onPressed: () => _navigateToCreateChallengeScreen(context),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }}