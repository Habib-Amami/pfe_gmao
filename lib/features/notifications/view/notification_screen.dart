import 'package:flutter/material.dart';

import 'tabs/intervention_file_notification_tab.dart';
import 'tabs/workorder_notification_tab.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
