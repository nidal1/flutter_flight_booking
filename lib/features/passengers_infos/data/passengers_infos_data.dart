import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passenger_info.dart';

class PassengersInfosData {
  final Flight? flight;
  final List<String> seats;
  final List<PassengerInfo> passengers;

  PassengersInfosData({
    this.flight,
    this.seats = const [],
    this.passengers = const [],
  });
}
