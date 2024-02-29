import 'package:flutter/material.dart';
import 'package:pfe_gmao/menu%20screens/settings.dart';
import 'menu screens/calender_screen.dart';
import 'Equipments/View/equipment_screen.dart';
import 'menu screens/notification_screen.dart';
import 'menu screens/profile_screen.dart';
import 'menu screens/work_order_screen.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 1;
  bool isDarkMode = false;
  final List<Widget> menuScreens = const [
    EquipmentScreen(),
    CalenderScreen(),
    WorkOrderScreen(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0x00e4eef4),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    icon: const Icon(Ionicons.person),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Setting(),
                        ));
                  },
                  icon: const Icon(Ionicons.settings_sharp)),
            ],
          ),
        ),
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
                Icons.webhook_rounded,
              ),
              icon: Icon(
                Icons.webhook_sharp,
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
        ],
      ),
      body: menuScreens[currentPageIndex],
    );
  }
}
