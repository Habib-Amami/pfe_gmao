import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/notifications/model/notification_model.dart';
import 'package:pfe_gmao/features/profile_management/model/user.dart';
import 'package:pfe_gmao/features/work_order/model/constants/work_order_status.dart';
import 'package:pfe_gmao/features/work_order/model/data_models/work_order.dart';
import 'package:pfe_gmao/features/work_order/model/work_order_model.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_form_field.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_form_title.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';
import 'package:uuid/uuid.dart';

class AdminWorkOrderView extends StatefulWidget {
  const AdminWorkOrderView({
    super.key,
    required this.workOrderID,
    required this.interventionId,
  });

  final String workOrderID;
  final String interventionId;

  @override
  State<AdminWorkOrderView> createState() => _AdminWorkOrderViewState();
}

class _AdminWorkOrderViewState extends State<AdminWorkOrderView> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _denyReason = "";
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
                          // information
                          const WorkOrderFormTitle(title: "Technician"),
                          // technician information
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection(userCollectionRef)
                                    .doc(wo.technicianID)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          Text("loading.."),
                                        ],
                                      ),
                                    );
                                  }
                                  UserModel technicianInfo =
                                      UserModel.fromFirestore(
                                          snapshot.data!, null);

                                  return Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            radius: 40,
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                technicianInfo.photoURL,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0),
                                                child: Text(
                                                  '${technicianInfo.userName} - ${technicianInfo.serialNumber}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ),
                                              Text(
                                                'Email: ${technicianInfo.email}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
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
                                      title: 'Starting Time'),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 3,
                                    child: WorkOrderFormField(
                                      readOnly: true,
                                      prefixIcon: const Icon(Icons.timer),
                                      initialValue:
                                          formatTimeOfDay(wo.startTime),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const WorkOrderFormTitle(
                                      title: 'Finishing Time'),
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

                          const WorkOrderFormTitle(title: 'Intervention Steps'),
                          for (var step in wo.steps)
                            Padding(
                              padding: step == wo.steps.last
                                  ? const EdgeInsets.only(bottom: 16.0)
                                  : const EdgeInsets.only(bottom: 0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    '${wo.steps.indexOf(step) + 1}- $step',
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

                          wo.workorderStatus == workOrderStatus[0]
                              ? Container(
                                  height: 65,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Text(
                                        'This work order is still In Progress'),
                                  ),
                                )
                              : wo.workorderStatus == workOrderStatus[3]
                                  ? Container(
                                      height: 65,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Text(
                                            'This work order is Terminated'),
                                      ),
                                    )
                                  : wo.workorderStatus == workOrderStatus[1]
                                      ? Container(
                                          height: 65,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: Text(
                                                'This work order is in Stand by mode'),
                                          ),
                                        )
                                      : wo.workorderStatus == workOrderStatus[2]
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error)),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Confirmation',
                                                          ),
                                                          content: SizedBox(
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height /
                                                                6,
                                                            child: Column(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              16.0),
                                                                  child: Text(
                                                                      'Are you sure you want to deny this work order?'),
                                                                ),
                                                                Form(
                                                                  key: _formkey,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .done,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          "Provide a reason",
                                                                      prefixIcon:
                                                                          Icon(Icons
                                                                              .mode_standby_rounded),
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        return "please provide your reason";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onSaved: (newEmail) =>
                                                                        _denyReason =
                                                                            newEmail!.trim(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                context,
                                                              ),
                                                              child: const Text(
                                                                "Cancel",
                                                              ),
                                                            ),
                                                            //confirmation button
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                if (_formkey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  _formkey
                                                                      .currentState!
                                                                      .save();

                                                                  //update the work order state to'in progress'
                                                                  WorkOrderModel()
                                                                      .updateWorkOrderStatus(
                                                                    workOrderID:
                                                                        wo.workorderID,
                                                                    //'Finished'
                                                                    newStatus:
                                                                        workOrderStatus[
                                                                            0],
                                                                    creatorID: wo
                                                                        .workorderCreatorID,
                                                                    technicianID:
                                                                        wo.technicianID,
                                                                    interventionID:
                                                                        wo.interventionID,
                                                                  );
                                                                  //sending a push notification
                                                                  NotificationsModel()
                                                                      .sendNotificationToDevice(
                                                                    deviceToken:
                                                                        wo.technicianToken,
                                                                    notificationTitle:
                                                                        "Termination Response",
                                                                    notificationBody:
                                                                        "A work order for ${wo.equipmentTagName} was denied due to $_denyReason",
                                                                  );

                                                                  //creating a notification id
                                                                  String
                                                                      notificationID =
                                                                      const Uuid()
                                                                          .v4();
                                                                  NotificationsModel()
                                                                      .validateOrDenyRequestNotification(
                                                                    interventionID:
                                                                        wo.interventionID,
                                                                    notificationBody:
                                                                        "A work order for ${wo.equipmentTagName} was denied due to $_denyReason",
                                                                    notificationID:
                                                                        notificationID,
                                                                    notificationTitle:
                                                                        "Termination Response",
                                                                    technicianID:
                                                                        wo.technicianID,
                                                                    workOrderID:
                                                                        wo.workorderID,
                                                                    workorderCreatorID:
                                                                        wo.workorderCreatorID,
                                                                  );

                                                                  setState(() {
                                                                    Navigator.pop(
                                                                        context);
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
                                                  child: Text(
                                                    'Deny',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary)),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Confirmation'),
                                                            content: const Text(
                                                                'Are you sure you want to terminate this work order?'),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  //sending a push notification
                                                                  NotificationsModel()
                                                                      .sendNotificationToDevice(
                                                                    deviceToken:
                                                                        wo.technicianToken,
                                                                    notificationTitle:
                                                                        "Termination Response",
                                                                    notificationBody:
                                                                        "A work order for ${wo.equipmentTagName} was approved. Work order is terminated",
                                                                  );
                                                                  WorkOrderModel()
                                                                      .updateWorkOrderStatus(
                                                                    workOrderID:
                                                                        wo.workorderID,
                                                                    //'Finished'
                                                                    newStatus:
                                                                        'Terminated',
                                                                    creatorID: wo
                                                                        .workorderCreatorID,
                                                                    technicianID:
                                                                        wo.technicianID,
                                                                    interventionID:
                                                                        wo.interventionID,
                                                                  );

                                                                  //creating a notification id
                                                                  String
                                                                      notificationID =
                                                                      const Uuid()
                                                                          .v4();
                                                                  NotificationsModel()
                                                                      .validateOrDenyRequestNotification(
                                                                    interventionID:
                                                                        wo.interventionID,
                                                                    notificationBody:
                                                                        "A work order for ${wo.equipmentTagName} was approved. Work order is terminated",
                                                                    notificationID:
                                                                        notificationID,
                                                                    notificationTitle:
                                                                        "Termination Response",
                                                                    technicianID:
                                                                        wo.technicianID,
                                                                    workOrderID:
                                                                        wo.workorderID,
                                                                    workorderCreatorID:
                                                                        wo.workorderCreatorID,
                                                                  );
                                                                  setState(() {
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor: MaterialStatePropertyAll(Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary)),
                                                                child: Text(
                                                                  'Terminate',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .background),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Text(
                                                    'Terminate',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink()
                        ]),
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
