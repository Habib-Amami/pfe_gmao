import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pfe_gmao/features/Equipments/model/data_models/discipline_list.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../profile_management/model/user.dart';
import 'widgets/work_order_form_fiel.dart';
import 'widgets/work_order_form_title.dart';

class AddWorkOrderView extends StatefulWidget {
  final String equipmentTagName;
  final String equipmentDiscipline;
  final String interventionTask;
  final bool isMechanical;
  final bool isElectrical;
  final bool isInstrument;
  final List<String> tools;
  final List<String> spareParts;

  const AddWorkOrderView({
    super.key,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.interventionTask,
    required this.isMechanical,
    required this.isElectrical,
    required this.isInstrument,
    required this.tools,
    required this.spareParts,
  });

  @override
  State<AddWorkOrderView> createState() => _AddWorkOrderViewState();
}

class _AddWorkOrderViewState extends State<AddWorkOrderView> {
  // Form key for managing the state of the intervention file form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //variable for the execution date
  DateTime? executionDate;
  // Controller for the execution date field
  final TextEditingController _executionDateController =
      TextEditingController();

  //variables for the Starting time hour and minute start day picker
  int startingHour = DateTime.now().hour;
  int startingMinute = DateTime.now().minute;

  //variables for the Finishing time hour and minute start day picker
  int finishingHour = DateTime.now().hour;
  int finishingMinute = DateTime.now().minute;

  // Controller for the steps  field
  final TextEditingController _stepsController = TextEditingController();
  //List of the intervention steps
  List<String> stepsList = [];
  //list of the discipline needed for this intervention
  List<String> engineersDisciplineList = [];

  //list of engineers from the selected discipline
  List<UserModel> engineersList = [];
  //Mechanics engineers
  List<UserModel> mechanicsEnginners = [];
  //Electrics engineers
  List<UserModel> electricsEngineers = [];
  //Instrumental engineers
  List<UserModel> instrumentalEngineers = [];

  //methode to fetch engineers data based on the selected disciplines
  //for the interventions
  Future<List<UserModel>> getEngineersDate({
    required List<String> engineersDiscipline,
  }) async {
    List<UserModel> engineersList = [];
    await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .where('role', isEqualTo: 'Engineer')
        .where(
          'discipline',
          whereIn: engineersDiscipline,
        )
        .get()
        .then(
      (snapshot) {
        engineersList = snapshot.docs
            .map(
              (doc) => UserModel.fromFirestore(doc, null),
            )
            .toList();
      },
    );
    return engineersList;
  }

  void fetchEngineersData({
    required List<String> engineersDiscipline,
  }) async {
    engineersList = await getEngineersDate(
      engineersDiscipline: engineersDisciplineList,
    );
    if (kDebugMode) {
      print('All Engineers:');
      print(engineersList);
    }
    mechanicsEnginners = engineersList
        .where((engineer) => engineer.discipline == disciplineValueList[0])
        .toList();
    if (kDebugMode) {
      print('Mechanical Engineers:');
      print(mechanicsEnginners);
    }
    electricsEngineers = engineersList
        .where((engineer) => engineer.discipline == disciplineValueList[1])
        .toList();
    if (kDebugMode) {
      print('Electrical Engineers:');
      print(electricsEngineers);
    }
    instrumentalEngineers = engineersList
        .where((engineer) => engineer.discipline == disciplineValueList[2])
        .toList();
    if (kDebugMode) {
      print('Instrumental Engineers:');
      print(instrumentalEngineers);
    }
    setState(() {});
  }

