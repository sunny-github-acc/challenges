import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_error.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          const AuthStateLoggedOut(),
        ) {
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          AuthStateLoading(event: event),
        );

        try {
          final email = event.email;
          final password = event.password;
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user!;

          emit(
            AuthStateLoggedIn(
              isLoading: false,
              user: user,
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventLogIn error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventVerifyEmail>(
      (event, emit) async {
        emit(
          AuthStateLoading(event: event),
        );

        try {
          AuthService authService = AuthService();
          User? user = await authService.getReloadedUser();

          if (user != null) {
            emit(
              AuthStateLoggedIn(
                isLoading: false,
                user: user,
              ),
            );
          } else {
            emit(
              const AuthStateLoggedOut(),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventVerifyEmail error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventRememberPassword>(
      (event, emit) async {
        emit(
          AuthStateLoading(event: event),
        );

        try {
          final email = event.email;
          await AuthService().rememberPassword(email);

          emit(
            AuthStateLoading(
              event: event,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventRememberPassword error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventResendVerificationEmail>(
      (event, emit) async {
        emit(
          AuthStateLoading(event: event),
        );

        try {
          await AuthService().resendVerificationEmail();

          emit(
            AuthStateLoading(
              event: event,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventResendVerificationEmail error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventGoogleLogIn>(
      (event, emit) async {
        emit(
          AuthStateLoading(event: event),
        );

        try {
          AuthService authService = AuthService();

          final user = await authService.loginGoogle();

          if (user != null) {
            emit(
              AuthStateLoggedIn(
                isLoading: false,
                user: user,
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventGoogleLogIn error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventSaveName>(
      (event, emit) async {
        final username = event.username;
        final email = event.email;

        emit(AuthStateNameSaved(
          username: username,
          email: email,
          isLoading: false,
        ));
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        final currentState = state;
        final username = currentState.username;
        final email = currentState.email;
        final password = event.password;

        emit(
          AuthStateLoading(event: event),
        );

        try {
          AuthService authService = AuthService();
          User? user = await authService.signupEmail(username, email, password);

          emit(
            AuthStateLoggedIn(
              isLoading: false,
              user: user!,
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print('AuthEventRegister error 🚀');
            print(e);
          }

          emit(
            AuthStateError(
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    // on<AuthEventInitialize>(
    //   (event, emit) async {
    //     final user = FirebaseAuth.instance.currentUser;
    //     if (user == null) {
    //       emit(
    //         const AuthStateLoggedOut(),
    //       );
    //     } else {
    //       emit(
    //         AuthStateLoggedIn(
    //           isLoading: false,
    //           user: user,
    //         ),
    //       );
    //     }
    //   },
    // );

    on<AuthEventLogOut>(
      (event, emit) async {
        emit(AuthStateLoading(event: event));

        try {
          await FirebaseAuth.instance.signOut();

          emit(const AuthStateLoggedOut());
        } catch (e) {
          if (kDebugMode) {
            print('AuthEventLogOut error 🚀');
            print(e);
          }

          emit(AuthStateError(
            authError: AuthError.from(
              FirebaseAuthException(
                code: 'unknown',
                message: 'Unknown error',
              ),
            ),
          ));
        }
      },
    );

    // on<AuthEventDeleteAccount>(
    //   (event, emit) async {
    //     final user = FirebaseAuth.instance.currentUser;
    //     if (user == null) {
    //       return emit(
    //         const AuthStateLoggedOut(),
    //       );
    //     }

    //     emit(
    //       AuthStateLoggedIn(
    //         isLoading: true,
    //         user: user,
    //       ),
    //     );

    //     try {
    //       await user.delete();
    //       await FirebaseAuth.instance.signOut();
    //       emit(
    //         const AuthStateLoggedOut(),
    //       );
    //     } on FirebaseAuthException catch (e) {
    //       if (kDebugMode) {
    //         print('AuthEventDeleteAccount error 🚀');
    //         print(e);
    //       }

    //       emit(
    //         AuthStateError(
    //           authError: AuthError.from(e),
    //         ),
    //       );
    //     } on FirebaseException {
    //       emit(
    //         AuthStateError(
    //           authError: AuthError.from(
    //             FirebaseAuthException(
    //               code: 'unknown',
    //               message: 'Unknown error',
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
