import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenges/screens/home/createChallenge.dart';
import 'package:challenges/screens/home/dashboard.dart';

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
      if (kDebugMode) {
        print(e);
      }
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
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                width: 50,
                height: 10,
                child: user?.photoURL == 'null' || user?.photoURL == null
                    ? Image.asset(
                        'assets/grow.png',
                        width: 50,
                        height: 10,
                      )
                    : ClipOval(
                        child: Image.network(
                        user!.photoURL!,
                        width: 50,
                        height: 10,
                        fit: BoxFit.cover,
                      ))),
          ),
        ],
        leftButton: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle right button tap
          },
        ),
      ),
      body: ContainerGradient(
        child: Column(
          children: [
            const Expanded(
              child: Dashboard(),
            ),
            FloatingButton(
              onPressed: () => _navigateToCreateChallengeScreen(context),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
