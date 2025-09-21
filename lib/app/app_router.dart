import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/core/providers/app_settings_provider.dart';
import 'package:flutter_flight_booking/features/available_seats.dart/presentations/select_seats_screen.dart';
import 'package:flutter_flight_booking/features/categories/presentations/flight_categories_screen.dart';
import 'package:flutter_flight_booking/features/flight_details/presentations/flight_details_screen.dart';
import 'package:flutter_flight_booking/features/home/presentation/home_screen_tabs.dart';
import 'package:flutter_flight_booking/features/onboarding/presentations/onboarding_screen.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passengers_infos_data.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:flutter_flight_booking/features/tickets/presentations/ticket_screen.dart';
import 'package:flutter_flight_booking/features/search/presentations/flight_search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:flutter_flight_booking/features/auth/presentation/forgot_password.dart';
import 'package:flutter_flight_booking/features/auth/presentation/login_screen.dart';
import 'package:flutter_flight_booking/features/auth/presentation/signup_screen.dart';
import 'package:flutter_flight_booking/features/auth/presentation/verify_email_screen.dart';
import 'package:flutter_flight_booking/features/settings/settings_screen.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';
import 'package:flutter_flight_booking/features/passengers_infos/presentations/passengers_infos_screen.dart';
import 'package:flutter_flight_booking/features/tickets/presentations/ticket_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch the authentication state
  final authState = ref.watch(authStateChangesProvider);
  // Watch the isFirstLoad state
  final isFirstLoad = ref.watch(
    appSettingsProvider.select((s) => s.isFirstLoad),
  );

  return GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      // Use `when` to handle loading, error, and data states of the stream.
      return authState.when(
        data: (user) {
          final bool isLoggedIn = user != null;
          final authRoutes = [
            '/login',
            '/signup',
            '/forgot-password',
            '/verify-email',
          ];
          final bool isOnAuthRoute = authRoutes.contains(state.matchedLocation);

          if (!isLoggedIn) {
            if (isFirstLoad) {
              return '/onboarding';
            }
            // If not logged in, must be on an auth route.
            return isOnAuthRoute ? null : '/login';
          }
          // User is logged in.
          final isPasswordProvider = user.providerData.any(
            (p) => p.providerId == 'password',
          );
          final isVerified = !isPasswordProvider || user.emailVerified;
          if (!isVerified) {
            // If not verified, must be on the verify-email screen.
            return state.matchedLocation == '/verify-email'
                ? null
                : '/verify-email';
          }
          // User is logged in and verified.
          if (isOnAuthRoute) {
            return '/';
          }
          // No redirect needed.
          return null;
        },
        // While the auth state is loading, don't redirect.
        // This prevents a flicker from the login page to the home page on app start.
        loading: () => null,
        // If there's an error, we can show an error screen or stay on the current page.
        error: (_, __) => null,
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreenTabs()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/flights',
        builder: (context, state) {
          final category = state.extra as String?;
          return FlightCategoriesScreen(category: category);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final searchFilters = state.extra as SearchFiltersData;
          return FlightSearchScreen(searchFilters: searchFilters);
        },
      ),
      GoRoute(
        path: '/select-seats',
        builder: (context, state) {
          final flight = state.extra as Flight;

          return SelectSeatsScreen(flight: flight);
        },
      ),
      GoRoute(
        path: '/ticket',
        builder: (context, state) {
          final passengersInfosData = state.extra as PassengersInfosData;
          return TicketScreen(passengersInfosData: passengersInfosData);
        },
      ),
      GoRoute(
        path: '/passengers-infos',
        builder: (context, state) {
          final passengersInfosData = state.extra as PassengersInfosData;
          return PassengersInfosScreen(initialData: passengersInfosData);
        },
      ),
      GoRoute(
        path: '/flight-details',
        builder: (context, state) {
          final flight = state.extra as Flight;
          return FlightDetailsScreen(flight: flight);
        },
      ),
      GoRoute(
        path: '/ticket-details',
        builder: (context, state) {
          final ticket = state.extra as Ticket;
          return TicketDetailsScreen(ticket: ticket);
        },
      ),
    ],
  );
});
