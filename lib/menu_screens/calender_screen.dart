import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  // today format
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // to change the calender format
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            TableCalendar(
              rowHeight: 50,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
              ),
              focusedDay: today,
              firstDay: DateTime.utc(2024, 01, 01),
              lastDay: DateTime.utc(2100),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(today, day),
              onDaySelected: _onDaySelected,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
