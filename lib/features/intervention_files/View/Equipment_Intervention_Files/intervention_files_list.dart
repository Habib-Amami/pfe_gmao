import 'package:flutter/material.dart';

import 'files_list_tabs/equipment_curative_files_tab.dart';
import 'files_list_tabs/equipment_preventive_files_tab.dart';

class InterventionFilesList extends StatelessWidget {
  final String equipmentID;

  const InterventionFilesList({
    super.key,
    required this.equipmentID,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Intervention Files List",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.medical_services,
              ),
              text: "Preventive",
            ),
            Tab(
              icon: Icon(
                Icons.healing,
              ),
              text: "Curative",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            EquipmentPreventiveFilesTab(
              equipmentID: equipmentID,
            ),
            EquipmentCurativeFilesTab(
              equipmentID: equipmentID,
            )
          ],
        ),
      ),
    );
  }
}
