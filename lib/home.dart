import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/Equipments/View/equipment_list_view.dart';
import 'features/intervention_files/View/Global_Intervention_Files/global_intervention_files_list.dart';
import 'firebase/cloud_firestore_references.dart';
import 'menu_screens/calender_screen.dart';
import 'menu_screens/notification_screen.dart';
import 'menu_screens/settings.dart';
import 'menu_screens/work_order_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  bool isDarkMode = false;
  final List<Widget> menuScreens = const [
    EquipmentScreen(),
    GlobalInterventionFilesList(),
    CalenderScreen(),
    WorkOrderScreen(),
  ];

  void getFCMtoken() async {
    await Permission.notification.onGrantedCallback(
      () async {
        String? FCMtoken = await FirebaseMessaging.instance.getToken();
        if (FCMtoken != null) {
          FirebaseFirestore.instance
              .collection(userCollectionRef)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
            {
              "FCMtoken": FCMtoken,
            },
          );
          print(FCMtoken);
        }
      },
    ).request();
  }

  @override
  void initState() {
    getFCMtoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile ORM'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(Ionicons.notifications),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Setting(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_rounded,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          setState(
            () {
              currentPageIndex = index;
            },
          );
        },
        animationDuration: const Duration(
          milliseconds: 500,
        ),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(
              Ionicons.construct_outline,
            ),
            icon: Icon(
              Ionicons.construct,
            ),
            label: "Equipment",
            tooltip: "Equipment List",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Ionicons.file_tray_stacked,
            ),
            icon: Icon(
              Ionicons.file_tray_full,
            ),
            label: "Inter.Files",
            tooltip: "Intervention File",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.tire_repair_outlined,
            ),
            icon: Icon(
              Icons.tire_repair,
            ),
            label: "Intervention",
            tooltip: "Tasks Calender",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.webhook_outlined,
            ),
            icon: Icon(
              Icons.webhook_rounded,
            ),
            label: "work order",
            tooltip: "work flow order",
          ),
        ],
      ),
      body: menuScreens[currentPageIndex],
    );
  }
}
