import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:challenges/components/modal.dart';

class AuthService {
  Future<void> loginEmail(context, email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pop(context);
    } catch (error) {
      List<String> parts = error.toString().split(']');
      if (error is FirebaseAuthException && parts.length > 1) {
        Modal.show(context, 'Oops', parts[1].trim());
      } else {
        Modal.show(context, 'Oops', 'Something unexpected happened');
      }
    }
  }

  Future<void> signupEmail(context, username, email, password) async {
    try {
      UserCredential?  userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      await userCredential.user?.updateDisplayName(username);

      if (user != null) {
        await user.sendEmailVerification();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      List<String> parts = error.toString().split(']');
      if (error is FirebaseAuthException && parts.length > 1) {
        Modal.show(context, 'Oops', parts[1].trim());
      } else {
        Modal.show(context, 'Oops', 'Something unexpected happened');
      }
    }
  }

  Future<bool?> rememberPassword(context, email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Modal.show(context, 'Success', 'Reset email has been sent to: $email');
      return null; // Return null after showing the message
    } catch (error) {
      List<String> parts = error.toString().split(']');
      if (error is FirebaseAuthException && parts.length > 1) {
        Modal.show(context, 'Oops', parts[1].trim());
      } else {
        Modal.show(context, 'Oops', 'Something unexpected happened');
      }
      return null; // Return null in case of an error as well
    }
  }

  Future<void> loginGoogle(context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      Modal.show(context, 'Oops', 'Google login has failed');
    }
  }

  getUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Map<String, dynamic> userMap = {
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL ?? 'https://lh3.googleusercontent.com/a/ACg8ocJgxc8UpaHn-osIcV-y9hVuE4UkHi0l7SjKOZ4q6_A6Ng=s96-c',
      };

      return userMap;
    } else {
      return null;
    }
  }
}

