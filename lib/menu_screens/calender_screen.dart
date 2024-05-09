import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/interventions/model/data_models/intervention.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  //today format
  DateTime selectedDay = DateTime.now();
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      // selectedDay = day;
      this.selectedDay = selectedDay;
    });
  }

  // to change the calender format
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 9.0, right: 9, bottom: 9),
          child: Column(
            children: [
              TableCalendar(
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.85),
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
                rowHeight: 50,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: true,
                ),
                focusedDay: selectedDay,
                firstDay: DateTime.utc(2024, 01, 01),
                lastDay: DateTime.utc(2100),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                onDaySelected: _onDaySelected,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('interventions')
                        .where('interventionDate',
                            isEqualTo:
                                selectedDay.toIso8601String().split('T').first)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 50.0,
                              ),
                              SizedBox(height: 10.0),
                              Text("Lost connection"),
                            ],
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text("Loading Notifications ...")
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const CircularProgressIndicator(),
                              Center(
                                child: Text('Error: ${snapshot.error}'),
                              ),
                            ],
                          ),
                        );
                      }
                      // data found
                      List<Intervention> interventions = snapshot.data!.docs
                          .map(
                            (document) => Intervention.fromJson(
                              document.data(),
                            ),
                          )
                          .toList();
                      if (interventions.isEmpty) {
                        return Center(
                          child: Text(
                            'No intervention available this day!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: interventions.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.red[100],
                              child: ListTile(
                                title: Text(
                                  interventions[index].equipmentTagName,
                                ),
                                subtitle:
                                    Text(interventions[index].interventionType),
                                leading: const Icon(Icons.file_copy),
                              ),
                            );
                          });
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
