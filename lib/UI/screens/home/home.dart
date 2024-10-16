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
import 'package:challenges/logic/bloc/collections/collections_bloc.dart';
import 'package:challenges/logic/bloc/collections/collections_events.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_bloc.dart';
import 'package:challenges/logic/bloc/filterSettings/filter_settings_state.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void logout(BuildContext context) {
    context.read<CollectionsBloc>().add(const CollectionsEventCancelStream());
    context.read<AuthBloc>().add(const AuthEventLogOut());
  }

  void deleteAccount(BuildContext context) {
    showConfirmationDialog(context);
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            fontSize: FontSizeType.large,
            text: 'Confirm Action',
          ),
          content: const CustomText(
            text: 'Are you sure you want to delete your account?',
          ),
          actions: <Widget>[
            CustomButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              text: 'Confirm',
              type: ButtonType.danger,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                context.read<CollectionsBloc>().add(
                      const CollectionsEventCancelStream(),
                    );
                context.read<AuthBloc>().add(
                      const AuthEventDeleteAccount(),
                    );
              },
            ),
          ],
        );
      },
    );
  }

  void openMenuModal(BuildContext context) {
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: CustomColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomColumn(
                  spacing: SpacingType.medium,
                  children: [
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
                      text: 'Filter Settings',
                    ),
                  ],
                ),
                CustomColumn(
                  spacing: SpacingType.medium,
                  children: [
                    CustomButton(
                      text: 'Privacy Policy',
                      type: ButtonType.secondary,
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        navigateToPrivacyPolicy(context),
                      },
                    ),
                    CustomButton(
                      text: 'Terms of Use',
                      type: ButtonType.secondary,
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        navigateToTermsOfUse(context),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    customModal.show(context);
  }

  void openProfileModal(BuildContext context) {
    CustomModal customModal = CustomModal(
      child: CustomColumn(
        spacing: SpacingType.medium,
        children: [
          CustomRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomText(
                text: 'Profile',
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: CustomColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomColumn(
                  spacing: SpacingType.medium,
                  children: [
                    CustomButton(
                      text: 'Priorities',
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        navigateToPriorities(context),
                      },
                    ),
                  ],
                ),
                CustomColumn(
                  spacing: SpacingType.medium,
                  children: [
                    CustomButton(
                      text: 'Logout',
                      // type: ButtonType.danger,
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        logout(context),
                      },
                    ),
                    CustomButton(
                      text: 'Delete Account',
                      type: ButtonType.danger,
                      onPressed: () => {
                        deleteAccount(context),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    customModal.show(context);
  }

  void navigateToCreateChallengeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.createChallenge);
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

  void navigateToPriorities(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.priorities);
  }

  void navigateToTermsOfUse(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.termsOfUse);
  }

  void navigateToPrivacyPolicy(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.privacyPolicy);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterSettingsBloc, FilterSettingsState>(
      builder: (context, state) {
        final appBarTitle = state.isLoading ? 'Loading Settings' : 'Challenges';

        return Scaffold(
          appBar: CustomAppBar(
            title: appBarTitle,
            actions: [
              GestureDetector(
                onTap: () => openProfileModal(context),
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
              onPressed: () => openMenuModal(context),
            ),
          ),
          body: CustomContainer(
            isSingleChildScrollView: false,
            padding: 0,
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Dashboard(),
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
