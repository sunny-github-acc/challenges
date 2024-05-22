import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:challenges/UI/router/router.dart';
import 'package:challenges/logic/bloc/connectivity/internet_bloc.dart';

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

  // https://pub.dev/packages/hydrated_bloc

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter = AppRouter();
  final Connectivity connectivity = Connectivity();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetBloc>(
          create: (context) => InternetBloc(connectivity: connectivity),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => AuthNotifier(),
        child: Consumer<AuthNotifier>(
          builder: (context, authNotifier, child) {
            return MaterialApp(
              title: 'Leap',
              onGenerateRoute: (settings) =>
                  appRouter.onGenerateRoute(settings, authNotifier),
              builder: (context, child) {
                return BlocListener<InternetBloc, InternetState>(
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (state is InternetConnected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Connected'),
                            duration: Duration(seconds: 1)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No internet connection'),
                            duration: Duration(days: 999)),
                      );
                    }
                  },
                  child: child,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
