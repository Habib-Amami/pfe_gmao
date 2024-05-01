import 'package:flutter/material.dart';

import 'files_list_tabs/global_curative_files_tab.dart';
import 'files_list_tabs/global_preventive_files_tab.dart';

class GlobalInterventionFilesList extends StatefulWidget {
  const GlobalInterventionFilesList({super.key});

  @override
  State<GlobalInterventionFilesList> createState() =>
      _GlobalInterventionFilesListState();
}

class _GlobalInterventionFilesListState
    extends State<GlobalInterventionFilesList> {
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
        body: const TabBarView(
          children: [
            GlobalPreventiveFilesTab(),
            GlobalCurativeFilesTab(),
          ],
        ),
      ),
    );
  }
}
