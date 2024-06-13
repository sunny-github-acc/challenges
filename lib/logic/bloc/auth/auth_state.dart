import 'package:challenges/logic/bloc/auth/auth_error.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  final AuthError? authError;

  const AuthState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AuthStateLoading extends AuthState {
  final AuthEvent event;

  const AuthStateLoading({
    required this.event,
    bool? isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading ?? true,
          authError: authError,
        );

  @override
  String toString() {
    return '🚀 AuthStateLoading(event: $event, authError: $authError)';
  }
}

@immutable
class AuthStateLoggedIn extends AuthState {
  final User user;

  const AuthStateLoggedIn({
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
          user.uid == otherClass.user.uid &&
          user.emailVerified == otherClass.user.emailVerified;
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
    return '🚀 AuthStateLoggedIn(user: $user)';
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
          user.uid == otherClass.user.uid;
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
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      '🚀 AuthStateLoggedOut, (isLoading = $isLoading, authError: $authError)'; // , authError = $authError';
}

@immutable
class AuthStateNameSaved extends AuthState {
  final String username;
  final String email;

  const AuthStateNameSaved({
    required this.username,
    required this.email,
    required bool isLoading,
  }) : super(
          isLoading: isLoading,
        );

  @override
  String toString() {
    return '🚀 AuthStateNameSaved(username: $username, email: $email, isLoading: $isLoading)';
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
    } else {
      return null;
    }
  }
}

extension GetEvent on AuthState {
  AuthEvent? get event {
    final cls = this;
    if (cls is AuthStateLoading) {
      return cls.event;
    } else {
      return null;
    }
  }
}
