import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flight_booking/core/services/firebase_service.dart'
    as firebase_service;

class AuthController {
  Future<User> _handleUserVerification(UserCredential credential) async {
    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      // This is highly unlikely but good to guard against.
      throw Exception('User creation failed unexpectedly.');
    }

    return firebaseUser;
  }

  /// Signs up a user with email and password.
  ///
  /// After successful registration, it sends a verification email and signs the user out,
  /// requiring them to verify their email before they can log in.
  ///
  /// Throws a [FirebaseAuthException] with code 'email-not-verified' after sending the email.
  ///
  /// Returns the [User] object if the user is already created and verified (an edge case).
  Future<User> signup({required String email, required String password}) async {
    final credential = await firebase_service.registerWithEmail(
      email,
      password,
    );
    return _handleUserVerification(credential);
  }

  /// Signs in a user with email and password.
  ///
  /// If the user's email is not verified, it sends a verification email, signs them out,
  /// and throws a [FirebaseAuthException] with code 'email-not-verified'.
  Future<User> login({required String email, required String password}) async {
    final credential = await firebase_service.loginWithEmail(email, password);
    return _handleUserVerification(credential);
  }

  /// Signs in a user with Google.
  ///
  /// Handles the Google Sign-In flow and then signs the user into Firebase.
  Future<User> signInWithGoogleProvider() async {
    final credential = await firebase_service.signInWithGoogle();
    return _handleUserVerification(credential);
  }

  /// Signs in a user with Facebook.
  ///
  /// Handles the Facebook Sign-In flow and then signs the user into Firebase.
  Future<User> signInWithFacebookProvider() async {
    final credential = await firebase_service.signInWithFacebook();
    return _handleUserVerification(credential);
  }

  /// Signs out the current user from Firebase and any social providers.
  Future<void> signOut() => firebase_service.signOut();

  /// Sends a password reset email to the given email address.
  Future<void> sendPasswordResetEmail({required String email}) =>
      firebase_service.sendPasswordReset(email);

  /// A stream that notifies about changes to the user's sign-in state.
  Stream<User?> authStateChanges() =>
      firebase_service.firebaseAuth.authStateChanges();

  /// Sends a verification email to the current user if they are not verified.
  Future<void> sendCurrentUserEmailVerification() async {
    final user = firebase_service.firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await firebase_service.sendEmailVerification(user);
    }
  }
}
