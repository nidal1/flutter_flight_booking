import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
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
  final String passengerName;
  final String seat;
  final String passportId;
  final String userId;

  const Ticket({
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
    required this.passengerName,
    required this.seat,
    required this.passportId,
    required this.userId,
  });

  factory Ticket.fromMap(Map<String, dynamic> map, String documentId) {
    return Ticket(
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
      price: map['price'] ?? '',
      passengerName: map['passengerName'] ?? '',
      seat: map['seat'] ?? '',
      passportId: map['passportId'] ?? '',
      userId: map['userId'] ?? '',
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
      'passengerName': passengerName,
      'seat': seat,
      'passportId': passportId,
      'userId': userId,
    };
  }
}
