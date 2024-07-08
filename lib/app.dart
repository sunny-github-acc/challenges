import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/verify_email.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/connectivity/internet_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        BlocProvider<CollectionBloc>(
          create: (context) => CollectionBloc(),
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
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Connected emoji ✨'),
                        duration: Duration(seconds: 1)),
                  );
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No internet connection 🙈'),
                        duration: Duration(days: 999)),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (kDebugMode) {
                print('🚀 AuthBloc state: $state');
              }

              throwError() {
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    Modal.show(
                      context,
                      state.error!.dialogTitle,
                      state.error!.dialogText,
                    );
                  },
                );
              }

              throwSuccess() {
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.success!),
                          duration: const Duration(seconds: 2)),
                    );
                  },
                );
              }

              if (state is AuthStateEmpty) {
                BlocProvider.of<AuthBloc>(context)
                    .add(const AuthEventInitialize());

                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.user != null) {
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                );

                if (state.success != null) {
                  throwSuccess();
                }

                if (state.error != null) {
                  throwError();
                }

                if (state.user?.emailVerified == true) {
                  BlocProvider.of<CollectionsBloc>(context).add(
                    const CollectionsEventInitiateStream(),
                  );

                  return const Home();
                }

                return const VerifyEmail();
              }

              if (state.success != null) {
                throwSuccess();
              }

              if (state.error != null) {
                throwError();
              }

              return const Auth();
            },
          ),
        ),
      ),
    );
  }
}
