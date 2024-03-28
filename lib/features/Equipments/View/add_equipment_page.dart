import 'package:flutter/material.dart';

import 'add_equipment_information_view.dart';
import 'add_equipment_intervation_view.dart';

class AddEquipmentPage extends StatefulWidget {
  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => AddEquipmentPageState();
}

class AddEquipmentPageState extends State<AddEquipmentPage> {
  int currentPageIndex = 0;
  final List<Widget> menuScreens = const [
    AddEquipmentInformationScreen(),
    AddEquipmentInterventionView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new equipment"),
        automaticallyImplyLeading: true,
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
              Icons.info_outline,
            ),
            icon: Icon(
              Icons.info_rounded,
            ),
            label: "Equipment information",
            tooltip: "Add equipment information",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.repartition_rounded,
            ),
            icon: Icon(
              Icons.repartition_outlined,
            ),
            label: "Equipment intervention",
            tooltip: "Add equipment intervention",
          ),
        ],
      ),
      body: menuScreens[currentPageIndex],
    );
  }
}
