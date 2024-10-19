import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';
import 'package:challenges/UI/screens/auth/signup_password.dart';
import 'package:challenges/UI/screens/home/create_challenge.dart';
import 'package:challenges/UI/screens/home/priorities.dart';
import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/menu.dart';
import 'package:challenges/UI/screens/home/user_profile.dart';
import 'package:challenges/UI/screens/home/privacy_policy.dart';
import 'package:challenges/UI/screens/home/terms_of_use.dart';
import 'package:challenges/UI/screens/home/tribe_add.dart';
import 'package:challenges/UI/screens/home/tribe_join.dart';
import 'package:challenges/UI/screens/home/update_challenge.dart';
import 'package:challenges/UI/screens/home/verify_email.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String auth = '/';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String addTribe = '/add-tribe';
  static const String joinTribe = '/join-tribes';
  static const String priorities = '/priorities';
  static const String termsOfUse = '/terms-of-use';
  static const String verifyEmail = '/verify-email';
  static const String userProfile = '/user-profile';
  static const String privacyPolicy = '/privacy-policy';
  static const String signupPassword = '/signup-password';
  static const String createChallenge = '/create-challenge';
  static const String updateChallenge = '/update-challenge';
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
          builder: (context) => const Home(),
        );
      case Routes.menu:
        return MaterialPageRoute(
          builder: (context) => const Menu(),
        );
      case Routes.userProfile:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => UserProfile(
            collection: arguments,
          ),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case Routes.signup:
        return MaterialPageRoute(
          builder: (context) => const Signup(),
        );
      case Routes.termsOfUse:
        return MaterialPageRoute(
          builder: (context) => const TermsOfUse(),
        );
      case Routes.privacyPolicy:
        return MaterialPageRoute(
          builder: (context) => const PrivacyPolicy(),
        );
      case Routes.priorities:
        return MaterialPageRoute(
          builder: (context) => const Priorities(),
        );
      case Routes.addTribe:
        return MaterialPageRoute(
          builder: (context) => const AddTribe(),
        );
      case Routes.joinTribe:
        return MaterialPageRoute(
          builder: (context) => const JoinTribe(),
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
      case Routes.updateChallenge:
        return MaterialPageRoute(
          builder: (context) => const UpdateChallenge(),
        );
      default:
        return null;
    }
  }
}
