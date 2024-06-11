import 'package:flutter/material.dart';
import 'intervention_files_list.dart';
import 'add_intervention_file.dart';

class InterventionFileMenu extends StatefulWidget {
  final String equipmentID;

  final String equipmentStatus;
  final String equipmentTagName;
  final String equipmentDiscipline;
  const InterventionFileMenu({
    super.key,
    required this.equipmentStatus,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.equipmentID,
  });

  @override
  State<InterventionFileMenu> createState() => _InterventionFileMenuState();
}

class _InterventionFileMenuState extends State<InterventionFileMenu> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Text("Equipment intervention files"),
      //   automaticallyImplyLeading: true,
      // ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        animationDuration: const Duration(
          milliseconds: 500,
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.post_add_outlined),
            label: "Add Intervention File",
            selectedIcon: Icon(Icons.post_add_rounded),
            tooltip: "Add an intervention file for the equipment",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: "Intervention Files List",
            selectedIcon: Icon(Icons.list_alt_rounded),
            tooltip: "View all intervention files for the equipment",
          ),
        ],
      ),
      body: [
        AddInterventionFile(
          equipmentStatus: widget.equipmentStatus,
          equipmentTagName: widget.equipmentTagName,
          equipmentDiscipline: widget.equipmentDiscipline,
          equipmentID: widget.equipmentID,
        ),
        InterventionFilesList(
          equipmentID: widget.equipmentID,
        ),
      ][currentPageIndex],
    );
  }
}
