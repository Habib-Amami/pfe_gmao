import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfe_gmao/features/notifications/model/data_models/intervention_file_validation_notification.dart';
import 'package:pfe_gmao/features/notifications/view/widget/notification_stream.dart';
import 'package:pfe_gmao/features/notifications/view/widget/notification_widget.dart';
import 'package:pfe_gmao/features/notifications/view/view_intervention_file.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

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
        automaticallyImplyLeading: true,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28, right: 20, top: 8),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: NotificationStream(),
          ),
        ],
      ),
    );
  }
}
