import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

import 'tabs/intervention_file_notification_tab.dart';
import 'tabs/workorder_notification_tab.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.userId});
  final String userId;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int unreadNotificationsCount = 0;
  @override
  void initState() {
    super.initState();
    _fetchUnreadNotificationCount;
  }

  Future<void> _fetchUnreadNotificationCount() async {
    int workOrderUnreadNotification =
        await _fetchUnreadCount('WO_notifications');
    int interventionFileUnreadNotification =
        await _fetchUnreadCount('IF_notifications');
    unreadNotificationsCount =
        workOrderUnreadNotification + interventionFileUnreadNotification;
  }

  Future<int> _fetchUnreadCount(String subcollection) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .doc(widget.userId)
        .collection(subcollection)
        .where('isRead', isEqualTo: false)
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          automaticallyImplyLeading: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Inter.Files Notifications",
                // icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                text: "Work Order Notifications",
                // icon: Icon(Icons.beach_access_sharp),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InterventionFilesNotificationsTab(),
            WorkOrderNotificationsTab(),
          ],
        ),
      ),
    );
  }
}
