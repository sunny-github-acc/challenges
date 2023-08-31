import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:challenges/screens/auth/auth.dart';
import 'package:challenges/screens/home/home.dart';

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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Consumer<AuthNotifier>(
        builder: (context, authNotifier, child) {
          print('User:');
          print(authNotifier.user);
          return authNotifier.user?.uid == null ? Auth() : Home();
        },
      ),
    );
  }
}