import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Flight flight;
  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${flight.airline}: ${flight.from} - ${flight.to}',
          style: textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFlightPathCard(context, textTheme, colorScheme),
            const SizedBox(height: 24),
            _buildDetailsCard(context, l10n),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to seat selection or booking confirmation

                  context.push('/select-seats', extra: flight);
                },
                // TODO: Add 'confirmFlight' to your localization files (e.g., app_en.arb)
                child: Text(l10n.searchFlights),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightPathCard(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLocationColumn(
              context,
              time: DateFormat.jm().format(flight.departureTime),
              airportCode: flight.from,
              city: flight.fromCity,
            ),
            Column(
              children: [
                Icon(Icons.flight, color: colorScheme.primary, size: 22),
                const SizedBox(height: 8),
                Text(
                  flight.duration,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            _buildLocationColumn(
              context,
              time: DateFormat.jm().format(flight.arrivalTime),
              airportCode: flight.to,
              city: flight.toCity,
              alignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDetailRow(l10n.airline, flight.airline),
            const Divider(height: 24),
            _buildDetailRow(l10n.date, DateFormat.yMMMd().format(flight.date)),
            const Divider(height: 24),
            _buildDetailRow(l10n.price, flight.price),
            const Divider(height: 24),
            _buildDetailRow(l10n.ticketClass, 'Economy'), // Assuming Economy
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
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
          time,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(airportCode, style: textTheme.headlineSmall),
        const SizedBox(height: 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            city,

            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
