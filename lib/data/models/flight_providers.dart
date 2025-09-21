import 'package:flutter_flight_booking/core/services/amadeus_service.dart';
import 'package:flutter_flight_booking/data/repositories/flight_repository.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';

final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  return FirestoreFlightRepository();
});

final flightsStreamProvider = StreamProvider.autoDispose<List<Flight>>((ref) {
  final flightRepository = ref.watch(flightRepositoryProvider);
  return flightRepository.flightsStream();
});

final amadeusServiceProvider = Provider((ref) => AmadeusService());

/// Provider for the home screen feed, fetching flights from multiple predefined routes.
final homeScreenFlightsProvider = FutureProvider<List<Flight>>((ref) {
  final amadeusService = ref.watch(amadeusServiceProvider);
  return amadeusService.fetchMultipleFlightOffers();
});

final flightsProvider = FutureProvider.family<List<Flight>, SearchFiltersData?>(
  (ref, filters) {
    final amadeusService = ref.watch(amadeusServiceProvider);
    return amadeusService.fetchFlights(filters);
  },
);
