import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/constants/work_order_status.dart';
import '../../model/data_models/work_order.dart';
import '../../model/work_order_model.dart';
import '../widgets/work_order_action_buttons/engineer/finished_view.dart';
import '../widgets/work_order_action_buttons/engineer/in_progress_view.dart';
import '../widgets/work_order_action_buttons/engineer/stand_by_view.dart';
import '../widgets/work_order_action_buttons/engineer/terminated_view.dart';
import '../widgets/work_order_form_field.dart';
import '../widgets/work_order_form_title.dart';

class EngineerWorkOrderView extends StatefulWidget {
  const EngineerWorkOrderView({
    super.key,
    required this.workOrderID,
    required this.interventionId,
  });
  final String interventionId;
  final String workOrderID;

  @override
  State<EngineerWorkOrderView> createState() => _EngineerWorkOrderViewState();
}

class _EngineerWorkOrderViewState extends State<EngineerWorkOrderView> {
  // Form key for managing the state of the stand by reason  update form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // Variables to store stand by reason
  String standByReason = "";

  List<ValueNotifier<bool>> _isCheckedList = [];
  int numberOfChecked = 0;
  bool? isChecked = false;

// work order information query
  Future<WorkOrder> fetchWorkOrderDetails(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('work_order')
        .doc(id)
        .get();
    if (doc.exists) {
      return WorkOrder.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Work Order not found');
    }
  }

