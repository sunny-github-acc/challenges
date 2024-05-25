import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';
import 'package:challenges/UI/screens/auth/verify_email_auth.dart';
import 'package:challenges/UI/screens/home/create_challenge.dart';
import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/menu.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String auth = '/';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String login = '/login';
  static const String signup = '/signup';
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
      case Routes.verifyEmail:
        return MaterialPageRoute(
          builder: (context) => const VerifyEmailAuth(),
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


//   /// Removes all screens and then pushes the given screen
//   static void pushThisRemoveRest({
//     required BuildContext context,
//     required String pageName,
//   }) {
//     // If navigator can remove current screen, removes it
//     if (Navigator.of(context).canPop()) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         pageName,
//         (route) => false, // false --> remove all screens
//       );
//     } else {
//       // left no screen to remove, therefore pushes the given screen
//       push(context: context, pageName: pageName);
//     }

//     Navigator.of(context).pushNamedAndRemoveUntil(pageName, (route) => false);
//   }

//   /// Removes all screens and then pushes the given screen with arguments
//   static void pushThisRemoveRestWithArguments({
//     required BuildContext context,
//     required String pageName,
//     required Object args,
//   }) {
//     // If navigator can remove current screen, removes it
//     if (Navigator.of(context).canPop()) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         pageName,
//         (route) => false,
//         arguments: args,
//       );
//     } else {
//       // left no screen to remove, then push the given screen
//       push(context: context, pageName: pageName);
//     }
//   }

//   /// Pushes given page
//   static void push({required BuildContext context, required String pageName}) {
//     Navigator.of(context).pushNamed(pageName);
//   }

//   /// Pushes given page with arguments
//   static void pushWithArgument({
//     required BuildContext context,
//     required String pageName,
//     required Object args,
//   }) {
//     Navigator.of(context).pushNamed(pageName, arguments: args);
//   }
// }