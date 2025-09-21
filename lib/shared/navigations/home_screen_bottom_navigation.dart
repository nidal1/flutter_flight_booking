import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/l10n/app_localizations.dart';

BottomNavigationBar homeScreenBottomNavigation({
  int selectedIndex = 0,
  required BuildContext context,
  required Function(int) onItemTapped,
}) {
  final l10n = AppLocalizations.of(context)!;
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
      // BottomNavigationBarItem(
      //   icon: const Icon(Icons.search),
      //   label: l10n.search,
      // ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.confirmation_number_outlined),
        label: l10n.tickets,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ],
    selectedItemColor: Theme.of(context).colorScheme.primary,
    unselectedItemColor: Colors.grey,
    currentIndex: selectedIndex,
    onTap: onItemTapped,
  );
}
