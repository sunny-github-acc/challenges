import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/home/dashboard.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button_floating.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/logic/bloc/auth/auth_bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          GestureDetector(
            onTap: () => _logout(context),
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              width: 50,
              height: 10,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state.user;

                  return user?.photoURL == 'null' || user?.photoURL == null
                      ? Image.asset(
                          'assets/grow.png',
                          width: 50,
                          height: 10,
                        )
                      : ClipOval(
                          child: Image.network(
                            user!.photoURL!,
                            width: 50,
                            height: 10,
                            fit: BoxFit.cover,
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
      body: ContainerGradient(
        child: Column(
          children: [
            const Expanded(
              child: Dashboard(),
            ),
            FloatingButton(
              onPressed: () => _navigateToCreateChallengeScreen(context),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
