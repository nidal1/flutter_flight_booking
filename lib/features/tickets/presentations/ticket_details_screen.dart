import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flight_booking/features/tickets/presentations/ticket_screen.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yourTicket, style: textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildTicketCard(context, l10n, ticket),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    AppLocalizations l10n,
    Ticket ticket,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Info
            Text(
              ticket.airline,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.from,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.flight, size: 28),
                Text(
                  ticket.to,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.jm().format(ticket.departureTime),
                  style: textTheme.bodyLarge,
                ),
                Text(
                  ticket.duration,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  DateFormat.jm().format(ticket.arrivalTime),
                  style: textTheme.bodyLarge,
                ),
              ],
            ),

            const Divider(height: 32),

            // Passenger Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(l10n.passenger, ticket.passengerName),
                _buildDetailItem(
                  l10n.seatNumber,
                  ticket.seat,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(l10n.terminal, '2'),
                _buildDetailItem(
                  l10n.ticketClass,
                  'Economy',
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  l10n.date,
                  DateFormat.yMMMd().format(ticket.date),
                ),
                _buildDetailItem(
                  l10n.passportId,
                  ticket.passportId,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),

            // Barcode
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CustomPaint(
                painter: DashedLinePainter(),
                child: const SizedBox(height: 1, width: double.infinity),
              ),
            ),
            Center(
              child: Text(
                l10n.scanThisBarcode,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Icon(
                Icons.qr_code_2_sharp,
                size: 120,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
