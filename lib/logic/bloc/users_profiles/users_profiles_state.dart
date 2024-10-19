import 'package:challenges/logic/bloc/users_profiles/users_profiles_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class UsersProfilesState {
  final bool isLoading;

  const UsersProfilesState({
    required this.isLoading,
  });
}

@immutable
class UsersProfilesStateEmpty extends UsersProfilesState {
  const UsersProfilesStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 UsersProfilesStateEmpty';
}

@immutable
class UsersProfilesStateError extends UsersProfilesState {
  final UsersProfilesError error;

  const UsersProfilesStateError({
    required this.error,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 UsersProfilesStateError: (error: $error)';
}

@immutable
class UsersProfilesStateGetting extends UsersProfilesState {
  const UsersProfilesStateGetting()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 UsersProfilesStateGetting';
}

@immutable
class UsersProfilesStateGot extends UsersProfilesState {
  final Map<String, dynamic> userProfile;

  const UsersProfilesStateGot({
    required this.userProfile,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 UsersProfilesStateGot: (userProfile: $userProfile)';
}

extension GetUsersProfiles on UsersProfilesState {
  Map<String, dynamic> get userProfile {
    if (this is UsersProfilesStateGot) {
      return (this as UsersProfilesStateGot).userProfile;
    }

    return {};
  }
}
