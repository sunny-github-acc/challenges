import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:challenges/screens/auth/auth.dart';
import 'package:challenges/screens/home/home.dart';
import 'package:challenges/screens/home/verifyTheEmail.dart';

class AuthNotifier extends ChangeNotifier {
  User? user;

  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.user = user;
      notifyListeners();
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Consumer<AuthNotifier>(
        builder: (context, authNotifier, child) {
          if (authNotifier.user?.uid == null) {
            return const Auth();
          }

          if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
            return VerifyTheEmail();
          }

          return Home();
        },
      ),
    );
  }
}
