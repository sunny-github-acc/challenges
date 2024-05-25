import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

@immutable
class AuthEventDeleteAccount implements AuthEvent {
  const AuthEventDeleteAccount();
}

@immutable
class AuthEventLogOut implements AuthEvent {
  const AuthEventLogOut();
}

@immutable
class AuthEventInitialize implements AuthEvent {
  const AuthEventInitialize();
}

@immutable
class AuthEventLogIn implements AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AuthEventGoogleLogIn implements AuthEvent {
  const AuthEventGoogleLogIn();
}

@immutable
class AuthEventGoToRegistration implements AuthEvent {
  const AuthEventGoToRegistration();
}

@immutable
class AuthEventGoToLogin implements AuthEvent {
  const AuthEventGoToLogin();
}

@immutable
class AuthEventRegister implements AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister({
    required this.email,
    required this.password,
  });
}
