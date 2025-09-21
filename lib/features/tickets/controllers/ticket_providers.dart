import 'package:flutter_flight_booking/data/repositories/ticket_repository.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return FirestoreTicketRepository();
});

final userTicketsStreamProvider = StreamProvider.autoDispose<List<Ticket>>((
  ref,
) {
  final ticketRepository = ref.watch(ticketRepositoryProvider);
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ticketRepository.userTicketsStream(user.uid);
  }
  return Stream.value([]);
});
