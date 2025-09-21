import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to the detailed ticket view
          context.push('/ticket-details', extra: ticket);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.airline,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd().format(ticket.date),
                    style: textTheme.bodyMedium?.copyWith(
                      color: textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLocationColumn(
                    context,
                    time: ticket.departureTime.toString(),
                    airportCode: ticket.from,
                    city: ticket.fromCity,
                  ),
                  Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.flight, color: colorScheme.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "3h 00m",
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  _buildLocationColumn(
                    context,
                    time: ticket.arrivalTime.toString(),
                    airportCode: ticket.to,
                    city: ticket.toCity,
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationColumn(
    BuildContext context, {
    required String time,
    required String airportCode,
    required String city,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          DateFormat.jm().format(DateTime.parse(time)),
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(airportCode, style: textTheme.bodyLarge),
        const SizedBox(height: 2),
        Text(city, style: textTheme.bodySmall),
      ],
    );
  }
}
