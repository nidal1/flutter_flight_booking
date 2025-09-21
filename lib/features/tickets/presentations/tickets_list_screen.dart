import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/shared/widgets/ticket_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/features/tickets/controllers/ticket_providers.dart';

class TicketsListScreen extends ConsumerStatefulWidget {
  const TicketsListScreen({super.key});

  @override
  ConsumerState<TicketsListScreen> createState() => TicketsListScreenState();
}

class TicketsListScreenState extends ConsumerState<TicketsListScreen> {
  bool _isListView = true;
  String _selectedChip = 'All tickets';
  final List<String> _chips = [
    'All tickets',
    'Incoming tickets',
    'Outdated tickets',
  ];

  // --- Handlers for Calendar View ---
  Future<void> _onHeaderTapped(DateTime focusedDay) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: focusedDay,
      firstDate: DateTime.utc(2020, 1, 1),
      lastDate: DateTime.utc(2030, 12, 31),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      setState(() {
        _focusedDay = selectedDate;
      });
    }
  }

  // --- State for Calendar View ---
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final userTicketsAsync = ref.watch(userTicketsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        // The back arrow is not needed as this is a main tab
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _isListView ? Icons.calendar_month_outlined : Icons.view_list,
            ),
            tooltip: _isListView ? 'Calendar View' : 'List View',
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: userTicketsAsync.when(
              data: (tickets) {
                if (tickets.isEmpty) {
                  return const Center(child: Text('You have no tickets yet.'));
                }
                return _isListView
                    ? _buildTicketList(tickets)
                    : _buildCalendarView(tickets);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('An error occurred: $error')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Ticket> _getEventsForDay(DateTime day, List<Ticket> allTickets) {
    // This simple implementation filters the list of all tickets.
    return allTickets.where((ticket) => isSameDay(ticket.date, day)).toList();
  }

  Widget _buildCategoryChips() {
    // TODO: This should be localized
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      child: Row(
        children: _chips.map((chip) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(chip),
              selected: _selectedChip == chip,
              onSelected: (isSelected) {
                if (isSelected) {
                  setState(() {
                    _selectedChip = chip;
                    // TODO: Add logic to filter tickets
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> allTickets) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: allTickets.length,
      itemBuilder: (context, index) {
        // Here you would filter tickets based on _selectedChip
        return TicketCard(ticket: allTickets[index]);
      },
    );
  }

  Widget _buildCalendarView(List<Ticket> allTickets) {
    final selectedDayEvents = _getEventsForDay(_selectedDay!, allTickets);

    return Column(
      children: [
        TableCalendar<Ticket>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: (day) => _getEventsForDay(day, allTickets),
          calendarStyle: CalendarStyle(
            // Use a dot marker for days with events
            markerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          onHeaderTapped: _onHeaderTapped,
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: selectedDayEvents.isEmpty
              ? const Center(child: Text('No flights on this day.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  itemCount: selectedDayEvents.length,
                  itemBuilder: (context, index) {
                    return TicketCard(ticket: selectedDayEvents[index]);
                  },
                ),
        ),
      ],
    );
  }
}
