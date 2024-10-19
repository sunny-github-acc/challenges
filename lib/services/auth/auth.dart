import 'package:challenges/services/cloud/cloud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> resendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    } catch (error) {
      if (kDebugMode) {
        print('resendVerificationEmail error 🚀: $error');
      }

      rethrow;
    }
  }

  Future<User?> signupEmail(username, email, password) async {
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      await userCredential.user?.updateDisplayName(username);

      if (user != null) {
        setUser(userCredential.user!.uid);

        await user.sendEmailVerification();

        return user;
      }

      return null;
    } catch (error) {
      if (kDebugMode) {
        print('signupEmail error 🚀: $error');
      }

      rethrow;
    }
  }

  Future<void> rememberPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      if (kDebugMode) {
        print('rememberPassword error 🚀: $error');
      }

      rethrow;
    }
  }

  Future<User?> loginGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    User? user;

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      setUser(userCredential.user!.uid);

      user = userCredential.user;

      return user;
    } catch (error) {
      if (kDebugMode) {
        print('loginGoogle error 🚀: $error');
      }

      rethrow;
    }
  }

  Future<void> setUser(id) async {
    try {
      CloudService cloudService = CloudService();

      Map<String, dynamic> document = {
        'uid': id,
        'visibility': {
          'public': true,
          id: true,
        },
        'isIncludeFinished': true,
        'isFinished': false,
        'duration': 'All',
      };

      await cloudService.setCollection(
        'users',
        document,
        customDocumentId: id,
      );
    } catch (error) {
      if (kDebugMode) {
        print('setUser error 🚀: $error');
      }

      rethrow;
    }
  }

  Future<User?> getReloadedUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }
      return user;
    } catch (error) {
      if (kDebugMode) {
        print('getReloadedUser error 🚀: $error');
      }

      rethrow;
    }
  }

  Map<String, dynamic> getUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {};
    }

    return {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    };
  }

  // Not implemented
  updateUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Map<String, dynamic> userMap = {
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
      };

      return userMap;
    } else {
      return null;
    }
  }
}
