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
          const AuthStateEmpty(),
        ) {
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
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
              user: user,
            ),
          );
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print('AuthEventLogIn FirebaseAuthException error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventLogIn error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                ),
              ),
            ),
          );
        }
      },
    );

    on<AuthEventVerifyEmail>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
        );

        try {
          AuthService authService = AuthService();
          User? user = await authService.getReloadedUser();

          if (user != null) {
            if (user.emailVerified) {
              emit(
                AuthStateLoggedIn(
                  user: user,
                ),
              );
            } else {
              throw FirebaseAuthException(code: 'email-not-verified');
            }
          } else {
            emit(
              const AuthStateLoggedOut(),
            );
          }
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print(
                'AuthEventVerifyEmail FirebaseAuthException error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventVerifyEmail error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                ),
              ),
            ),
          );
        }
      },
    );

    on<AuthEventRememberPassword>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
        );

        try {
          final email = event.email;
          await AuthService().rememberPassword(email);
          User? user = await AuthService().getReloadedUser();

          emit(
            AuthStateLoggedIn(
              user: user,
              event: event,
            ),
          );
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print(
                'AuthEventRememberPassword FirebaseAuthException error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventRememberPassword error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                ),
              ),
            ),
          );
        }
      },
    );

    on<AuthEventResendVerificationEmail>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
        );

        try {
          await AuthService().resendVerificationEmail();
          User? user = await AuthService().getReloadedUser();

          emit(
            AuthStateLoggedIn(
              user: user,
            ),
          );
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print(
                'AuthEventResendVerificationEmail FirebaseAuthException error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventResendVerificationEmail error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                ),
              ),
            ),
          );
        }
      },
    );

    on<AuthEventGoogleLogIn>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
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
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print(
                'FirebaseAuthException AuthEventGoogleLogIn error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventGoogleLogIn error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'google',
                ),
              ),
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
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
            username: username,
            email: email,
          ),
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
        } on FirebaseAuthException catch (error) {
          if (kDebugMode) {
            print('AuthEventRegister FirebaseAuthException error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(error),
              username: username,
              email: email,
            ),
          );
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventRegister error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                ),
              ),
              username: username,
              email: email,
            ),
          );
        }
      },
    );

    on<AuthEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const AuthStateLoggedOut(),
          );
        } else {
          emit(
            AuthStateLoggedIn(
              isLoading: false,
              user: user,
            ),
          );
        }
      },
    );

    on<AuthEventLogOut>(
      (event, emit) async {
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            event: event,
          ),
        );

        try {
          await FirebaseAuth.instance.signOut();

          emit(const AuthStateLoggedOut());
        } catch (error) {
          if (kDebugMode) {
            print('AuthEventLogOut error 🚀: $error');
          }

          emit(
            AuthStateLoggedIn(
              error: AuthError.from(
                FirebaseAuthException(
                  code: 'unknown',
                  message: 'Unknown error',
                ),
              ),
            ),
          );
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
    //     } on FirebaseAuthException catch (error) {
    //       if (kDebugMode) {
    //         print('AuthEventDeleteAccount error 🚀: error');
    //       }

    //       emit(
    //         AuthStateError(
    //           authError: AuthError.from(error),
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