  @override
  void initState() {
    if (widget.isMechanical) {
      engineersDisciplineList.add('Mechanics');
    }
    if (widget.isElectrical) {
      engineersDisciplineList.add('Electrics');
    }
    if (widget.isInstrument) {
      engineersDisciplineList.add('Instrumental');
    }
    fetchEngineersData(
      engineersDiscipline: engineersDisciplineList,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Add a Work Order"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WorkOrderFormTitle(
                    title: "Tag Name",
                  ),
                  WorkOrderFormField(
                    initialValue: widget.equipmentTagName,
                    readOnly: true,
                  ),
                  const WorkOrderFormTitle(
                    title: "Discipline",
                  ),
                  WorkOrderFormField(
                    initialValue: widget.equipmentDiscipline,
                    readOnly: true,
                  ),
                  if (mechanicsEnginners.isNotEmpty)
                    Column(
                      children: [
                        const WorkOrderFormTitle(
                          title: "Mechanical Technician",
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ListView.builder(
                            itemCount: mechanicsEnginners.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      mechanicsEnginners[index].photoURL),
                                ),
                                title: Text(mechanicsEnginners[index].userName),
                                subtitle: Text(mechanicsEnginners[index].email),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.isElectrical)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WorkOrderFormTitle(
                          title: "Electrical Technician",
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ListView.builder(
                            itemCount: electricsEngineers.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      electricsEngineers[index].photoURL),
                                ),
                                title: Text(electricsEngineers[index].userName),
                                subtitle: Text(electricsEngineers[index].email),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.isInstrument)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WorkOrderFormTitle(
                          title: "Instrument Technician",
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ListView.builder(
                            itemCount: instrumentalEngineers.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      instrumentalEngineers[index].photoURL),
                                ),
                                title:
                                    Text(instrumentalEngineers[index].userName),
                                subtitle:
                                    Text(instrumentalEngineers[index].email),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const WorkOrderFormTitle(
                    title: "Execution Date",
                  ),
                  Row(
                    children: [
                      // Expanded widget to ensure the text field takes up most of the row
                      Expanded(
                        flex: 4,
                        child: WorkOrderFormField(
                          controller: _executionDateController,
                          readOnly: true,
                          hintText: "Pick a date from the calender",
                          prefixIcon: const Icon(Icons.timelapse_rounded),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "please provide a starting day";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      // Expanded widget to ensure the icon button takes up the remaining space
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            bottom: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              IconButton.filledTonal(
                                tooltip:
                                    "press to select a day from the calender",
                                onPressed: () async {
                                  // Show date picker dialog
                                  executionDate = await showDatePicker(
                                    context: context,
                                    barrierDismissible: false,
                                    currentDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(
                                      DateTime.now().year, //year
                                      12, // month
                                      31, // day
                                    ),
                                    helpText:
                                        "Pick a the starting day for the intervrntion",
                                    errorFormatText:
                                        "Follow the mm/dd/yyyy format please",
                                  );
                                  // Update text field value if a date is selected
                                  if (executionDate != null) {
                                    setState(() {
                                      _executionDateController.text =
                                          DateFormat(
                                        "dd/MM/yyyy",
                                      ).format(
                                        executionDate!,
                                      );
                                    });
                                  }
                                },
                                // Icon displayed on the button
                                icon: const Icon(
                                  Icons.edit_calendar_rounded,
                                ),
                              ),
                              Text(
                                "Pick",
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const WorkOrderFormTitle(
                    title: "Starting Time",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NumberPicker(
                              infiniteLoop: true,
                              axis: Axis.vertical,
                              haptics: true,
                              zeroPad: true,
                              itemCount: 1,
                              minValue: 0,
                              maxValue: 23,
                              itemWidth: 96,
                              itemHeight: 72,
                              value: startingHour,
                              onChanged: (value) {
                                setState(() {
                                  startingHour = value;
                                });
                              },
                              selectedTextStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                            ),
                            const Text("Hour")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            ":",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NumberPicker(
                              infiniteLoop: true,
                              axis: Axis.vertical,
                              haptics: true,
                              zeroPad: true,
                              itemCount: 1,
                              minValue: 0,
                              maxValue: 59,
                              itemWidth: 96,
                              itemHeight: 72,
                              value: startingMinute,
                              onChanged: (value) {
                                setState(() {
                                  startingMinute = value;
                                });
                              },
                              selectedTextStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                            ),
                            const Text("Minute")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: IconButton.filledTonal(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                barrierDismissible: false,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  startingHour = pickedTime.hour;
                                  startingMinute = pickedTime.minute;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.timer_outlined,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const WorkOrderFormTitle(
                    title: "Finishing Time",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NumberPicker(
                              infiniteLoop: true,
                              axis: Axis.vertical,
                              haptics: true,
                              zeroPad: true,
                              itemCount: 1,
                              minValue: 0,
                              maxValue: 23,
                              itemWidth: 96,
                              itemHeight: 72,
                              value: finishingHour,
                              onChanged: (value) {
                                setState(() {
                                  finishingHour = value;
                                });
                              },
                              selectedTextStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                            ),
                            const Text("Hour")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            ":",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NumberPicker(
                              infiniteLoop: true,
                              axis: Axis.vertical,
                              haptics: true,
                              zeroPad: true,
                              itemCount: 1,
                              minValue: 0,
                              maxValue: 59,
                              itemWidth: 96,
                              itemHeight: 72,
                              value: finishingMinute,
                              onChanged: (value) {
                                setState(() {
                                  finishingMinute = value;
                                });
                              },
                              selectedTextStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ),
                            ),
                            const Text("Minute")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: IconButton.filledTonal(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                barrierDismissible: false,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  finishingHour = pickedTime.hour;
                                  finishingMinute = pickedTime.minute;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.timer_outlined,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const WorkOrderFormTitle(
                    title: "Intervention Task",
                  ),
                  WorkOrderFormField(
                    initialValue: widget.interventionTask,
                    readOnly: true,
                  ),
                  const WorkOrderFormTitle(
                    title: "Intervention Steps",
                  ),
                  Row(
                    children: [
                      // Expanded widget to ensure the text field takes up most of the row
                      Expanded(
                        flex: 4,
                        child: WorkOrderFormField(
                          controller: _stepsController,
                          hintText: "create a small step",
                          prefixIcon: const Icon(Icons.task_outlined),
                        ),
                      ),
                      // Expanded widget to ensure the icon button takes up the remaining space
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            bottom: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              IconButton.filledTonal(
                                tooltip:
                                    "Press to add a step to the steps list",
                                onPressed: () {
                                  setState(() {
                                    stepsList.add(_stepsController.text);
                                  });
                                },
                                // Icon displayed on the button
                                icon: const Icon(
                                  Icons.add_task_outlined,
                                ),
                              ),
                              Text(
                                "Add",
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if (stepsList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        children: List.generate(
                          stepsList.length,
                          (index) => Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text((index + 1).toString()),
                              ),
                              title: Text(stepsList[index]),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    stepsList.remove(stepsList[index]);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const WorkOrderFormTitle(
                    title: "Spare Parts",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: List.generate(
                        widget.spareParts.length,
                        (index) => Card(
                          child: ListTile(
                            title: Text(
                              widget.spareParts[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const WorkOrderFormTitle(
                    title: "Tools",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: List.generate(
                        widget.tools.length,
                        (index) => Card(
                          child: ListTile(
                            title: Text(
                              widget.tools[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// List<UserModel> enginnersList = snapshot.data!.docs
//               .map(
//                 (doc) => UserModel.fromFirestore(doc, null),
//               )
//               .toList();

// FirebaseFirestore.instance
//             .collection(userCollectionRef)
//             .where('role', isEqualTo: 'Engineer')
//             .where(
//               'discipline',
//               whereIn: engineersDisciplineList,
//             )
//             .get(),
