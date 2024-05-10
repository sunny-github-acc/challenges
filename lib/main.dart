import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:challenges/UI/router/router.dart';
import 'package:challenges/logic/cubit/internet_cubit.dart';

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
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(connectivity: connectivity),
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
            );
          },
        ),
      ),
    );
  }
}
