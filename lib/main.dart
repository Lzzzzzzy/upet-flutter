import 'package:flutter/material.dart';
import 'package:upet_flutter/app_state/state.dart';
import 'package:upet_flutter/common/color.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upet_flutter/components/calendar/calendar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 245, 255, 202)),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const CustomCalendar(
            showCalendarFormatBtn: true, calendarFormat: CalendarFormat.week);
        break;
      case 1:
        page = const CustomCalendar(
            showCalendarFormatBtn: true, calendarFormat: CalendarFormat.week);
        // page = FavoritesPage();
        break;
      case 2:
        page = const CustomCalendar(
            showCalendarFormatBtn: true, calendarFormat: CalendarFormat.week);
        // page = FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

    return Scaffold(
      body: SafeArea(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: _buildIcon(Icons.calendar_month, 0), label: ""),
          BottomNavigationBarItem(icon: _buildIcon(Icons.search, 1), label: ""),
          BottomNavigationBarItem(icon: _buildIcon(Icons.person, 2), label: ""),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: selectedBottomBarColor,
        backgroundColor: bottomBarBackgroundColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
          color: isSelected ? wramYellow : Colors.transparent,
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(15), right: Radius.circular(15))),
      child: Icon(
        iconData,
        color: isSelected ? Colors.black.withOpacity(0.7) : Colors.grey,
      ),
    );
  }
}
