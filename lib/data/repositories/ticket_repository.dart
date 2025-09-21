import 'package:flutter_flight_booking/core/api_path.dart';
import 'package:flutter_flight_booking/core/services/firebase_firestore_service.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';

abstract class TicketRepository {
  Future<void> addTicket(Ticket ticket);
  Future<void> addTickets(List<Ticket> tickets);
  Future<void> updateTicket(Ticket ticket);
  Future<void> updateTickets(List<Ticket> tickets);
  Future<void> deleteTicket(String ticketId);
  Future<void> deleteTickets(List<String> ticketIds);
  Stream<List<Ticket>> ticketsStream();
  Stream<List<Ticket>> userTicketsStream(String userId);
}

class FirestoreTicketRepository implements TicketRepository {
  final _service = FirebaseFirestoreService.instance;

  @override
  Future<void> addTicket(Ticket ticket) =>
      _service.addData(collectionPath: APIPath.tickets(), data: ticket.toMap());

  @override
  Future<void> addTickets(List<Ticket> tickets) => _service.bulkAdd(
    collectionPath: APIPath.tickets(),
    data: tickets.map((ticket) => ticket.toMap()).toList(),
  );

  @override
  Future<void> updateTicket(Ticket ticket) => _service.setData(
    path: APIPath.ticket(ticket.id!),
    data: ticket.toMap(),
    merge: true,
  );

  @override
  Future<void> updateTickets(List<Ticket> tickets) {
    final Map<String, Map<String, dynamic>> data = {
      for (var ticket in tickets) ticket.id!: ticket.toMap(),
    };
    return _service.bulkUpdate(collectionPath: APIPath.tickets(), data: data);
  }

  @override
  Future<void> deleteTicket(String ticketId) =>
      _service.deleteData(path: APIPath.ticket(ticketId));

  @override
  Future<void> deleteTickets(List<String> ticketIds) =>
      _service.bulkDelete(collectionPath: APIPath.tickets(), docIds: ticketIds);

  @override
  Stream<List<Ticket>> ticketsStream() => _service.collectionStream(
    path: APIPath.tickets(),
    builder: (data, documentId) => Ticket.fromMap(data, documentId),
  );

  @override
  Stream<List<Ticket>> userTicketsStream(String userId) {
    // For production, you should modify collectionStream to accept queries for better performance.
    return ticketsStream().map(
      (tickets) => tickets.where((ticket) => ticket.userId == userId).toList(),
    );
  }
}
