import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/home/dashboard.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventLogOut());
  }

  void _navigateToCreateChallengeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.createChallenge);
  }

  void _navigateToMenuScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.menu);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterSettingsBloc, FilterSettingsState>(
      builder: (context, state) {
        if (kDebugMode) {
          print('🚀 FilterSettingsBloc state: $state');
        }

        final isLoading = state is FilterSettingsStateEmpty ||
            state.isLoading ||
            state.filterSettings.isEmpty;
        final appBarTitle = isLoading
            ? 'Loading Settings'
            : state.filterSettings['isPrivate']
                ? 'My Challenges'
                : 'All Challenges';

        return Scaffold(
          appBar: CustomAppBar(
            title: appBarTitle,
            actions: [
              GestureDetector(
                onTap: () => _logout(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  width: 36,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final user = state.user;

                      return ClipOval(
                        child: user?.photoURL != null
                            ? Image.network(
                                user!.photoURL!,
                                width: 50,
                                height: 10,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/avatar.png',
                                width: 50,
                                height: 10,
                                fit: BoxFit.cover,
                                color: colorMap['white'],
                              ),
                      );
                    },
                  ),
                ),
              ),
            ],
            leftButton: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _navigateToMenuScreen(context),
            ),
          ),
          body: const CustomContainer(
            isSingleChildScrollView: false,
            padding: 0,
            child: Dashboard(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToCreateChallengeScreen(context),
            backgroundColor: colorMap['blue'],
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
