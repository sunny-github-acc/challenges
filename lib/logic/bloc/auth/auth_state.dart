import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  // final AuthError? authError;

  const AuthState({
    required this.isLoading,
    // this.authError,
  });
}

@immutable
class AuthStateLoggedIn extends AuthState {
  final User user;

  const AuthStateLoggedIn({
    required bool isLoading,
    required this.user,
    // AuthError? authError,
  }) : super(
          isLoading: isLoading,
          // authError: authError,
        );

  // @override
  // bool operator ==(other) {
  //   final otherClass = other;

  //   if (otherClass is AuthStateLoggedIn) {
  //     return isLoading == otherClass.isLoading &&
  //         user.uid == otherClass.user.uid;
  //   } else {
  //     return false;
  //   }
  // }

  // @override
  // int get hashCode => Object.hash(
  //       isLoading,
  //       user.uid,
  //     );

  @override
  String toString() => 'AuthStateLoggedIn';
}

@immutable
class AuthStateGoogleLoggedIn extends AuthState {
  final User user;

  const AuthStateGoogleLoggedIn({
    required bool isLoading,
    required this.user,
    // AuthError? authError,
  }) : super(
          isLoading: isLoading,
          // authError: authError,
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
  String toString() => 'AuthStateLoggedIn';
}

@immutable
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut({
    required bool isLoading,
    // AuthError? authError,
  }) : super(
          isLoading: isLoading,
          // authError: authError,
        );

  @override
  String toString() =>
      'AuthStateLoggedOut, isLoading = $isLoading'; // , authError = $authError';
}

@immutable
class AuthStateIsInRegistrationView extends AuthState {
  const AuthStateIsInRegistrationView({
    required bool isLoading,
    // AuthError? authError,
  }) : super(
          isLoading: isLoading,
          // authError: authError,
        );
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
