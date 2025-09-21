import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/features/search/data/search_filters_data.dart';
import 'package:flutter_flight_booking/features/search/presentations/flight_search_screen.dart';
import 'package:flutter_flight_booking/shared/navigations/home_screen_bottom_navigation.dart';
import 'package:flutter_flight_booking/features/home/presentation/home_screen.dart';
import 'package:flutter_flight_booking/features/settings/settings_screen.dart';
import 'package:flutter_flight_booking/features/tickets/presentations/tickets_list_screen.dart';

class HomeScreenTabs extends StatefulWidget {
  const HomeScreenTabs({Key? key}) : super(key: key);

  @override
  HomeScreenTabsState createState() => HomeScreenTabsState();
}

class HomeScreenTabsState extends State<HomeScreenTabs> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // FlightSearchScreen(searchFilters: SearchFiltersData()),
    TicketsListScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: homeScreenBottomNavigation(
        context: context,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
