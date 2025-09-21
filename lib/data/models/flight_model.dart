import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String? id;
  final String airline;
  final DateTime date;
  final String from;
  final String fromCity;
  final String to;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final String price;

  const Flight({
    this.id,
    required this.airline,
    required this.date,
    required this.from,
    required this.fromCity,
    required this.to,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    final dep =
        DateTime.tryParse(json['departure']?['scheduled'] ?? '') ??
        DateTime.now();
    final arr =
        DateTime.tryParse(json['arrival']?['scheduled'] ?? '') ??
        DateTime.now();

    String calcDuration = '';
    double estimatedPrice = 0;

    final diff = arr.difference(dep);
    calcDuration = "${diff.inHours}h ${diff.inMinutes % 60}m";
    estimatedPrice = _estimatePrice(diff);

    return Flight(
      airline: json['airline']?['name'] ?? '',
      date: DateTime.tryParse(json['flight_date'] ?? '') ?? DateTime.now(),
      from: json['departure']?['iata'] ?? '',
      fromCity: json['departure']?['airport'] ?? '',
      to: json['arrival']?['iata'] ?? '',
      toCity: json['arrival']?['airport'] ?? '',
      departureTime: dep,
      arrivalTime: arr,
      duration: calcDuration,
      price: "\$${estimatedPrice.toStringAsFixed(2)}",
    );
  }

  factory Flight.fromMap(Map<String, dynamic> map, String documentId) {
    return Flight(
      id: documentId,
      airline: map['airline'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      from: map['from'] ?? '',
      fromCity: map['fromCity'] ?? '',
      to: map['to'] ?? '',
      toCity: map['toCity'] ?? '',
      departureTime: (map['departureTime'] as Timestamp).toDate(),
      arrivalTime: (map['arrivalTime'] as Timestamp).toDate(),
      duration: map['duration'] ?? '',
      price: map['price'] ?? '\$0.00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'airline': airline,
      'date': date,
      'from': from,
      'fromCity': fromCity,
      'to': to,
      'toCity': toCity,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'price': price,
    };
  }

  /// function كتقدّر السعر على حساب مدة الرحلة
  static double _estimatePrice(Duration duration) {
    const basePrice = 50.0; // تسعيرة أساسية
    const hourlyRate = 70.0; // الثمن لكل ساعة
    return basePrice + (duration.inHours * hourlyRate);
  }
}
