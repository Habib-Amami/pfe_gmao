import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../../notifications/model/notification_model.dart';
import '../../../../model/constants/work_order_status.dart';
import '../../../../model/data_models/work_order.dart';
import '../../../../model/work_order_model.dart';

class InProgressView extends StatefulWidget {
  final WorkOrder workOrder;
  final int numberOfChecked;
  const InProgressView({
    super.key,
    required this.workOrder,
    required this.numberOfChecked,
  });

  @override
  State<InProgressView> createState() => _InProgressViewState();
}

class _InProgressViewState extends State<InProgressView> {
  // Form key for managing the state of the email update form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // Variables to store user email and password inputs
  String _standByReason = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //Button to change the workorder state
        //to Finished
        SizedBox(
          width: 130,
          child: FilledButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Finish'),
            onPressed: () {
              //if all the steps were not checked
              if (widget.numberOfChecked < widget.workOrder.steps.length) {
                ScaffoldMessenger.of(context).showSnackBar(
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
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            //Updating the work order state to
                            //'Finished'
                            WorkOrderModel().updateWorkOrderStatus(
                              workOrderID: widget.workOrder.workorderID,
                              //'Finished'
                              newStatus: workOrderStatus[2],
                              creatorID: widget.workOrder.workorderCreatorID,
                              technicianID: widget.workOrder.technicianID,
                              interventionID: widget.workOrder.interventionID,
                            );
                            //sending a push notification
                            NotificationsModel().sendNotificationToDevice(
                              deviceToken:
                                  widget.workOrder.workorderCreatorToken,
                              notificationTitle:
                                  "Work Order Validation Request",
                              notificationBody:
                                  "A work order for ${widget.workOrder.equipmentTagName} requires your validation",
                            );
                            //creating a notification id
                            String notificationID = const Uuid().v4();
                            //adding a notification to the admin who created the work order
                            //to request validation
                            NotificationsModel()
                                .sendWorkorderValidationRequestorStandByNotification(
                              notificationID: notificationID,
                              notificationTitle:
                                  "Work Order validation Request",
                              notificationBody:
                                  "A work order for ${widget.workOrder.equipmentTagName} requires your validation",
                              workorderCreatorID:
                                  widget.workOrder.workorderCreatorID,
                              technicianID: widget.workOrder.technicianID,
                              workOrderID: widget.workOrder.workorderID,
                              interventionID: widget.workOrder.interventionID,
                            );
                          });
                        },
                        child: const Text("Finalize"),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        //Button to change the workorder state
        //to Stand By
        SizedBox(
          width: 130,
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.pause,
              color: Theme.of(context).colorScheme.background,
            ),
            label: Text(
              'Stand By',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
            ),
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
                      height: MediaQuery.sizeOf(context).height / 7,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                                'Are you sure you want to put this work order on stand by?'),
                          ),
                          Form(
                            key: _formkey,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: "Provide a reason",
                                prefixIcon: Icon(Icons.mode_standby_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please provide your reason";
                                }
                                return null;
                              },
                              onSaved: (newEmail) =>
                                  _standByReason = newEmail!.trim(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(
                          context,
                        ),
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();

                            //update the work order state to
                            //'Stand By'
                            WorkOrderModel().updateWorkOrderStatus(
                              workOrderID: widget.workOrder.workorderID,
                              //'Finished'
                              newStatus: workOrderStatus[1],
                              creatorID: widget.workOrder.workorderCreatorID,
                              technicianID: widget.workOrder.technicianID,
                              interventionID: widget.workOrder.interventionID,
                            );
                            //seding a push notification
                            NotificationsModel().sendNotificationToDevice(
                              deviceToken:
                                  widget.workOrder.workorderCreatorToken,
                              notificationTitle: "Work Order Stand by Update",
                              notificationBody:
                                  "A work order for ${widget.workOrder.equipmentTagName} was put on stand by",
                            );

                            //creating a notification id
                            String notificationID = const Uuid().v4();
                            //adding a notification to the admin who created the work order
                            //Stand by
                            NotificationsModel()
                                .sendWorkorderValidationRequestorStandByNotification(
                              notificationID: notificationID,
                              notificationTitle: "Work Order Put On Stand By",
                              notificationBody:
                                  "A work order for ${widget.workOrder.equipmentTagName} in put in stand by. By ${widget.workOrder.technicianUserName}. Stand by reason : $_standByReason",
                              workorderCreatorID:
                                  widget.workOrder.workorderCreatorID,
                              technicianID: widget.workOrder.technicianID,
                              workOrderID: widget.workOrder.workorderID,
                              interventionID: widget.workOrder.interventionID,
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
          ),
        ),
      ],
    );
  }
}
