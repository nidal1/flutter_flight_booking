import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DetailedFlightCard extends StatelessWidget {
  final Flight flight;
  const DetailedFlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Company and Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.airline,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_sharp,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flight.duration,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row 2: Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('h:mm a').format(flight.departureTime),
                  style: textTheme.titleMedium,
                ),
                Text(
                  DateFormat('h:mm a').format(flight.arrivalTime),
                  style: textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Row 3: Locations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flight_takeoff, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      flight.from,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.flight, size: 16),
                Row(
                  children: [
                    Text(
                      flight.to,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.flight_land, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Row 4: See more details button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.push('/flight-details', extra: flight);
                },
                child: Text(l10n.seeMoreDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
