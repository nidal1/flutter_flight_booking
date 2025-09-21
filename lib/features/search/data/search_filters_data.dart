import 'package:flutter_flight_booking/data/models/flight_model.dart';

class SearchFiltersData {
  final String? from;
  final String? to;
  final String? date;
  final int? adults;

  const SearchFiltersData({this.from, this.to, this.date, this.adults});
}
