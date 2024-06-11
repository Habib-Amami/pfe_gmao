import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../notifications/controller/notification_controller.dart';
import '../../notifications/model/notification_model.dart';
import '../../profile_management/model/user.dart';
import '../controller/work_order_controller.dart';
import '../model/constants/work_order_status.dart';
import 'widgets/timer.dart';
import 'widgets/work_order_form_field.dart';
import 'widgets/work_order_form_title.dart';

class AddWorkOrderView extends StatefulWidget {
  final String equipmentTagName;
  final String equipmentDiscipline;
  final String interventionID;
  final String interventionType;
  final String interventionTask;
  final String interventionFileID;
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
    required this.interventionID,
    required this.interventionType,
    required this.interventionTask,
    required this.interventionFileID,
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
  //work order controller
  WorkorderController controller = WorkorderController();

  //Notification controller
  NotificationController notificationController = NotificationController();

  //ADMINISTRATOR INFORMATION
  late UserModel admin;
  //variable for the execution date
  DateTime? executionDate;
  // Controller for the execution date field
  final TextEditingController _executionDateController =
      TextEditingController();

  //Controller for the execution starting hour time field
  final TextEditingController _startingHourController = TextEditingController();
  //Controller for the execution starting minute time field
  final TextEditingController _startingMinuteController =
      TextEditingController();

  //Controller for the execution finishing hour time field
  final TextEditingController _finshingHourController = TextEditingController();
  //Controller for the execution finshing minute time field
  final TextEditingController _finshingMinuteController =
      TextEditingController();

  // Controller for the steps  field
  final TextEditingController _stepsController = TextEditingController();
  //List of the intervention steps
  List<String> stepsList = [];

  //list of the discipline needed for this intervention
  List<String> engineersDisciplineList = [];

  //list of engineers from the selected discipline
  List<UserModel> engineersList = [];
  //Filtered engineers list
  List<UserModel> filterEngineersList = [];
  //Selected enginner
  UserModel? selectedEngineer;

