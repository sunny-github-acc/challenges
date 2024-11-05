import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/auth/auth.dart';
import 'package:challenges/UI/screens/home/home.dart';
import 'package:challenges/UI/screens/home/verify_email.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/collections/collections_state.dart';
import 'package:challenges/logic/bloc/connectivity/internet_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_events.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:challenges/logic/bloc/priorities/priorities_bloc.dart';
import 'package:challenges/logic/bloc/tribes/tribes_bloc.dart';
import 'package:challenges/logic/bloc/tribes/tribes_state.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_bloc.dart';
import 'package:challenges/utils/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        BlocProvider<TribesBloc>(
          create: (context) => TribesBloc(),
        ),
        BlocProvider<PrioritiesBloc>(
          create: (context) => PrioritiesBloc(),
        ),
        BlocProvider<UsersProfilesBloc>(
          create: (context) => UsersProfilesBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Challenges',
        onGenerateRoute: (settings) => appRouter.onGenerateRoute(settings),
        home: MultiBlocListener(
          listeners: [
            BlocListener<FilterSettingsBloc, FilterSettingsState>(
              listener: (context, state) {
                if (kDebugMode) {
                  print('🚀 BlocListener FilterSettingsBloc state: $state');
                }

                User? user = BlocProvider.of<AuthBloc>(context).state.user;
                FilterSettingsState filterSettingsState =
                    BlocProvider.of<FilterSettingsBloc>(context).state;
                CollectionsBloc collectionsBloc =
                    BlocProvider.of<CollectionsBloc>(context);
                CollectionsState collectionsState = collectionsBloc.state;

                if (user?.emailVerified == true &&
                    !filterSettingsState.isLoading &&
                    filterSettingsState.filterSettings.isNotEmpty) {
                  Map<String, dynamic> filterSettingsQuery =
                      filterSettingsState.filterSettings;

                  if (collectionsState is! CollectionsStateEmpty) {
                    collectionsBloc.add(
                      CollectionsEventGetCollection(
                        query: filterSettingsQuery,
                      ),
                    );
                  }

                  collectionsBloc.add(
                    CollectionsEventInitiateStream(
                      query: filterSettingsQuery,
                    ),
                  );
                }
              },
            ),
            BlocListener<TribesBloc, TribesState>(
              listener: (context, state) {
                if (kDebugMode) {
                  print('🚀 BlocListener TribesBloc state: $state');
                }

                if (state is TribesStateJoined) {
                  BlocProvider.of<FilterSettingsBloc>(context).add(
                    const FilterSettingsEventGetFilterSettings(),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<InternetBloc, InternetState>(
            builder: (context, state) {
              if (kDebugMode) {
                print('🚀 BlocBuilder InternetBloc state: $state');
              }

              if (state is! InternetConnected) {
                return const Scaffold(
                  body: Center(
                    child: CustomText(text: 'No internet connection 🙈'),
                  ),
                );
              }

              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (kDebugMode) {
                    print('🚀 AuthBloc state: $state');
                  }

                  if (state is AuthStateEmpty) {
                    BlocProvider.of<AuthBloc>(context).add(
                      const AuthEventInitialize(),
                    );

                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
                            content: CustomText(
                              text: state.success!,
                              color: colorMap['white'],
                            ),
                            duration: const Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state.user != null) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                    );

                    if (state.success != null) {
                      throwSuccess();
                    }

                    if (state.error != null) {
                      throwError();
                    }

                    BlocProvider.of<FilterSettingsBloc>(context).add(
                      const FilterSettingsEventGetFilterSettings(),
                    );

                    if (state.user?.emailVerified == true) {
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
              );
            },
          ),
        ),
      ),
    );
  }
}
