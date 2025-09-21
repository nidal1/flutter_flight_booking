import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/core/providers/auth_user_provider.dart';
import 'package:flutter_flight_booking/data/models/flight_providers.dart';
import 'package:flutter_flight_booking/data/models/flight_model.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flight_booking/shared/widgets/flight_card.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _flightDatePickerController = TextEditingController();
  final _passengersController = TextEditingController();

  double _formTop = 10.0;
  final double _initialFormTop = 10.0;
  final double _maxFormTop = 150.0;

  // Pagination State
  List<Flight> _allFlights = [];
  List<Flight> _displayedFlights = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final int _pageSize = 10;
  // End Pagination State

  DateTime? _selectedDate;

  void scrollListener() {
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position.pixels;

      setState(() {
        // As you scroll down (offset increases), we increase the top padding
        // until it reaches the max value.
        _formTop = (_initialFormTop + scrollPosition).clamp(
          _initialFormTop,
          _maxFormTop,
        );
      });

      // Pagination logic
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreFlights();
      }
    });
  }

  @override
  void initState() {
    fetchFlights();
    _passengersController.text = '1';
    super.initState();
    scrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchFlights() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final allFlights = await ref.read(homeScreenFlightsProvider.future);
      if (!mounted) return;
      setState(() {
        _allFlights = allFlights;
        _displayedFlights = _allFlights.take(_pageSize).toList();
        _hasMore = _allFlights.length > _displayedFlights.length;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _loadMoreFlights() {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate a network delay for loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final currentLength = _displayedFlights.length;
      final moreFlights = _allFlights
          .skip(currentLength)
          .take(_pageSize)
          .toList();

      setState(() {
        _displayedFlights.addAll(moreFlights);
        _isLoading = false;
        _hasMore = _displayedFlights.length < _allFlights.length;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!mounted) return;
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _flightDatePickerController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  void _increasePassengers() {
    int currentCount = int.tryParse(_passengersController.text) ?? 1;
    currentCount++;
    setState(() {
      _passengersController.text = currentCount.toString();
    });
  }

  void _decreasePassengers() {
    int currentCount = int.tryParse(_passengersController.text) ?? 1;
    if (currentCount > 1) {
      currentCount--;
      setState(() {
        _passengersController.text = currentCount.toString();
      });
    }
  }

  void updatePassengers(int count) {
    setState(() {
      _passengersController.text = count.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authUserProvider);

    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.goodMorning,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          user.user?.displayName ?? 'Anonyms',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: () {
                        // Action
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 120.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.chooseYour,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.departingFlight,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.only(top: _formTop, left: 16, right: 16),
              child: Column(
                children: [
                  _buildDepartingFlight(
                    context,
                    _fromController,
                    _toController,
                    _flightDatePickerController,
                    _passengersController,
                    _selectedDate,
                    _selectDate,
                    _increasePassengers,
                    _decreasePassengers,
                  ),
                  Expanded(
                    child: _buildFlightCategory(
                      context: context,
                      title: l10n.recentFlights,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCategory({
    required BuildContext context,
    required String title,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // This assumes you have a route like '/flights' configured in go_router.
                  // The category title is passed as an 'extra' argument.
                  context.push('/flights', extra: title);
                },
                child: Text(l10n.seeMore),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _displayedFlights.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _displayedFlights.length) {
                // Last item: loading indicator or empty space
                return _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              final flight = _displayedFlights[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FlightCard(flight: flight),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildDepartingFlight(
  BuildContext context,
  TextEditingController _fromController,
  TextEditingController _toController,
  TextEditingController _flightDatePickerController,
  TextEditingController _passengersController,
  DateTime? _selectedDate,
  Future<void> Function(BuildContext) _selectDate,
  void Function() _increasePassengers,
  void Function() _decreasePassengers,
) {
  final l10n = AppLocalizations.of(context)!;
  return Material(
    elevation: 4,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          TextField(
            controller: _fromController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.flight_takeoff),
              hintText: l10n.from,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _toController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.flight_land),
              hintText: l10n.to,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _flightDatePickerController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today),
              hintText: l10n.selectDate,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  controller: _passengersController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: l10n.passengers,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  IconButton.filled(
                    icon: Icon(
                      Icons.remove,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Decrease passengers
                      _decreasePassengers();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      _passengersController.text,
                    ), // Display current count
                  ),
                  IconButton.filled(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Increase passengers
                      _increasePassengers();
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              final from = _fromController.text;
              final to = _toController.text;
              final date = _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate)
                  : '';

              final adults = int.tryParse(_passengersController.text) ?? 1;

              if (from.isEmpty || to.isEmpty || date.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  // TODO: Localize this string
                  SnackBar(content: Text(l10n.pleaseFillAllFields)),
                );
                return;
              }

              SearchFiltersData searchFiltersData = SearchFiltersData(
                from: from,
                to: to,
                date: date,
                adults: adults,
              );

              context.push('/search', extra: searchFiltersData);
            },
            child: Text(l10n.searchFlights),
          ),
        ],
      ),
    ),
  );
}
