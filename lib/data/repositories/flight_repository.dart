import 'package:flutter_flight_booking/core/api_path.dart';
import 'package:flutter_flight_booking/core/services/firebase_firestore_service.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';

abstract class FlightRepository {
  Future<void> addFlight(Flight flight);
  Future<void> updateFlight(Flight flight);
  Future<void> deleteFlight(String flightId);
  Stream<List<Flight>> flightsStream();
}

class FirestoreFlightRepository implements FlightRepository {
  final _service = FirebaseFirestoreService.instance;

  @override
  Future<void> addFlight(Flight flight) =>
      _service.addData(collectionPath: APIPath.flights(), data: flight.toMap());

  @override
  Future<void> updateFlight(Flight flight) => _service.setData(
    path: APIPath.flight(flight.id!),
    data: flight.toMap(),
    merge: true,
  );

  @override
  Future<void> deleteFlight(String flightId) =>
      _service.deleteData(path: APIPath.flight(flightId));

  @override
  Stream<List<Flight>> flightsStream() => _service.collectionStream(
    path: APIPath.flights(),
    builder: (data, documentId) => Flight.fromMap(data, documentId),
  );
}
