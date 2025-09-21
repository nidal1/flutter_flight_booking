import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

const GOOGLE_AUTH_FAILED = 'auth/google-auth-failed';
const MISSING_GOOGLE_AUTH_TOKEN = 'auth/missing-google-auth-token';
const FACEBOOK_LOGIN_CANCELLED = 'auth/facebook-login-cancelled';
const FACEBOOK_LOGIN_FAILED = 'auth/facebook-login-failed';
const FACEBOOK_UNKNOWN_STATUS = 'auth/facebook-unknown-status';
const FACEBOOK_UNEXPECTED_ERROR = 'auth/facebook-unexpected-error';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<UserCredential> registerWithEmail(String email, String password) {
  return firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<UserCredential> loginWithEmail(String email, String password) {
  return firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> signOut() async {
  // Also sign out from social providers to allow account switching.
  await GoogleSignIn().signOut();
  // await FacebookAuth.instance.logOut();
  await firebaseAuth.signOut();
}

Future<void> sendEmailVerification(User user) async {
  return user.sendEmailVerification();
}

Future<void> sendPasswordReset(String email) {
  return firebaseAuth.sendPasswordResetEmail(email: email);
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  if (googleAuth == null) {
    throw FirebaseAuthException(
      code: GOOGLE_AUTH_FAILED,
      message: 'Google Auth Failed',
    );
  }

  if (googleAuth.accessToken == null || googleAuth.idToken == null) {
    throw FirebaseAuthException(
      code: MISSING_GOOGLE_AUTH_TOKEN,
      message: 'Missing Google Auth Token',
    );
  }

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return firebaseAuth.signInWithCredential(credential);
}

Future<UserCredential> signInWithFacebook() async {
  try {
    // Trigger the Facebook login flow
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // Get the access token from the result
      final AccessToken accessToken = result.accessToken!;

      // Create a Firebase credential from the Facebook access token
      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      // Sign in to Firebase with the credential
      return await firebaseAuth.signInWithCredential(credential);
    } else if (result.status == LoginStatus.cancelled) {
      throw FirebaseAuthException(
        code: FACEBOOK_LOGIN_CANCELLED,
        message: 'Facebook login was cancelled by the user.',
      );
    } else if (result.status == LoginStatus.failed) {
      throw FirebaseAuthException(
        code: FACEBOOK_LOGIN_FAILED,
        message: result.message ?? 'Facebook login failed with unknown error.',
      );
    } else {
      throw FirebaseAuthException(
        code: FACEBOOK_UNKNOWN_STATUS,
        message: 'Facebook login returned an unknown status: ${result.status}',
      );
    }
  } on FirebaseAuthException {
    rethrow; // Re-throw Firebase Auth exceptions (e.g., if signInWithCredential fails)
  } catch (e) {
    throw FirebaseAuthException(
      code: FACEBOOK_UNEXPECTED_ERROR,
      message:
          'An unexpected error occurred during Facebook authentication: ${e.toString()}',
    );
  }
}
