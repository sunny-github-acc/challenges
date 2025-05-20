import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_bloc.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_events.dart';
import 'package:challenges/logic/bloc/users_profiles/users_profiles_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile extends StatefulWidget {
  final Map<String, dynamic> collection;

  const UserProfile({
    required this.collection,
    super.key,
  });

  @override
  UserProfileStateClass createState() => UserProfileStateClass();
}

class UserProfileStateClass extends State<UserProfile> {
  @override
  void initState() {
    super.initState();

    if (widget.collection['uid'] != null) {
      BlocProvider.of<UsersProfilesBloc>(context).add(
        UsersProfilesEventGetUserProfile(
          user: widget.collection['uid'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.collection['displayName'] ?? 'User Profile',
      ),
      body: CustomContainer(
        isFullWidth: true,
        child: CustomColumn(
          children: [
            CustomColumn(
              spacing: SpacingType.medium,
              children: [
                CustomRow(
                  spacing: SpacingType.small,
                  flex: const [0, 1],
                  children: [
                    ClipOval(
                      child: widget.collection['photoURL'] != null
                          ? Image.network(
                              widget.collection['photoURL'],
                              height: 34,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/avatar.png',
                              height: 34,
                              fit: BoxFit.cover,
                              color: colorMap['black'],
                            ),
                    ),
                    CustomText(
                      text: widget.collection['displayName'],
                      // fontWeight: FontWeight.bold,
                      fontSize: FontSizeType.xlarge,
                    ),
                  ],
                ),
                BlocBuilder<UsersProfilesBloc, UsersProfilesState>(
                  builder: (context, state) {
                    if (state is UsersProfilesStateEmpty) {
                      return const CustomText(text: 'No priorities');
                    }

                    if (state is UsersProfilesStateGetting) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    }

                    dynamic userProfilePriorities =
                        state.userProfile['priorities'];
                    String priorities = userProfilePriorities ?? '';
                    Map<String, dynamic> user = AuthService().getUser();

                    return CustomRow(
                      spacing: SpacingType.small,
                      flex: const [0, 1],
                      children: [
                        Image.asset(
                          'assets/heart.png',
                          width: 24,
                          height: 24,
                        ),
                        CustomText(
                          text: priorities.isNotEmpty
                              ? priorities
                              : widget.collection['uid'] == user['uid']
                                  ? "You haven't set any priorities yet! Explore the user profile section to create your priorities."
                                  : "It looks like ${widget.collection['displayName']} hasn't set any priorities yet.",
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
