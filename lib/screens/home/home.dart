import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/screens/home/createChallenge.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button_floating.dart';
import 'package:challenges/components/container_gradient.dart';

class Home extends StatelessWidget {
  final User? user;

  Home({super.key}) : user = FirebaseAuth.instance.currentUser;

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
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
      appBar: CustomAppBar(
        actions: [
          GestureDetector(
            onTap: _logout,
            child: user?.photoURL != null ?
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  child: ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    width: 50,
                    height: 10,
                    fit: BoxFit.cover,
                  )
              )) :
              Image.asset('assets/grow.png'),
          ),
        ],
        leftButton:
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle right button tap
            },
          ),
      ),
      body: ContainerGradient(
        child: Column(
          children: [
            const Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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