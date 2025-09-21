import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passengers_infos_data.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passenger_info.dart';

class TicketScreen extends StatelessWidget {
  final PassengersInfosData passengersInfosData;

  const TicketScreen({super.key, required this.passengersInfosData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yourTicket, style: textTheme.titleMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: passengersInfosData.passengers.length,
              itemBuilder: (context, index) {
                final passenger = passengersInfosData.passengers[index];
                final seat = passengersInfosData.seats[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: _buildTicketCard(context, l10n, passenger, seat),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    AppLocalizations l10n,
    PassengerInfo passenger,
    String seat,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final flight = passengersInfosData.flight;

    void printMessage() {}

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: flight != null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight Info
                  Text(
                    flight.airline,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        flight.from,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.flight, size: 28),
                      Text(
                        flight.to,
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
                        DateFormat.jm().format(flight.departureTime),
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        flight.duration,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        DateFormat.jm().format(flight.arrivalTime),
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Passenger Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        l10n.passenger,
                        '${passenger.firstName} ${passenger.lastName}',
                      ),
                      _buildDetailItem(
                        l10n.seatNumber,
                        seat,
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
                        DateFormat.yMMMd().format(flight.date),
                      ),
                      _buildDetailItem(
                        l10n.passportId,
                        passenger.passportId,
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
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
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
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: FilledButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Text(
                    "No ticket data available. back to home screen?",
                    style: textTheme.bodyLarge?.copyWith(color: Colors.red),
                  ),
                ),
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

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.reschedule),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('downloading...'),
                  duration: Duration(seconds: 1),
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                context.go('/');
              });
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.downloadTicket),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
