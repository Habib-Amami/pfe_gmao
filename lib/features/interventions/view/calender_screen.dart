import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pfe_gmao/features/Equipments/model/data_models/discipline_list.dart';
import 'package:pfe_gmao/features/interventions/model/data_models/intervention.dart';
import 'package:pfe_gmao/features/interventions/view/intervention_file_view.dart';
import 'package:pfe_gmao/features/interventions/view/widget/intervention_card.dart';
import 'package:pfe_gmao/features/work_order/view/add_work_order_view.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWorkOrderView(
              equipmentTagName: "TEST Tag Name",
              equipmentDiscipline: disciplineValueList[0],
              interventionTask: "Test Task",
              isElectrical: true,
              isInstrument: true,
              isMechanical: true,
              spareParts: const [
                "test spare part",
                "test spare part",
                "test spare part"
              ],
              tools: const [
                "test tools",
                "test tools",
                "test tools",
              ],
            ),
          ),
        ),
        label: const Text("Word Order"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
          child: Column(
            children: [
              TableCalendar(
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
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
                        return Column(
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      foregroundColor: Colors.white,
                                      autoClose: true,
                                      label: 'Add Work Order',
                                      icon: Icons.add,
                                      borderRadius: BorderRadius.circular(13),
                                      backgroundColor: Colors.red.shade700,
                                      onPressed: (context) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddWorkOrderView(
                                            equipmentTagName: "TEST Tag Name",
                                            equipmentDiscipline:
                                                disciplineValueList[0],
                                            interventionTask: "Test Task",
                                            isElectrical: true,
                                            isInstrument: true,
                                            isMechanical: true,
                                            spareParts: const [
                                              "test spare part",
                                              "test spare part",
                                              "test spare part"
                                            ],
                                            tools: const [
                                              "test tools",
                                              "test tools",
                                              "test tools",
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InterventionViewPage(
                                      interventionFileDiscipline:
                                          interventions[index]
                                              .equipmentDiscipline,
                                      interventionFileID: interventions[index]
                                          .interventionFileID,
                                      interventionType:
                                          interventions[index].interventionType,
                                    ),
                                  ),
                                ),
                                child: CalendarCard(
                                  title: (index + 1).toString(),
                                  subtitle:
                                      interventions[index].interventionType,
                                  date: interventions[index].interventionDate,
                                  typeOfCard: 'intervention',
                                  status:
                                      interventions[index].interventionStatus,
                                  equipmentName:
                                      interventions[index].equipmentTagName,
                                ),
                              ),
                            ),
                            //   Card(
                            //     color: Colors.red[100],
                            //     child: ListTile(
                            //       title: Text(
                            //         interventions[index].equipmentTagName,
                            //       ),
                            //       subtitle: Text(
                            //           interventions[index].interventionType),
                            //       leading: const Icon(Icons.file_copy),
                            //     ),
                            //   ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