  // format time of day to string
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'Work order information',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchWorkOrderDetails(widget.workOrderID),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading Intervention File ...")
                ],
              ),
            );
          }
          // Show error message if an error occurs
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          }
          WorkOrder wo = snapshot.data!;

          if (_isCheckedList.isEmpty) {
            _isCheckedList = List<ValueNotifier<bool>>.generate(
              wo.steps.length,
              (_) => ValueNotifier<bool>(false),
            );
          }
          return ListView(
            children: [
              SingleChildScrollView(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // information
                        const WorkOrderFormTitle(title: "Equipment Tag name"),
                        WorkOrderFormField(
                          readOnly: true,
                          prefixIcon: const Icon(
                            Icons.local_offer_outlined,
                          ),
                          initialValue: wo.equipmentTagName,
                        ),
                        // information
                        const WorkOrderFormTitle(title: "Discipline"),
                        WorkOrderFormField(
                          readOnly: true,
                          prefixIcon: const Icon(
                            Icons.construction_rounded,
                          ),
                          initialValue: wo.equipmentDiscipline,
                        ),
                        // the rest of work order info
                        const WorkOrderFormTitle(title: 'Execution Date'),
                        WorkOrderFormField(
                          readOnly: true,
                          prefixIcon: const Icon(
                            Icons.calendar_month_outlined,
                          ),
                          initialValue: wo.executionDay
                              .toIso8601String()
                              .split('T')
                              .first,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const WorkOrderFormTitle(
                                  title: 'Starting Time',
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: WorkOrderFormField(
                                    readOnly: true,
                                    prefixIcon: const Icon(Icons.timer),
                                    initialValue: formatTimeOfDay(wo.startTime),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const WorkOrderFormTitle(
                                  title: 'Finishing Time',
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: WorkOrderFormField(
                                    readOnly: true,
                                    prefixIcon: const Icon(Icons.timer_off),
                                    initialValue:
                                        formatTimeOfDay(wo.finishTime),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //Steps
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // steps
                            const WorkOrderFormTitle(
                              title: 'Intervention Steps',
                            ),
                            // ignore: unused_local_variable
                            for (int i = 0; i < wo.steps.length; i++)
                              Padding(
                                padding: i == wo.steps.length - 1
                                    ? const EdgeInsets.only(bottom: 16.0)
                                    : const EdgeInsets.only(bottom: 0),
                                child: Card(
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${i + 1}- ${wo.steps[i]}'),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _isCheckedList[i],
                                          builder: (context, isChecked, _) {
                                            return Checkbox(
                                              value: isChecked,
                                              onChanged: (value) {
                                                _isCheckedList[i].value =
                                                    value!;
                                                numberOfChecked = _isCheckedList
                                                    .where((notifier) =>
                                                        notifier.value)
                                                    .length;
                                              },
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    titleTextStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ),
                              ),
                            // spare parts
                            const WorkOrderFormTitle(title: 'Spare Parts'),
                            for (var item in wo.spareParts)
                              Padding(
                                padding: item == wo.spareParts.last
                                    ? const EdgeInsets.only(bottom: 16.0)
                                    : const EdgeInsets.only(bottom: 0),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      '- $item',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),

                            // tools
                            const WorkOrderFormTitle(title: 'Tools'),
                            for (var item in wo.tools)
                              Padding(
                                padding: item == wo.tools.last
                                    ? const EdgeInsets.only(bottom: 16.0)
                                    : const EdgeInsets.only(bottom: 0),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      '- $item',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            //Row of button that depends on the state of the work order
                            // Status handling
                            //
                            //If the work order is In Progress
                            wo.workorderStatus == workOrderStatus[0]
                                ? InProgressView(
                                    onFinished: () {
                                      //if all the steps were not checked
                                      if (numberOfChecked < wo.steps.length) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Center(
                                              child: Text(
                                                'Please make sure that all the steps are done !',
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        //if all steps are checked
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: const Text(
                                              "Are you sure you want to finalize this work order ?",
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceAround,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  //Updating the work order state to
                                                  //'Finished'
                                                  WorkOrderModel()
                                                      .updateWorkOrderStatus(
                                                    workOrderID: wo.workorderID,
                                                    //'Finished'
                                                    newStatus:
                                                        workOrderStatus[2],
                                                    creatorID:
                                                        wo.workorderCreatorID,
                                                    technicianID:
                                                        wo.technicianID,
                                                    interventionID:
                                                        wo.interventionID,
                                                  );
                                                  //sending a push notification
                                                  NotificationsModel()
                                                      .sendNotificationToDevice(
                                                    deviceToken: wo
                                                        .workorderCreatorToken,
                                                    notificationTitle:
                                                        "Work Order Validation Request",
                                                    notificationBody:
                                                        "A work order for ${wo.equipmentTagName} requires your validation",
                                                  );
                                                  //creating a notification id
                                                  String notificationID =
                                                      const Uuid().v4();
                                                  //adding a notification to the admin who created the work order
                                                  //to request validation
                                                  NotificationsModel()
                                                      .sendWorkorderValidationRequestorStandByNotification(
                                                    notificationID:
                                                        notificationID,
                                                    notificationTitle:
                                                        "Work Order validation Request",
                                                    notificationBody:
                                                        "A work order for ${wo.equipmentTagName} requires your validation",
                                                    workorderCreatorID:
                                                        wo.workorderCreatorID,
                                                    technicianID:
                                                        wo.technicianID,
                                                    workOrderID: wo.workorderID,
                                                    interventionID:
                                                        wo.interventionID,
                                                  );
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text("Finalize"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    onStrandBy: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Confirmation',
                                            ),
                                            content: SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  7,
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0),
                                                    child: Text(
                                                      'Are you sure you want to put this work order on stand by?',
                                                    ),
                                                  ),
                                                  Form(
                                                    key: _formkey,
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "Provide a reason",
                                                        prefixIcon: Icon(
                                                          Icons
                                                              .mode_standby_rounded,
                                                        ),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "please provide your reason";
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (newEmail) =>
                                                          standByReason =
                                                              newEmail!.trim(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceAround,
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                ),
                                                child: const Text(
                                                  "Cancel",
                                                ),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    _formkey.currentState!
                                                        .save();

                                                    //update the work order state to
                                                    //'Stand By'
                                                    WorkOrderModel()
                                                        .updateWorkOrderStatus(
                                                      workOrderID:
                                                          wo.workorderID,
                                                      //'Finished'
                                                      newStatus:
                                                          workOrderStatus[1],
                                                      creatorID:
                                                          wo.workorderCreatorID,
                                                      technicianID:
                                                          wo.technicianID,
                                                      interventionID:
                                                          wo.interventionID,
                                                    );
                                                    //seding a push notification
                                                    NotificationsModel()
                                                        .sendNotificationToDevice(
                                                      deviceToken: wo
                                                          .workorderCreatorToken,
                                                      notificationTitle:
                                                          "Work Order Stand by Update",
                                                      notificationBody:
                                                          "A work order for ${wo.equipmentTagName} was put on stand by",
                                                    );

                                                    //creating a notification id
                                                    String notificationID =
                                                        const Uuid().v4();
                                                    //adding a notification to the admin who created the work order
                                                    //Stand by
                                                    NotificationsModel()
                                                        .sendWorkorderValidationRequestorStandByNotification(
                                                      notificationID:
                                                          notificationID,
                                                      notificationTitle:
                                                          "Work Order Put On Stand By",
                                                      notificationBody:
                                                          "A work order for ${wo.equipmentTagName} was put in stand by state. By ${wo.technicianUserName}.Reason : $standByReason",
                                                      workorderCreatorID:
                                                          wo.workorderCreatorID,
                                                      technicianID:
                                                          wo.technicianID,
                                                      workOrderID:
                                                          wo.workorderID,
                                                      interventionID:
                                                          wo.interventionID,
                                                    );
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Confirm',
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                //If the work order is in Stand By
                                : wo.workorderStatus == workOrderStatus[1]
                                    ? StandByView(
                                        onProgress: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Confirmation"),
                                              content: const Text(
                                                "Are you sure you want to resume this work order ?",
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    //Updating the work order state to
                                                    //'Finished'
                                                    WorkOrderModel()
                                                        .updateWorkOrderStatus(
                                                      workOrderID:
                                                          wo.workorderID,
                                                      //'In Progress'
                                                      newStatus:
                                                          workOrderStatus[0],
                                                      creatorID:
                                                          wo.workorderCreatorID,
                                                      technicianID:
                                                          wo.technicianID,
                                                      interventionID:
                                                          wo.interventionID,
                                                    );
                                                    //sending a push notification
                                                    NotificationsModel()
                                                        .sendNotificationToDevice(
                                                      deviceToken: wo
                                                          .workorderCreatorToken,
                                                      notificationTitle:
                                                          "Work Resumption Notification",
                                                      notificationBody:
                                                          "A work order for ${wo.equipmentTagName} was resumed",
                                                    );
                                                    //creating a notification id
                                                    String notificationID =
                                                        const Uuid().v4();
                                                    //adding a notification to the admin who created the work order
                                                    //to request validation
                                                    NotificationsModel()
                                                        .sendWorkorderValidationRequestorStandByNotification(
                                                      notificationID:
                                                          notificationID,
                                                      notificationTitle:
                                                          "Work Resumption Notification",
                                                      notificationBody:
                                                          "A work order for ${wo.equipmentTagName} was resumed by ${wo.technicianUserName}",
                                                      workorderCreatorID:
                                                          wo.workorderCreatorID,
                                                      technicianID:
                                                          wo.technicianID,
                                                      workOrderID:
                                                          wo.workorderID,
                                                      interventionID:
                                                          wo.interventionID,
                                                    );
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Resume"),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    //If the work order is Finished
                                    : wo.workorderStatus == workOrderStatus[2]
                                        ? const FinishedView()
                                        //If the work order is in Terminated'
                                        : wo.workorderStatus ==
                                                workOrderStatus[3]
                                            ? const TerminatedView()
                                            : const SizedBox.shrink()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
