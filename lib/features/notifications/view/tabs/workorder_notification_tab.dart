import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../../profile_management/model/user.dart';
import '../../../work_order/view/work%20order%20view/admin_wo_view.dart';
import '../../../work_order/view/work%20order%20view/engineer_wo_view.dart';
import '../../controller/notification_controller.dart';
import '../../model/data_models/work_order_notification.dart';
import '../widget/notification_widget.dart';

class WorkOrderNotificationsTab extends StatefulWidget {
  const WorkOrderNotificationsTab({super.key});

  @override
  State<WorkOrderNotificationsTab> createState() =>
      _WorkOrderNotificationsTabState();
}

class _WorkOrderNotificationsTabState extends State<WorkOrderNotificationsTab> {
  //notification controller;
  NotificationController notificationController = NotificationController();

  late UserModel user;

  //method to fetch the admin data
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

    return user.role == Roles.Administrator;
  }

  void fetchUserRole() async {
    isAdmin = await adminCheck();
  }

  bool isAdmin = false;

  @override
  void initState() {
    fetchUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Permission.notification.request(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for permission result
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data == PermissionStatus.denied ||
                  snapshot.data == PermissionStatus.permanentlyDenied) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Theme.of(context).brightness == Brightness.light
                        ? Lottie.asset(
                            "assets/animations/notification_permission_denied_light.json",
                            repeat: false,
                            width: 200,
                            height: 150,
                          )
                        : SizedBox(
                            width: 200,
                            height: 150,
                            child: Lottie.asset(
                              "assets/animations/notification_permission_denied_dark.json",
                              repeat: false,
                            ),
                          ),
                    const Text(
                      'You denied the notification permission for the application you can change it from',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        openAppSettings().then((value) {
                          if (value) {
                            setState(() {});
                          }
                        });
                      },
                      child: const Text("The Phone Settings"),
                    )
                  ],
                );
              }
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('WO_notifications')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Handle interruption of connection
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
                          Text("Loading Notifications ...")
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
                          // const CircularProgressIndicator(),
                          Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        ],
                      ),
                    );
                  }
                  List<WorkorderNotification> notifications =
                      snapshot.data!.docs.map((document) {
                    return WorkorderNotification.fromJson(
                      document.data(),
                    );
                    //return Notification.fromSnapshot(document);
                  }).toList();
                  return notifications.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text('No Notification to display'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  extentRatio: 0.3,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => setState(() {
                                        notificationController
                                            .deleteWONotification(
                                          notificationID: notifications[index]
                                              .notificationID,
                                        );
                                      }),
                                      foregroundColor: Colors.white,
                                      autoClose: true,
                                      label: 'Delete',
                                      icon: Ionicons.trash_bin,
                                      borderRadius: BorderRadius.circular(13),
                                      backgroundColor: Colors.red.shade700,
                                    )
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser!.uid)
                                          .collection('WO_notifications')
                                          .doc(notifications[index]
                                              .notificationID)
                                          .update({'isRead': true});
                                    } catch (e) {
                                      debugPrint(
                                          'Error updating notification status: $e');
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return isAdmin == false
                                            ? EngineerWorkOrderView(
                                                workOrderID:
                                                    notifications[index]
                                                        .workOrderID,
                                                interventionId:
                                                    notifications[index]
                                                        .interventionID,
                                              )
                                            : AdminWorkOrderView(
                                                workOrderID:
                                                    notifications[index]
                                                        .workOrderID,
                                                interventionId:
                                                    notifications[index]
                                                        .interventionID,
                                              );
                                      }),
                                    );
                                  },
                                  child: NotificationUI(
                                    notificationTitle:
                                        notifications[index].notificationTitle,
                                    notificationMessage:
                                        notifications[index].notificationBody,
                                    notificationIcon: notifications[index]
                                            .notificationBody
                                            .contains('denied')
                                        ? Icons.report
                                        : notifications[index]
                                                .notificationBody
                                                .contains('approved')
                                            ? Ionicons.shield_checkmark_sharp
                                            : notifications[index]
                                                    .notificationBody
                                                    .contains('resumed')
                                                ? Ionicons.play_forward
                                                : notifications[index]
                                                        .notificationBody
                                                        .contains('stand by')
                                                    ? Ionicons.warning
                                                    : notifications[index]
                                                            .notificationTitle
                                                            .contains("Request")
                                                        ? Icons.edit_document
                                                        : Icons
                                                            .work_history_rounded,
                                    notificationColor: notifications[index]
                                            .notificationTitle
                                            .contains("Request")
                                        ? Colors.teal
                                        : notifications[index]
                                                .notificationBody
                                                .contains('denied')
                                            ? Colors.red
                                            : notifications[index]
                                                    .notificationBody
                                                    .contains('approved')
                                                ? Colors.green
                                                : notifications[index]
                                                        .notificationBody
                                                        .contains('resumed')
                                                    ? Colors.deepPurpleAccent
                                                    : notifications[index]
                                                            .notificationBody
                                                            .contains(
                                                                'stand by')
                                                        ? Colors.orangeAccent
                                                        : Colors
                                                            .lightBlueAccent,
                                    notificationDateOfCreation:
                                        notifications[index].createdAt,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                },
              ),
            );
          }),
    );
  }
}
