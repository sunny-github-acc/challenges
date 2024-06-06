import 'package:bloc/bloc.dart';
import 'package:challenges/logic/bloc/auth/auth_events.dart';
import 'package:challenges/logic/bloc/auth/auth_state.dart';
import 'package:challenges/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          const AuthStateLoggedOut(isLoading: false),
        ) {
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoading(),
        );

        // log the user in
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
            print(e);
          }

          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AuthEventVerifyEmail>(
      (event, emit) async {
        emit(
          const AuthStateLoading(),
        );

        // log the user in
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
              const AuthStateLoggedOut(
                isLoading: false,
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print(e);
          }

          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AuthEventGoogleLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoading(),
        );

        // log the user in
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
            print(e);
          }

          emit(
            const AuthStateLoggedOut(
              isLoading: false,
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
          const AuthStateLoading(),
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
            print(e);
          }

          emit(
            const AuthStateLoggedOut(
              isLoading: false,
              // authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AuthEventInitialize>(
      (event, emit) async {
        // get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
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
        emit(const AuthStateLoggedOut(isLoading: true));

        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          if (kDebugMode) {
            print('error 🚀');
            print(e);
          }
        }

        emit(const AuthStateLoggedOut(isLoading: false));
      },
    );

    on<AuthEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // log the user out if we don't have a current user
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // start loading
        emit(
          AuthStateLoggedIn(
            isLoading: true,
            user: user,
          ),
        );
        // delete the user folder
        try {
          // delete user folder
          // final folderContents =
          //     await FirebaseStorage.instance.ref(user.uid).listAll();
          // for (final item in folderContents.items) {
          //   await item.delete().catchError((_) {}); // maybe handle the error?
          // }
          // delete the folder itself
          // await FirebaseStorage.instance
          //     .ref(user.uid)
          //     .delete()
          //     .catchError((_) {});

          // delete the user
          await user.delete();
          // log the user out
          await FirebaseAuth.instance.signOut();
          // log the user out in the UI as well
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print(e);
          }

          emit(
            AuthStateLoggedIn(
              isLoading: false,
              user: user,
            ),
          );
        } on FirebaseException {
          // we might not be able to delete the folder
          // log the user out
          emit(
            const AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
