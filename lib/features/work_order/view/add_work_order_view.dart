import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../Equipments/model/data_models/discipline_list.dart';
import '../../profile_management/model/user.dart';
import 'widgets/work_order_form_fiel.dart';
import 'widgets/work_order_form_title.dart';

class AddWorkOrderView extends StatefulWidget {
  final String equipmentTagName;
  final String equipmentDiscipline;
  final String interventionTask;
  final String executionDate;
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
    required this.executionDate,
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
  //Filtered mechanics engineers
  List<UserModel> filteredMechanicsEnginners = [];
  //selected mechanical engineer
  UserModel? selectedMechanicalEngineer;

  //Electrics engineers
  List<UserModel> electricsEngineers = [];
  //Filtered electrics engineers
  List<UserModel> filteredElectricsEnginners = [];
  //selected electrical
  UserModel? selectedElectricalEngineer;

  //Instrumental engineers
  List<UserModel> instrumentalEngineers = [];
  //Filtered instrumental engineers
  List<UserModel> filteredInstrumentalEnginners = [];
  //selected instrumental engineer
  UserModel? selectedInstrumentalEngineer;

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
    setState(() {
      filteredMechanicsEnginners = [...mechanicsEnginners];
      filteredElectricsEnginners = [...electricsEngineers];
      filteredInstrumentalEnginners = [...instrumentalEngineers];
    });
  }

  // Function to filter engineers based on the entered keyword
  void filterEngineers({
    required String enteredKeyword,
    required List<UserModel> allEngineersList,
    required List<UserModel> filteredList,
  }) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        filteredList.clear();
        filteredList.addAll(allEngineersList);
      });
    } else {
      setState(() {
        filteredList.clear();
        filteredList.addAll(
          allEngineersList.where(
            (engineer) => engineer.userName
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()),
          ),
        );
      });
    }
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

    _executionDateController.text = widget.executionDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconData disciplineIconData;
    // Switch statement to determine the icon discipline filed based on equipment status
    switch (widget.equipmentDiscipline.toLowerCase()) {
      case 'mechanics':
        disciplineIconData = Icons.build;
        break;
      case 'electrics':
        disciplineIconData = Icons.flash_on;
        break;
      case 'instrumental':
        disciplineIconData = Icons.design_services;

        break;
      default:
        disciplineIconData = Icons.error_outline;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Add a Work Order",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
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
                  prefixIcon: const Icon(Icons.local_offer_outlined),
                  initialValue: widget.equipmentTagName,
                  readOnly: true,
                ),
                const WorkOrderFormTitle(
                  title: "Discipline",
                ),
                WorkOrderFormField(
                  prefixIcon: Icon(disciplineIconData),
                  initialValue: widget.equipmentDiscipline,
                  readOnly: true,
                ),
                if (widget.isMechanical)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WorkOrderFormTitle(
                        title: "Mechanical Technician",
                      ),
                      WorkOrderFormField(
                        hintText: "Search for a mechanical engineer",
                        prefixIcon: const Icon(Icons.build),
                        onChanged: (keyword) => filterEngineers(
                          enteredKeyword: keyword,
                          allEngineersList: mechanicsEnginners,
                          filteredList: filteredMechanicsEnginners,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: ListView.builder(
                            itemCount: filteredMechanicsEnginners.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    filteredMechanicsEnginners[index].photoURL,
                                  ),
                                ),
                                title: Text(
                                  filteredMechanicsEnginners[index].userName,
                                ),
                                subtitle: Text(
                                  filteredMechanicsEnginners[index].email,
                                ),
                                trailing: Radio<UserModel>(
                                  value: filteredMechanicsEnginners[index],
                                  groupValue: selectedMechanicalEngineer,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMechanicalEngineer = value!;
                                    });
                                  },
                                ),
                              ),
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
                      WorkOrderFormField(
                        hintText: "Search for a electrical engineer",
                        prefixIcon: const Icon(Icons.flash_on),
                        onChanged: (keyword) {
                          filterEngineers(
                            enteredKeyword: keyword,
                            allEngineersList: electricsEngineers,
                            filteredList: filteredElectricsEnginners,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: ListView.builder(
                            itemCount: filteredElectricsEnginners.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    filteredElectricsEnginners[index].photoURL,
                                  ),
                                ),
                                title: Text(
                                  filteredElectricsEnginners[index].userName,
                                ),
                                subtitle: Text(
                                  filteredElectricsEnginners[index].email,
                                ),
                                trailing: Radio<UserModel>(
                                  value: filteredElectricsEnginners[index],
                                  groupValue: selectedElectricalEngineer,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedElectricalEngineer = value!;
                                    });
                                  },
                                ),
                              ),
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
                      WorkOrderFormField(
                        hintText: "Search for a instrument engineer",
                        prefixIcon: const Icon(Icons.design_services),
                        onChanged: (keyword) {
                          filterEngineers(
                            enteredKeyword: keyword,
                            allEngineersList: instrumentalEngineers,
                            filteredList: filteredInstrumentalEnginners,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: ListView.builder(
                            itemCount: filteredInstrumentalEnginners.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    filteredInstrumentalEnginners[index]
                                        .photoURL,
                                  ),
                                ),
                                title: Text(
                                  filteredInstrumentalEnginners[index].userName,
                                ),
                                subtitle: Text(
                                  filteredInstrumentalEnginners[index].email,
                                ),
                                trailing: Radio<UserModel>(
                                  value: filteredInstrumentalEnginners[index],
                                  groupValue: selectedInstrumentalEngineer,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedInstrumentalEngineer = value!;
                                    });
                                  },
                                ),
                              ),
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
                                    _executionDateController.text = DateFormat(
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
                        suffexIcon: IconButton(
                          focusColor: Theme.of(context).colorScheme.primary,
                          icon: const Icon(
                            Ionicons.close_circle,
                          ),
                          onPressed: () => _stepsController.clear(),
                        ),
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
                              tooltip: "Press to add a step to the steps list",
                              onPressed: () {
                                if (_stepsController.text.isEmpty ||
                                    _stepsController.text.length <= 2) {
                                  const snackBar = SnackBar(
                                    content: Center(
                                      child: Text(
                                          'Please enter a appropriate step to the task!'),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    stepsList.add(_stepsController.text);
                                  });
                                }
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
                                  color: Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (stepsList.isEmpty) {
                          const snackBar = SnackBar(
                              content: Center(
                                  child: Text(
                                      'please provide steps to the task')));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (startingHour >= finishingHour) {
                          const snackBar = SnackBar(
                            content: Center(
                                child: Text(
                                    'Finishing hour must be grater than starting hour')),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to create this work order?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Confirm',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      child: const Text('Create Work Order'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
