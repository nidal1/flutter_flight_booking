import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/data/models/flight_providers.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:flutter_flight_booking/shared/widgets/detailed_flight_card.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightSearchScreen extends ConsumerStatefulWidget {
  final SearchFiltersData searchFilters;
  const FlightSearchScreen({super.key, required this.searchFilters});

  @override
  ConsumerState<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends ConsumerState<FlightSearchScreen> {
  final _searchController = TextEditingController();
  String? _sortByValue = 'Price';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final flightsAsyncValue = ref.watch(flightsProvider(widget.searchFilters));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.searchFlightsHint,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSortByDropdown(),
          Expanded(
            child: flightsAsyncValue.when(
              data: (flights) {
                if (flights.isEmpty) {
                  // TODO: Localize this string
                  return Center(child: Text(l10n.noFlightsFound));
                }

                // Sorting logic
                final sortedFlights = List<Flight>.from(flights);
                sortedFlights.sort((a, b) {
                  switch (_sortByValue) {
                    case 'Price':
                      return a.price.compareTo(b.price);
                    case 'Departure':
                      return a.date.compareTo(b.date);
                    case 'Duration':
                      // TODO: Implement duration sorting. Requires duration property in Flight model.
                      return 0;
                    default:
                      return 0;
                  }
                });

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: sortedFlights.length,
                  itemBuilder: (context, index) {
                    // Note: This assumes `DetailedFlightCard` accepts a `flight` parameter.
                    // You may need to update `DetailedFlightCard` to handle the flight data.
                    return DetailedFlightCard(flight: sortedFlights[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('${l10n.anErrorOccurred}: $error'),
              ), // TODO: Localize this
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortByDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            AppLocalizations.of(context)!.sortBy,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _sortByValue,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'Price',
                child: Text(AppLocalizations.of(context)!.price),
              ),
              DropdownMenuItem<String>(
                value: 'Duration',
                child: Text(AppLocalizations.of(context)!.duration),
              ),
              DropdownMenuItem<String>(
                value: 'Departure',
                child: Text(AppLocalizations.of(context)!.departure),
              ),
            ],
            onChanged: (String? newValue) {
              setState(() {
                _sortByValue = newValue;
              });
            },
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }
}
