import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/notifications/model/data_models/intervention_file_validation_notification.dart';
import 'package:pfe_gmao/features/notifications/view/widget/notification_widget.dart';
import 'package:pfe_gmao/features/notifications/view/view_intervention_file.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

class NotificationStream extends StatefulWidget {
  const NotificationStream({super.key});

  @override
  State<NotificationStream> createState() => _NotificationStreamState();
}

class _NotificationStreamState extends State<NotificationStream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .collection('notifications')
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
                  document.data());
              //return Notification.fromSnapshot(document);
            }).toList();
            return notifications.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('No Notification to display'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewInterventionFile(
                                  equipmentDiscipline:
                                      notifications[index].equipmentDiscipline,
                                  interventionType:
                                      notifications[index].interventionType,
                                  interventionFileID:
                                      notifications[index].interventionFileID,
                                ),
                              ),
                            );
                          },
                          child: NotificationUI(
                            notificationTitle:
                                notifications[index].notificationTitle,
                            notificationMessage:
                                notifications[index].notificationBody,
                            notificationIcon: Icons.edit_document,
                          ),
                        ),
                      );
                    }),
                  );
          },
        ),
      ),
    );
  }
}
