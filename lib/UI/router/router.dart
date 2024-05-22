import 'package:challenges/UI/screens/auth/login.dart';
import 'package:challenges/UI/screens/auth/signup.dart';
import 'package:challenges/UI/screens/auth/verify_email_auth.dart';
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
          builder: (_) => const VerifyEmailAuth(),
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