import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class UsersProfilesEvent {
  const UsersProfilesEvent();
}

@immutable
class UsersProfilesEventGetUserProfile implements UsersProfilesEvent {
  final String user;

  const UsersProfilesEventGetUserProfile({
    required this.user,
  });
}