  //methode to fetch the admin data
  Future<UserModel> getAdminDate() async {
    await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (snapshot) {
        admin = UserModel.fromFirestore(snapshot, null);
      },
    );
    return admin;
  }

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

  void fetchData({
    required List<String> engineersDiscipline,
  }) async {
    engineersList = await getEngineersDate(
      engineersDiscipline: engineersDisciplineList,
    );
    if (kDebugMode) {
      print('All Engineers:');
      print(engineersList);
    }
    admin = await getAdminDate();
    if (kDebugMode) {
      print('All Engineers:');
      print(engineersList);
      print('Admin');
      print(admin);
    }
    setState(() {
      filterEngineersList = [...engineersList];
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
    fetchData(
      engineersDiscipline: engineersDisciplineList,
    );

    _executionDateController.text = widget.executionDate;
    _startingHourController.text =
        TimeOfDay.now().hour.toString().padLeft(2, '0');
    _startingMinuteController.text =
        TimeOfDay.now().minute.toString().padLeft(2, '0');
    _finshingHourController.text =
        TimeOfDay.now().hour.toString().padLeft(2, '0');
    _finshingMinuteController.text =
        TimeOfDay.now().minute.toString().padLeft(2, '0');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _executionDateController.dispose();
    _startingHourController.dispose();
    _startingMinuteController.dispose();
    _finshingHourController.dispose();
    _finshingMinuteController.dispose();
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
              const WorkOrderFormTitle(
                title: "Technician",
              ),
              WorkOrderFormField(
                hintText: "Search for a mechanical engineer",
                prefixIcon: const Icon(Icons.build),
                onChanged: (keyword) => filterEngineers(
                  enteredKeyword: keyword,
                  allEngineersList: engineersList,
                  filteredList: filterEngineersList,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: ListView.builder(
                    itemCount: filterEngineersList.length,
                    itemBuilder: (context, index) => Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            filterEngineersList[index].photoURL,
                          ),
                        ),
                        title: Text(
                          filterEngineersList[index].userName,
                        ),
                        subtitle: Text(
                          filterEngineersList[index].email,
                        ),
                        trailing: Radio<UserModel>(
                          value: filterEngineersList[index],
                          groupValue: selectedEngineer,
                          onChanged: (value) {
                            setState(() {
                              selectedEngineer = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
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
                            tooltip: "press to select a day from the calender",
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
                                    "yyyy-dd-MM",
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
              Timer(
                hourController: _startingHourController,
                minuteController: _startingMinuteController,
              ),
              const WorkOrderFormTitle(
                title: "Finishing Time",
              ),
              Timer(
                hourController: _finshingHourController,
                minuteController: _finshingMinuteController,
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
                      hintText: "create a step",
                      prefixIcon: const Icon(Icons.task_outlined),
                      textInputAction: TextInputAction.done,
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a appropriate step to the task!',
                                    ),
                                  ),
                                );
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
                  child: FilledButton(
                    onPressed: () {
                      //Calculating the starting time in hours
                      double startingTime =
                          int.parse(_startingHourController.text) +
                              int.parse(_startingMinuteController.text) / 60;

                      double finishingTime =
                          int.parse(_finshingHourController.text) +
                              int.parse(_finshingMinuteController.text) / 60;

                      if (selectedEngineer == null ||
                          startingTime >= finishingTime ||
                          stepsList.isEmpty) {
                        //Content of the snacack bar
                        String snackBarContent = "";
                        //check if the user selected a Technician for the work order
                        if (selectedEngineer == null) {
                          snackBarContent = "- Please selecetd a technician\n";
                        }
                        //check if teh starting time is earlier then the finishing time

                        if (startingTime >= finishingTime) {
                          // ignore: prefer_interpolation_to_compose_strings
                          snackBarContent = snackBarContent +
                              "- Please ensure the start time is before the finish time\n";
                        }
                        //check if the user provided steps for the work order
                        if (stepsList.isEmpty) {
                          // ignore: prefer_interpolation_to_compose_strings
                          snackBarContent = snackBarContent +
                              "- Please provide steps for the work order\n";
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(snackBarContent),
                          ),
                        );
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () async {
                                          //generating a work order id
                                          String orderID = const Uuid().v4();
                                          //adding work order to database
                                          await controller.addWorkOrder(
                                            workorderID: orderID,
                                            workorderStatus: workOrderStatus[0],
                                            workorderCreatorID: admin.id,
                                            workorderCreatorUserName:
                                                admin.userName,
                                            workorderCreatorToken:
                                                admin.FCMtoken,
                                            interventionID:
                                                widget.interventionID,
                                            interventionType:
                                                widget.interventionType,
                                            interventionFileID:
                                                widget.interventionFileID,
                                            equipmentTagName:
                                                widget.equipmentTagName,
                                            equipmentDiscipline:
                                                widget.equipmentDiscipline,
                                            technicianID: selectedEngineer!.id,
                                            technicianUserName:
                                                selectedEngineer!.userName,
                                            technicianToken:
                                                selectedEngineer!.FCMtoken,
                                            steps: stepsList,
                                            tools: widget.tools,
                                            spareParts: widget.spareParts,
                                            executionDay: DateTime.parse(
                                                _executionDateController.text),
                                            startTime: TimeOfDay(
                                              hour: int.parse(
                                                  _startingHourController.text),
                                              minute: int.parse(
                                                  _startingMinuteController
                                                      .text),
                                            ),
                                            finishTime: TimeOfDay(
                                              hour: int.parse(
                                                  _finshingHourController.text),
                                              minute: int.parse(
                                                  _finshingMinuteController
                                                      .text),
                                            ),
                                          );
                                          //generating a notification id
                                          String notificationID =
                                              const Uuid().v4();
                                          //adding notification about the new work order in the technician doc
                                          notificationController
                                              .sendDispatchWorkorderNotification(
                                            interventionID:
                                                widget.interventionID,
                                            notificationID: notificationID,
                                            notificationTitle:
                                                "New Work Order Assigned",
                                            notificationBody:
                                                "You have been assigned a new work order for ${widget.equipmentTagName}.",
                                            workorderCreatorID: admin.id,
                                            technicianID: selectedEngineer!.id,
                                            workOrderID: orderID,
                                          );
                                          //sending a push notification
                                          NotificationsModel()
                                              .sendNotificationToDevice(
                                            deviceToken:
                                                selectedEngineer!.FCMtoken,
                                            notificationTitle: "New Work Order",
                                            notificationBody:
                                                "you have a new work order for ${widget.equipmentTagName}",
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Work Order Created successfully",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
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
    );
  }
}
