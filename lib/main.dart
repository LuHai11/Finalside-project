import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Chart.dart';
import 'Counting.dart';
import 'main1.dart';



// Holiday will display red word
final Map<DateTime, List> _holidays = {
  DateTime(2021, 3, 1): ["228"],
};


// Main
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

// MyApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Hide the top status bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'FlutterDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'HomePage'),
    );
  }
}


// HomePage
class HomePage extends StatefulWidget {
  final String title;
  HomePage({super.key, required this.title});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late  Map<DateTime, List> _events;
  late  List _selectedEvents;
  late  AnimationController _animationController;
  late  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    // Today
    final _selectedDay = DateTime.now();

    // Events
    _events = {
      _selectedDay.add(Duration(days: -1)): [
        '早餐 100元',
        '飲料 60元',
        '看電影 300元'
      ],

    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print("CALLBACK: _onDaySelected");
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print("CALLBACK: _onVisibleDaysChanged");
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print("CALLBACK: _onCalendarCreated");
  }

  int _selectedIndex = 0;
  final pages = [MyApp(),Lottery(),Chart()];
  // Basic interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTableCalendar(),
          Expanded(child: _buildEventList()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'EatToday',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe44c, fontFamily: 'MaterialIcons')),
            label: 'Note',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(context, MaterialPageRoute(builder: (context) =>pages[index]));
      _selectedIndex = 0;
    });
  }
  // Simple TableCalendar configuration (using Style)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,

      // Calendar
      calendarStyle: CalendarStyle(
        selectedColor: Colors.lightBlueAccent[400],
        todayColor: Colors.lightBlueAccent[100],
        markersColor: Colors.lightBlue[600],
        outsideDaysVisible: false,
      ),

      // Header
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(
          color: Colors.white,
          fontSize: 15.0,
        ),
        formatButtonDecoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),

      // Operating
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // Event List
  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map(
              (event) => Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent[100],
              border: Border.all(width: 0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: ListTile(
              title: Text(event.toString()),
              onTap: () => print("${event} tapped!"),
            ),
          )
      ).toList(),
    );
  }
}