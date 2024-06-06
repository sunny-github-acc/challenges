import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';
import 'package:challenges/UI/screens/auth/signup_password.dart';
import 'package:challenges/UI/screens/home/create_challenge.dart';
import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/menu.dart';
import 'package:challenges/UI/screens/home/verify_email.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String auth = '/';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupPassword = '/signup-password';
  static const String verifyEmail = '/verifyEmail';
  static const String createChallenge = '/createChallenge';
}

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.auth:
        return MaterialPageRoute(
          builder: (context) => const Auth(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => Home(),
        );
      case Routes.menu:
        return MaterialPageRoute(
          builder: (context) => const Menu(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case Routes.signup:
        return MaterialPageRoute(
          builder: (context) => const Signup(),
        );
      case Routes.signupPassword:
        return MaterialPageRoute(
          builder: (context) => const SignupPassword(),
        );
      case Routes.verifyEmail:
        return MaterialPageRoute(
          builder: (context) => const VerifyEmail(),
        );
      case Routes.createChallenge:
        return MaterialPageRoute(
          builder: (context) => const CreateChallenge(),
        );
      default:
        return null;
    }
  }
}
