import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/connectivity/internet_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter = AppRouter();
  final Connectivity connectivity = Connectivity();

  // https://pub.dev/packages/flutter_hooks

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetBloc>(
          create: (context) => InternetBloc(connectivity: connectivity),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<CollectionsBloc>(
          create: (context) => CollectionsBloc(),
        ),
        BlocProvider<FilterSettingsBloc>(
          create: (context) => FilterSettingsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Challenges',
        onGenerateRoute: (settings) => appRouter.onGenerateRoute(settings),
        home: MultiBlocListener(
          listeners: [
            BlocListener<InternetBloc, InternetState>(
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
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (kDebugMode) {
                  print('🚀 BlocListener AuthBloc state: $state');
                }

                if (state is AuthStateLoggedIn) {
                  if (state.user.emailVerified == true) {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  } else {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.verifyEmail);
                  }
                } else if (state is AuthStateLoggedOut) {
                  Navigator.of(context).pushReplacementNamed(Routes.auth);
                }

                if (state.authError != null) {
                  Modal.show(context, state.authError!.dialogTitle,
                      state.authError!.dialogText);
                }
              },
            ),
          ],
          child: const Auth(),
        ),
      ),
    );
  }
}
