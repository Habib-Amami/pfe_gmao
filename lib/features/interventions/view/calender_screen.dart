import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pfe_gmao/features/profile_management/model/user.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../work_order/view/add_work_order_view.dart';
import '../model/data_models/intervention.dart';
import 'intervention_file_view.dart';
import 'widget/intervention_card.dart';

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

  late UserModel user;

  //methode to fetch the admin data
  Future<bool> adminCheck() async {
    await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (snapshot) {
        user = UserModel.fromFirestore(snapshot, null);
      },
    );
    // ignore: unrelated_type_equality_checks
    return user.role == Roles.Administrator.toShortString();
  }

  void fecthUserRole() async {
    isAdmin = await adminCheck();
  }

  // to change the calender format
  CalendarFormat _calendarFormat = CalendarFormat.month;

  bool isAdmin = false;
  @override
  void initState() {
    fecthUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.6),
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
                            Text("Loading Interventions ...")
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
                            isAdmin
                                ? Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          foregroundColor: Colors.white,
                                          autoClose: true,
                                          label: 'Add Work Order',
                                          icon: Icons.work_history,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          onPressed: (context) =>
                                              Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddWorkOrderView(
                                                equipmentTagName:
                                                    interventions[index]
                                                        .equipmentTagName,
                                                equipmentDiscipline:
                                                    interventions[index]
                                                        .equipmentDiscipline,
                                                interventionID:
                                                    interventions[index]
                                                        .interventionID,
                                                interventionType:
                                                    interventions[index]
                                                        .interventionType,
                                                interventionFileID:
                                                    interventions[index]
                                                        .interventionFileID,
                                                interventionTask:
                                                    interventions[index]
                                                        .interventionTask,
                                                executionDate:
                                                    interventions[index]
                                                        .interventionDate
                                                        .toIso8601String()
                                                        .split("T")
                                                        .first,
                                                isMechanical:
                                                    interventions[index]
                                                        .mechanicalTechnician,
                                                isElectrical:
                                                    interventions[index]
                                                        .electricalTechnician,
                                                isInstrument:
                                                    interventions[index]
                                                        .instrumentTechnician,
                                                spareParts: interventions[index]
                                                    .spareParts,
                                                tools:
                                                    interventions[index].tools,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InterventionViewPage(
                                            interventionFileDiscipline:
                                                interventions[index]
                                                    .equipmentDiscipline,
                                            interventionFileID:
                                                interventions[index]
                                                    .interventionFileID,
                                            interventionType:
                                                interventions[index]
                                                    .interventionType,
                                          ),
                                        ),
                                      ),
                                      child: CalendarCard(
                                        title: (index + 1).toString(),
                                        subtitle: interventions[index]
                                            .interventionType,
                                        date: interventions[index]
                                            .interventionDate,
                                        typeOfCard: 'intervention',
                                        status: interventions[index]
                                            .interventionStatus,
                                        equipmentName: interventions[index]
                                            .equipmentTagName,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InterventionViewPage(
                                          interventionFileDiscipline:
                                              interventions[index]
                                                  .equipmentDiscipline,
                                          interventionFileID:
                                              interventions[index]
                                                  .interventionFileID,
                                          interventionType: interventions[index]
                                              .interventionType,
                                        ),
                                      ),
                                    ),
                                    child: CalendarCard(
                                      title: (index + 1).toString(),
                                      subtitle:
                                          interventions[index].interventionType,
                                      date:
                                          interventions[index].interventionDate,
                                      typeOfCard: 'intervention',
                                      status: interventions[index]
                                          .interventionStatus,
                                      equipmentName:
                                          interventions[index].equipmentTagName,
                                    ),
                                  ),
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
