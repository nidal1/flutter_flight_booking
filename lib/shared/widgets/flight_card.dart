import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        margin: const EdgeInsets.only(right: 16.0, bottom: 4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.push('/flight-details', extra: flight);
          },
          child: ListTile(
            leading: const Icon(Icons.flight),
            title: Text(
              flight.airline,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${flight.from} to ${flight.to}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  flight.duration,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${flight.price} \$',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
