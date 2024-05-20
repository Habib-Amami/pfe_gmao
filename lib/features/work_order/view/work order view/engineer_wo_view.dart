import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfe_gmao/features/interventions/model/data_models/intervention.dart';
import 'package:pfe_gmao/features/profile_management/model/user.dart';
import 'package:pfe_gmao/features/work_order/model/data_models/work_order.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_form_field.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_form_title.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

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
  late Future<Intervention?> _interventionFuture;
  List<ValueNotifier<bool>> _isCheckedList = [];
  int numberOfChecked = 0;
  bool? isChecked = false;
  // intervention information query
  Future<Intervention?> getInterventionById(String interventionID) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('interventions')
          .doc(widget.interventionId)
          .get();
      if (doc.exists && doc.data() != null) {
        return Intervention.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching intervention: $e');
      return null;
    }
  }

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
    _interventionFuture = getInterventionById(widget.interventionId);
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

                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onErrorContainer,
                                            radius: 35,
                                            child: CircleAvatar(
                                              radius: 35,
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
                          FutureBuilder<Intervention?>(
                              future: _interventionFuture,
                              builder: ((context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(
                                      child: Text('No intervention found.'));
                                }
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
                                          child:
                                              Text('Error: ${snapshot.error}'),
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
                                Intervention intervention = snapshot.data!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const WorkOrderFormTitle(
                                        title: 'Main task'),
                                    WorkOrderFormField(
                                      initialValue:
                                          intervention.interventionTask,
                                      readOnly: true,
                                      prefixIcon: const Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                    ),
                                    // steps
                                    const WorkOrderFormTitle(
                                        title: 'Intervention Steps'),
                                    // ignore: unused_local_variable
                                    for (int i = 0; i < wo.steps.length; i++)
                                      Padding(
                                        padding: i == wo.steps.length - 1
                                            ? const EdgeInsets.only(
                                                bottom: 16.0)
                                            : const EdgeInsets.only(bottom: 0),
                                        child: Card(
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${i + 1}- ${wo.steps[i]}'),
                                                ValueListenableBuilder<bool>(
                                                  valueListenable:
                                                      _isCheckedList[i],
                                                  builder:
                                                      (context, isChecked, _) {
                                                    return Checkbox(
                                                      value: isChecked,
                                                      onChanged: (value) {
                                                        _isCheckedList[i]
                                                            .value = value!;
                                                        numberOfChecked =
                                                            _isCheckedList
                                                                .where((notifier) =>
                                                                    notifier
                                                                        .value)
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
                                    const WorkOrderFormTitle(
                                        title: 'Spare Parts'),
                                    for (var item in intervention.spareParts)
                                      Padding(
                                        padding: item ==
                                                intervention.spareParts.last
                                            ? const EdgeInsets.only(
                                                bottom: 16.0)
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
                                    for (var item in intervention.tools)
                                      Padding(
                                        padding: item == intervention.tools.last
                                            ? const EdgeInsets.only(
                                                bottom: 16.0)
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
                                    const WorkOrderFormTitle(
                                        title: 'Work order State')
                                  ],
                                );
                              })),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
