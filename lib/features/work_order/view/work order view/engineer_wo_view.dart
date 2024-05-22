import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_action_buttons/engineer/finished_view.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_action_buttons/engineer/terminated_view.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../model/constants/work_order_status.dart';
import '../../model/data_models/work_order.dart';
import '../../model/work_order_model.dart';
import '../widgets/work_order_action_buttons/engineer/in_progress_view.dart';
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
//                             Padding(
//   padding: const EdgeInsets.symmetric(vertical: 16),
//   child: _buildWorkOrderStatusWidget(context: context,workOrder: wo,workorderStatus: wo.workorderStatus,),
// );
                            // Status handling
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              //'Finished'
                              child: wo.workorderStatus == workOrderStatus[3]
                                  ? const FinishedView()
                                  //'In Progress'
                                  : wo.workorderStatus == workOrderStatus[0]
                                      ? InProgressView(
                                          workOrder: wo,
                                          numberOfChecked: numberOfChecked,
                                        )
                                      //'Stand By'
                                      : wo.workorderStatus == workOrderStatus[1]
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                //
                                                ElevatedButton(
                                                  onPressed: () {
                                                    WorkOrderModel()
                                                        .updateWorkOrderStatus(
                                                      workOrderID:
                                                          wo.workorderID,
                                                      newStatus:
                                                          workOrderStatus[0],
                                                      creatorID:
                                                          wo.workorderCreatorID,
                                                      technicianID:
                                                          wo.technicianID,
                                                      interventionID:
                                                          wo.interventionID,
                                                    );
                                                    setState(() {});
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                      Color.fromRGBO(
                                                        25,
                                                        118,
                                                        210,
                                                        1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'In Progress',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (numberOfChecked !=
                                                        wo.steps.length) {
                                                      const snackBar = SnackBar(
                                                        content: Center(
                                                            child: Text(
                                                                'Please make sure that all the steps are done')),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Confirmation',
                                                            ),
                                                            content: const Text(
                                                                'Are you sure of sending a validation request?'),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // handle the state change to finish
                                                                  WorkOrderModel()
                                                                      .updateWorkOrderStatus(
                                                                    workOrderID:
                                                                        wo.workorderID,
                                                                    newStatus:
                                                                        workOrderStatus[
                                                                            3],
                                                                    creatorID: wo
                                                                        .workorderCreatorID,
                                                                    technicianID:
                                                                        wo.technicianID,
                                                                    interventionID:
                                                                        wo.interventionID,
                                                                  );
                                                                  //
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(
                                                                    Theme.of(
                                                                      context,
                                                                    )
                                                                        .colorScheme
                                                                        .primary,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  'Confirm',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme
                                                                            .of(
                                                                      context,
                                                                    )
                                                                        .colorScheme
                                                                        .background,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    'Stand By',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          //'Terminated'
                                          : wo.workorderStatus ==
                                                  workOrderStatus[3]
                                              ? const TerminatedView()
                                              : const SizedBox.shrink(),
                            )
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

//   Widget _buildWorkOrderStatusWidget({required String workorderStatus,required WorkOrder workOrder,required BuildContext context,}) {
//   switch (workorderStatus) {
//     case 'In Progress':
//       return ;
//     case 'Stand By':
//       return ;
//     case 'Finished':
//       return ;
//     case 'Terminated':
//       return ;
//     default:
//       return const SizedBox.shrink();
//   }
// }
}
