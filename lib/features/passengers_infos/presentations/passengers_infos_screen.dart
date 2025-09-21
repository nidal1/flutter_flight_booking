import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/data/models/ticket_model.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passengers_infos_data.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_flight_booking/features/passengers_infos/data/passenger_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flight_booking/core/providers/auth_user_provider.dart';
import 'package:flutter_flight_booking/features/auth/controllers/auth_providers.dart';
import 'package:flutter_flight_booking/features/tickets/controllers/ticket_providers.dart';

class PassengersInfosScreen extends ConsumerStatefulWidget {
  final PassengersInfosData initialData;
  const PassengersInfosScreen({super.key, required this.initialData});

  @override
  ConsumerState<PassengersInfosScreen> createState() =>
      _PassengersInfosScreenState();
}

class _PassengersInfosScreenState extends ConsumerState<PassengersInfosScreen> {
  late List<GlobalKey<FormState>> _formKeys;
  late List<TextEditingController> _firstNameControllers;
  late List<TextEditingController> _lastNameControllers;
  late List<TextEditingController> _passportIdControllers;

  @override
  void initState() {
    super.initState();
    final numberOfPassengers = widget.initialData.seats.length;
    _formKeys = List.generate(
      numberOfPassengers,
      (_) => GlobalKey<FormState>(),
    );
    _firstNameControllers = List.generate(
      numberOfPassengers,
      (_) => TextEditingController(),
    );
    _lastNameControllers = List.generate(
      numberOfPassengers,
      (_) => TextEditingController(),
    );
    _passportIdControllers = List.generate(
      numberOfPassengers,
      (_) => TextEditingController(),
    );

    // Pre-fill the first passenger's info
    if (numberOfPassengers > 0) {
      final user = ref.read(authUserProvider).user;
      if (user != null &&
          user.displayName != null &&
          user.displayName!.isNotEmpty) {
        final nameParts = user.displayName!.split(' ');
        _firstNameControllers[0].text = nameParts.first;
        if (nameParts.length > 1) {
          _lastNameControllers[0].text = nameParts.sublist(1).join(' ');
        }
      }
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _firstNameControllers.length; i++) {
      _firstNameControllers[i].dispose();
      _lastNameControllers[i].dispose();
      _passportIdControllers[i].dispose();
    }
    super.dispose();
  }

  void _onConfirm() async {
    bool allFormsValid = true;
    for (final formKey in _formKeys) {
      if (!formKey.currentState!.validate()) {
        allFormsValid = false;
      }
    }

    if (allFormsValid) {
      final passengers = <PassengerInfo>[];
      for (var i = 0; i < widget.initialData.seats.length; i++) {
        passengers.add(
          PassengerInfo(
            firstName: _firstNameControllers[i].text,
            lastName: _lastNameControllers[i].text,
            passportId: _passportIdControllers[i].text,
          ),
        );
      }

      final updatedData = PassengersInfosData(
        flight: widget.initialData.flight,
        seats: widget.initialData.seats,
        passengers: passengers,
      );

      final user = ref.read(authStateChangesProvider).value;
      final flight = widget.initialData.flight;

      if (user != null && flight != null) {
        final newTickets = <Ticket>[];
        for (var i = 0; i < passengers.length; i++) {
          final passenger = passengers[i];
          final seat = widget.initialData.seats[i];

          newTickets.add(
            Ticket(
              userId: user.uid,
              airline: flight.airline,
              from: flight.from,
              fromCity: flight.fromCity,
              to: flight.to,
              toCity: flight.toCity,
              departureTime: flight.departureTime,
              arrivalTime: flight.arrivalTime,
              date: flight.date,
              duration: flight.duration,
              passengerName: passenger.firstName + " " + passenger.lastName,
              passportId: passenger.passportId,
              seat: seat,
              price: flight.price,
            ),
          );
        }
        try {
          await ref.read(ticketRepositoryProvider).addTickets(newTickets);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to save tickets: $e')));
          return;
        }
      }
      if (mounted) context.push('/ticket', extra: updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.passengerInformation, style: textTheme.titleMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.initialData.seats.length,
              itemBuilder: (context, index) {
                return _buildPassengerFormCard(context, index, l10n);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
              onPressed: _onConfirm,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(l10n.confirmAndProceed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerFormCard(
    BuildContext context,
    int index,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeys[index],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.passenger} ${index + 1} - Seat ${widget.initialData.seats[index]}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameControllers[index],
                decoration: InputDecoration(
                  labelText: l10n.firstName,
                  hintText: l10n.enterFirstName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterFirstName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameControllers[index],
                decoration: InputDecoration(
                  labelText: l10n.lastName,
                  hintText: l10n.enterLastName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterLastName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passportIdControllers[index],
                decoration: InputDecoration(
                  labelText: l10n.passportId,
                  hintText: l10n.enterPassportId,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterPassportId;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
