// ignore_for_file: non_constant_identifier_names

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ionicons/ionicons.dart';

import 'features/Equipments/View/equipment_list_view.dart';
import 'features/intervention_files/View/Global_Intervention_Files/global_intervention_files_list.dart';
import 'features/interventions/view/calender_screen.dart';
import 'features/notifications/model/notification_model.dart';
import 'features/notifications/view/notification_screen.dart';
import 'features/work_order/view/work_order_view.dart';
import 'firebase/cloud_firestore_references.dart';
import 'main.dart';
import 'menu_screens/settings.dart';

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
    WorkOrderView(),
  ];

  @override
  void initState() {
    super.initState();
    getFCMtoken();
    // setupInteractedMessage();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                NotificationsModel.channel.id,
                NotificationsModel.channel.name,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile ORM'),
        actions: [
          OpenContainer(
            closedElevation: 0.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            closedColor: Colors.transparent,
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 600),
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return IconButton(
                onPressed: openContainer,
                icon: const Icon(Ionicons.notifications),
              );
            },
            openBuilder: (BuildContext _, VoidCallback __) {
              return const NotificationScreen();
            },
          ),
          OpenContainer(
            closedElevation: 0.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            closedColor: Colors.transparent,
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 400),
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return IconButton(
                icon: const Icon(
                  Icons.settings_rounded,
                ),
                onPressed: openContainer,
              );
            },
            openBuilder: (BuildContext _, VoidCallback __) {
              return const Setting();
            },
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
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (
          child,
          primaryAnimation,
          secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: menuScreens[currentPageIndex],
      ),
    );
  }

  //gets the FCM token and stores in the user collection
  void getFCMtoken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? FCMtoken = await messaging.getToken();

    if (FCMtoken != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the FCM token in Firestore
      await FirebaseFirestore.instance
          .collection(userCollectionRef)
          .doc(userId)
          .update({
        "FCMtoken": FCMtoken,
      });

      if (kDebugMode) {
        print("Token updated for user $userId: $FCMtoken");
      }
    }
  }

  // void setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   // the app was opened from terminated state via a notification
  //   // navigate to a notifications screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }

  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener to navigate to the notifications screen
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // //this methode will display the notification
  // void _handleMessage(RemoteMessage message) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const NotificationScreen(),
  //     ),
  //   );
  // }
}
