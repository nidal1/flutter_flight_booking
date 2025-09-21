import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_controller.dart';

/// Provides an instance of [AuthController] to the app.
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});

/// A stream provider that exposes the current Firebase [User] object.
///
/// It automatically notifies listeners when the user signs in or out,
/// and it will contain the user object on app startup if a session was persisted.
/// This should be the single source of truth for authentication state in the app.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // By watching the authControllerProvider, we ensure that the stream is provided correctly.
  return ref.watch(authControllerProvider).authStateChanges();
});
