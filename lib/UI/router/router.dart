import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';
import 'package:challenges/UI/screens/auth/verifyTheEmailAuth.dart';
import 'package:flutter/material.dart';

import 'package:challenges/main.dart';

import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/menu.dart';
import 'package:challenges/UI/screens/auth/auth.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(
      RouteSettings settings, AuthNotifier authNotifier) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) =>
              authNotifier.user?.uid == null ? const Auth() : Home(),
        );
      case '/menu':
        return MaterialPageRoute(
          builder: (_) => const Menu(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const Signup(),
        );
      case '/verifyEmail':
        return MaterialPageRoute(
          builder: (_) => const VerifyTheEmailAuth(),
        );
      default:
        return null;
    }
  }
}
