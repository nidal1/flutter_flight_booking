import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/data/models/flight_providers.dart';
import 'package:flutter_flight_booking/shared/widgets/detailed_flight_card.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightCategoriesScreen extends ConsumerStatefulWidget {
  final String? category;

  const FlightCategoriesScreen({super.key, this.category});

  @override
  ConsumerState<FlightCategoriesScreen> createState() =>
      _FlightCategoriesScreenState();
}

class _FlightCategoriesScreenState
    extends ConsumerState<FlightCategoriesScreen> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Use the category passed from the home screen, or default to "All flights"
    // The passed category is not localized, so we can use it directly.
    _selectedCategory = widget.category ?? "All flights";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Map<String, String> categories = {
      "All flights": l10n.allFlights,
      "Recent flights": l10n.recentFlights,
      "Incoming flights": l10n.incomingFlights,
      "Domestic": l10n.domestic,
      "International": l10n.international,
    };

    return Scaffold(
      appBar: AppBar(
        // The back arrow is added automatically by the router
        title: Text(l10n.flights),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryChips(categories),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              categories[_selectedCategory] ?? _selectedCategory,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 8, // Dummy count
              itemBuilder: (context, index) {
                // Here you would filter flights based on _selectedCategory
                return DetailedFlightCard(
                  flight: Flight(
                    airline: "Airline",
                    date: DateTime.now(),
                    from: "SUV",
                    fromCity: "SUV City",
                    to: "MAP",
                    toCity: "MAP City",
                    departureTime: DateTime.now(),
                    arrivalTime: DateTime.now(),
                    duration: "1h30min",
                    price: "120",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(Map<String, String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 4.0),
      child: Row(
        children: categories.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(entry.value),
              selected: _selectedCategory == entry.key,
              onSelected: (isSelected) {
                if (isSelected) {
                  setState(() {
                    _selectedCategory = entry.key;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
