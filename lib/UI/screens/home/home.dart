import 'package:challenges/UI/router/router.dart';
import 'package:challenges/UI/screens/home/dashboard.dart';
import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/divider.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/side_modal.dart';
import 'package:challenges/components/text.dart';
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

  void logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventLogOut());
  }

  void navigateToCreateChallengeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.createChallenge);
  }

  void openModal(BuildContext context) {
    CustomModal customModal = CustomModal(
      child: CustomColumn(
        spacing: SpacingType.medium,
        children: [
          CustomRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomText(
                text: 'Menu',
                fontSize: FontSizeType.xxlarge,
              ),
              CustomButton(
                text: '',
                type: ButtonType.secondary,
                icon: IconType.close,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const CustomDivider(),
          CustomButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              navigateToAddTribes(context),
            },
            text: 'Create Tribe',
          ),
          CustomButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              navigateToJoinTribes(context),
            },
            text: 'Join Tribe',
          ),
          CustomButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              navigateToMenuScreen(context),
            },
            text: 'Settings',
          ),
        ],
      ),
    );
    customModal.show(context);
  }

  void navigateToMenuScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.menu);
  }

  void navigateToAddTribes(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.addTribe);
  }

  void navigateToJoinTribes(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.joinTribe);
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
        final appBarTitle = isLoading ? 'Loading Settings' : 'Challenges';

        return Scaffold(
          appBar: CustomAppBar(
            title: appBarTitle,
            actions: [
              GestureDetector(
                onTap: () => logout(context),
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
              onPressed: () => openModal(context),
            ),
          ),
          body: const CustomContainer(
            isSingleChildScrollView: false,
            padding: 0,
            child: Dashboard(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => navigateToCreateChallengeScreen(context),
            backgroundColor: colorMap['blue'],
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
