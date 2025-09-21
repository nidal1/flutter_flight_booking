import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passengers_infos_data.dart';

class SelectSeatsScreen extends StatefulWidget {
  final Flight flight;
  const SelectSeatsScreen({super.key, required this.flight});

  @override
  State<SelectSeatsScreen> createState() => _SelectSeatsScreenState();
}

class _SelectSeatsScreenState extends State<SelectSeatsScreen> {
  // Dummy data for seat layout.
  // 'A': available, 'T': taken, 'S': selected
  final Map<String, String> _seatStatus = {
    '1A': 'A',
    '1B': 'A',
    '1C': 'T',
    '1D': 'T',
    '1E': 'A',
    '1F': 'A',
    '2A': 'A',
    '2B': 'T',
    '2C': 'A',
    '2D': 'A',
    '2E': 'T',
    '2F': 'A',
    '3A': 'A',
    '3B': 'A',
    '3C': 'A',
    '3D': 'A',
    '3E': 'A',
    '3F': 'A',
    '4A': 'T',
    '4B': 'A',
    '4C': 'A',
    '4D': 'T',
    '4E': 'A',
    '4F': 'T',
    '5A': 'A',
    '5B': 'A',
    '5C': 'T',
    '5D': 'A',
    '5E': 'A',
    '5F': 'A',
    '6A': 'A',
    '6B': 'T',
    '6C': 'T',
    '6D': 'T',
    '6E': 'A',
    '6F': 'A',
    '7A': 'A',
    '7B': 'A',
    '7C': 'A',
    '7D': 'A',
    '7E': 'T',
    '7F': 'T',
    '8A': 'T',
    '8B': 'T',
    '8C': 'A',
    '8D': 'A',
    '8E': 'A',
    '8F': 'A',
    '9A': 'A',
    '9B': 'A',
    '9C': 'A',
    '9D': 'T',
    '9E': 'A',
    '9F': 'T',
    '10A': 'A',
    '10B': 'T',
    '10C': 'A',
    '10D': 'A',
    '10E': 'A',
    '10F': 'A',
  };

  final List<String> _selectedSeats = [];
  final double _seatPrice = 199.0;

  void _onSeatTap(String seatId) {
    // Cannot select more than 5 seats in this example
    if (_selectedSeats.length >= 5 && !_selectedSeats.contains(seatId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can select a maximum of 5 seats.')),
      );
      return;
    }

    setState(() {
      if (_seatStatus[seatId] == 'A') {
        _seatStatus[seatId] = 'S';
        _selectedSeats.add(seatId);
      } else if (_seatStatus[seatId] == 'S') {
        _seatStatus[seatId] = 'A';
        _selectedSeats.remove(seatId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [_buildSliverAppBar(context), _buildSeatGrid()],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120.0,
      title: Text('Select Seats', style: textTheme.titleMedium),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.flight.from,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Icon(Icons.flight, color: colorScheme.onSurface),
                    Text(
                      widget.flight.to,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatGrid() {
    final List<String> columnsHeader = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    const int rows = 10;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Column Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: columnsHeader
                  .map(
                    (c) => c.isEmpty
                        ? const SizedBox(width: 24)
                        : SizedBox(
                            width: 32,
                            child: Text(
                              c,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Seat Rows
            ...List.generate(rows, (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: columnsHeader.map((col) {
                    if (col.isEmpty) {
                      return Text((rowIndex + 1).toString());
                    }
                    final seatId = '${rowIndex + 1}$col';
                    final status = _seatStatus[seatId] ?? 'T';
                    return _SeatWidget(
                      status: status,
                      onTap: () => _onSeatTap(seatId),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(
        16.0,
      ).copyWith(bottom: 16.0 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Seats', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            _selectedSeats.isEmpty
                ? 'No seats selected'
                : _selectedSeats.join(', '),
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: textTheme.bodyMedium),
                  Text(
                    '\$${(_selectedSeats.length * _seatPrice).toStringAsFixed(2)}',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: _selectedSeats.isEmpty
                    ? null
                    : () {
                        final passengersData = PassengersInfosData(
                          flight: widget.flight,
                          seats: _selectedSeats,
                        );
                        context.push(
                          "/passengers-infos",
                          extra: passengersData,
                        );
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatWidget extends StatelessWidget {
  final String status; // 'A'vailable, 'T'aken, 'S'elected
  final VoidCallback onTap;

  const _SeatWidget({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color backgroundColor;
    Color borderColor;
    Widget? child;

    switch (status) {
      case 'S':
        backgroundColor = colorScheme.primary;
        borderColor = colorScheme.primary;
        child = Icon(Icons.check, color: colorScheme.onPrimary, size: 16);
        break;
      case 'T':
        backgroundColor = colorScheme.surfaceContainerHighest;
        borderColor = colorScheme.outlineVariant;
        child = Icon(
          Icons.close,
          color: colorScheme.onSurfaceVariant,
          size: 16,
        );
        break;
      case 'A':
      default:
        backgroundColor = colorScheme.surface;
        borderColor = colorScheme.primary;
        child = null;
    }

    return GestureDetector(
      onTap: status == 'T' ? null : onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
