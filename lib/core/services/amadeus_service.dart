import 'dart:convert';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class AmadeusQueryParameters {
  final String originLocationCode;
  final String destinationLocationCode;
  final String departureDate;
  final String nonStop;
  final int adults;
  final int max;

  AmadeusQueryParameters({
    required this.departureDate,
    required this.originLocationCode,
    required this.destinationLocationCode,
    required this.nonStop,
    required this.adults,
    required this.max,
  });

  toJson() {
    return {
      'originLocationCode': originLocationCode,
      'destinationLocationCode': destinationLocationCode,
      'departureDate': departureDate,
      'adults': adults.toString(),
      'nonStop': nonStop,
      'max': max.toString(),
    };
  }
}

class AmadeusService {
  final String? _apiKey = dotenv.env['AMADEUS_API_KEY'];
  final String? _apiSecret = dotenv.env['AMADEUS_API_SECRET'];
  String? _accessToken;
  DateTime? _tokenExpiry;

  static const String _baseUrl = 'https://test.api.amadeus.com';
  static const String _tokenEndpoint = '$_baseUrl/v1/security/oauth2/token';
  static const String _flightOffersEndpoint =
      '$_baseUrl/v2/shopping/flight-offers';

  Future<void> _getAccessToken() async {
    if (_apiKey == null || _apiSecret == null) {
      throw Exception('Amadeus API key or secret is not available.');
    }

    // Check if token is still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return;
    }

    final response = await http.post(
      Uri.parse(_tokenEndpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': _apiKey,
        'client_secret': _apiSecret,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      _accessToken = body['access_token'];
      final expiresIn = body['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(
        Duration(seconds: expiresIn - 60),
      ); // 60s buffer
    } else {
      throw Exception('Failed to get Amadeus access token: ${response.body}');
    }
  }

  Future<List<Flight>> fetchFlights(SearchFiltersData? filters) async {
    try {
      await _getAccessToken();
      if (_accessToken == null) {
        throw Exception('Amadeus access token is not available.');
      }

      // Use provided filters, or fall back to default search for home screen.
      final searchFilters =
          filters ??
          SearchFiltersData(
            from: 'LHR', // Default: London Heathrow
            to: 'CDG', // Default: Paris Charles de Gaulle
            date: DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now().add(const Duration(days: 1))),
            adults: 1,
          );

      // Validate that the final search filters have the required data.
      if (searchFilters.from == null ||
          searchFilters.to == null ||
          searchFilters.date == null) {
        throw Exception(
          'Invalid search query. "From", "To", and "Date" are required.',
        );
      }

      final queryParams = AmadeusQueryParameters(
        departureDate: searchFilters.date!,
        originLocationCode: searchFilters.from!,
        destinationLocationCode: searchFilters.to!,
        nonStop: 'true',
        adults: searchFilters.adults ?? 1,
        max: 5,
      ).toJson();

      final uri = Uri.parse(
        _flightOffersEndpoint,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] as List?;
        if (data == null || data.isEmpty) {
          return [];
        }

        // The dictionary is needed to get airline names from IATA codes.
        final dictionaries = body['dictionaries'];

        List<Flight> flights = data.map((flightData) {
          return _mapAmadeusToFlight(flightData, dictionaries);
        }).toList();

        return flights;
      } else {
        String errorMessage = 'Failed to load flights: ${response.statusCode}';
        try {
          final errorBody = json.decode(response.body);
          errorMessage += ' - ${errorBody['errors'][0]['detail']}';
        } catch (_) {
          errorMessage += ' - ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(e.toString());
      throw Exception('An error occurred while fetching flights: $e');
    }
  }

  Future<List<Flight>> fetchMultipleFlightOffers() async {
    // Define a list of popular routes to feature on the home screen.
    final List<Map<String, String>> routes = [
      {'from': 'LHR', 'to': 'CDG'}, // London to Paris
      {'from': 'JFK', 'to': 'LAX'}, // New York to Los Angeles
      {'from': 'SYD', 'to': 'MEL'}, // Sydney to Melbourne
      {'from': 'HND', 'to': 'FUK'}, // Tokyo-Haneda to Fukuoka
    ];

    final tomorrow = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().add(const Duration(days: 1)));

    // Create a list of futures for all the API calls.
    // Each call is wrapped in a catchError to prevent a single failure
    // from stopping the entire process.
    final List<Future<List<Flight>>> flightFutures = routes.map((route) {
      final filters = SearchFiltersData(
        from: route['from'],
        to: route['to'],
        date: tomorrow,
        adults: 1,
      );
      return fetchFlights(filters).catchError((_) => <Flight>[]);
    }).toList();

    // Wait for all the API calls to complete.
    final List<List<Flight>> results = await Future.wait(flightFutures);

    // Flatten the list of lists into a single list of flights and shuffle it
    // to make the feed appear more dynamic.
    final allFlights = results.expand((flights) => flights).toList();
    allFlights.shuffle();

    return allFlights;
  }

  Flight _mapAmadeusToFlight(
    Map<String, dynamic> flightData,
    Map<String, dynamic>? dictionaries,
  ) {
    final itinerary = flightData['itineraries'][0];
    final segment = itinerary['segments'][0];
    final departure = segment['departure'];
    final arrival = segment['arrival'];
    final price = flightData['price']['total'];
    final carrierCode = segment['carrierCode'];
    final airlineName = dictionaries?['carriers']?[carrierCode] ?? carrierCode;

    return Flight(
      id: flightData['id'],
      airline: airlineName,
      from: departure['iataCode'],
      fromCity: departure['iataCode'],
      to: arrival['iataCode'],
      toCity: arrival['iataCode'],
      departureTime: DateTime.parse(departure['at']),
      arrivalTime: DateTime.parse(arrival['at']),
      date: DateTime.parse(departure['at']),
      duration: itinerary['duration'],
      price: price,
    );
  }
}
