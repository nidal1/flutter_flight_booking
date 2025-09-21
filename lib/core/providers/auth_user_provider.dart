import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/core/constants/app_constants.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:flutter_flight_booking/features/auth/data/app_user.dart';

class AuthUser {
  final User? user;
  final String? token;

  AuthUser({this.user, this.token});

  AuthUser copyWith({User? user, bool? isLoading, String? token}) {
    return AuthUser(user: user ?? this.user, token: token ?? this.token);
  }
}

class AuthUserNotifier extends StateNotifier<AuthUser> {
  AuthUserNotifier() : super(AuthUser());

  Future<void> setUser(User? user) async {
    if (user == null) {
      // If user is null, it means logout, so we reset.
      await reset();
      return;
    }

    state = state.copyWith(user: user);
    final appUser = AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.emailVerified,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      LocalStorageKeys.authUser,
      jsonEncode(appUser.toJson()),
    );

    // Also fetch and set the token when the user is set
    final token = await user.getIdToken();
    await setToken(token);
  }

  Future<void> setToken(String? token) async {
    state = state.copyWith(token: token);
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(LocalStorageKeys.authToken, token);
    } else {
      await prefs.remove(LocalStorageKeys.authToken);
    }
  }

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final str = await prefs.getString(LocalStorageKeys.authUser);
    if (str != null) {
      return AppUser.fromJson(json.decode(str));
    }
    return null;
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LocalStorageKeys.authToken);
  }

  Future<void> reset() async {
    state = AuthUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LocalStorageKeys.authToken);
    await prefs.remove(LocalStorageKeys.authUser);
  }
}

final authUserProvider = StateNotifierProvider<AuthUserNotifier, AuthUser>((
  ref,
) {
  final notifier = AuthUserNotifier();

  // Listen to Firebase auth state changes and update our notifier automatically.
  // This is the single source of truth.
  ref.listen(authStateChangesProvider, (_, next) {
    next.whenData((user) {
      // This will be called on login, logout, and app startup
      // after Firebase has initialized.
      notifier.setUser(user);
    });
  }, fireImmediately: true);

  return notifier;
});
