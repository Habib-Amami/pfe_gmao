import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'features/Equipments/View/equipment_screen.dart';
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
    CalenderScreen(),
    WorkOrderScreen(),
    NotificationScreen(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              tooltip: "work flow order"),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.notifications_outline),
            icon: Icon(
              Ionicons.notifications_sharp,
            ),
            label: "Notifications",
            tooltip: "Notifications",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.settings_outlined,
            ),
            icon: Icon(
              Icons.settings_rounded,
            ),
            label: "Settings",
            tooltip: "Settings page",
          ),
        ],
      ),
      body: menuScreens[currentPageIndex],
    );
  }
}
