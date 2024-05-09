import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/notifications/model/notification_model.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../intervention_files/View/intervention_file_validation_view.dart';
import '../model/data_models/intervention_file_validation_notification.dart';
import 'widget/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
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
                    .collection('notifications')
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
                  List<InterventionFileValidationNotification> notifications =
                      snapshot.data!.docs.map((document) {
                    return InterventionFileValidationNotification.fromJson(
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
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => setState(() {
                                        NotificationsModel().deleteNotification(
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InterventionFileValidationView(
                                          interventionFileCreatorID:
                                              notifications[index]
                                                  .interventionFileCreatorID,
                                          interventionFileCreatorToken:
                                              notifications[index]
                                                  .interventionFileCreatorToken,
                                          equipmentTagName: notifications[index]
                                              .equipmentTagName,
                                          equipmentID:
                                              notifications[index].equipmentID,
                                          equipmentDiscipline:
                                              notifications[index]
                                                  .equipmentDiscipline,
                                          interventionType: notifications[index]
                                              .interventionType,
                                          interventionFileID:
                                              notifications[index]
                                                  .interventionFileID,
                                        ),
                                      ),
                                    );
                                  },
                                  child: notifications[index]
                                                  .notificationTitle ==
                                              'Validation Update' &&
                                          notifications[index]
                                              .notificationBody
                                              .contains('denied')
                                      ? NotificationUI(
                                          notificationDateOfCreation:
                                              notifications[index].createdAt,
                                          notificationTitle:
                                              notifications[index]
                                                  .notificationTitle,
                                          notificationMessage:
                                              notifications[index]
                                                  .notificationBody,
                                          notificationIcon:
                                              Icons.highlight_off_rounded,
                                          notificationColor: Colors.red,
                                        )
                                      : notifications[index]
                                                      .notificationTitle ==
                                                  'Validation Update' &&
                                              notifications[index]
                                                  .notificationBody
                                                  .contains('validated')
                                          ? NotificationUI(
                                              notificationDateOfCreation:
                                                  notifications[index]
                                                      .createdAt,
                                              notificationTitle:
                                                  notifications[index]
                                                      .notificationTitle,
                                              notificationMessage:
                                                  notifications[index]
                                                      .notificationBody,
                                              notificationIcon:
                                                  Ionicons.checkmark_done_sharp,
                                              notificationColor: Colors.green,
                                            )
                                          : NotificationUI(
                                              notificationDateOfCreation:
                                                  notifications[index]
                                                      .createdAt,
                                              notificationTitle:
                                                  notifications[index]
                                                      .notificationTitle,
                                              notificationMessage:
                                                  notifications[index]
                                                      .notificationBody,
                                              notificationIcon:
                                                  Icons.edit_document,
                                              notificationColor:
                                                  Colors.orangeAccent,
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
