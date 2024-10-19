import 'package:flutter/foundation.dart';

const Map<String, UsersProfilesError> usersProfilesErrorMapping = {
  'no-data-found': UsersProfilesErrorNoDataFound(),
};

@immutable
abstract class UsersProfilesError {
  final String dialogTitle;
  final String dialogText;

  const UsersProfilesError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory UsersProfilesError.from(exception) {
    return usersProfilesErrorMapping[exception] ??
        const UsersProfilesErrorUnknown();
  }
}

@immutable
class UsersProfilesErrorUnknown extends UsersProfilesError {
  const UsersProfilesErrorUnknown()
      : super(
          dialogTitle: 'Unknown Error',
          dialogText: 'Unknown Users Profiles Error',
        );
}

@immutable
class UsersProfilesErrorNoDataFound extends UsersProfilesError {
  const UsersProfilesErrorNoDataFound()
      : super(
          dialogTitle: 'Users Profiles Not Found',
          dialogText: 'The users profiles you are looking for does not exist',
        );
}
