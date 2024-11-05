import 'package:challenges/logic/bloc/auth/auth_error.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? username;
  final String? email;
  final AuthEvent? event;
  final String? success;
  final AuthError? error;

  const AuthState({
    required this.isLoading,
    this.username,
    this.email,
    this.event,
    this.success,
    this.error,
  });
}

@immutable
class AuthStateEmpty extends AuthState {
  const AuthStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 AuthStateEmpty';
}

@immutable
class AuthStateLoggedIn extends AuthState {
  final User? user;

  const AuthStateLoggedIn({
    bool? isLoading,
    String? username,
    String? email,
    String? success,
    AuthEvent? event,
    AuthError? error,
    this.user,
  }) : super(
          isLoading: isLoading ?? false,
          username: username,
          email: email,
          event: event,
          success: success,
          error: error,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;

    if (otherClass is AuthStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user?.uid == otherClass.user?.uid &&
          user?.emailVerified == otherClass.user?.emailVerified;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        user?.uid,
      );

  @override
  String toString() {
    return '🚀 AuthStateLoggedIn(user: $user, isLoading: $isLoading, event: $event, success: $success, error: $error, )';
  }
}

@immutable
class AuthStateGoogleLoggedIn extends AuthState {
  final User user;

  const AuthStateGoogleLoggedIn({
    required bool isLoading,
    required this.user,
  }) : super(
          isLoading: isLoading,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AuthStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user?.uid;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        user.uid,
      );

  @override
  String toString() {
    return '🚀 AuthStateGoogleLoggedIn(user: $user)';
  }
}

@immutable
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut({
    bool isLoading = false,
    AuthError? error,
  }) : super(
          isLoading: isLoading,
          error: error,
        );

  @override
  String toString() =>
      '🚀 AuthStateLoggedOut: (isLoading: $isLoading, error: $error)';
}

@immutable
class AuthStateNameSaved extends AuthState {
  const AuthStateNameSaved({
    required String username,
    required String email,
  }) : super(
          username: username,
          email: email,
          isLoading: false,
        );

  @override
  String toString() {
    return '🚀 AuthStateNameSaved(username: $username, email: $email)';
  }
}

extension GetUser on AuthState {
  User? get user {
    final cls = this;
    if (cls is AuthStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetUsername on AuthState {
  String? get username {
    final cls = this;
    if (cls is AuthStateNameSaved) {
      return cls.username;
    } else {
      return null;
    }
  }
}

extension GetEmail on AuthState {
  String? get email {
    final cls = this;
    if (cls is AuthStateNameSaved) {
      return cls.email;
    } else if (cls is AuthStateLoggedIn) {
      return cls.email;
    } else {
      return null;
    }
  }
}
