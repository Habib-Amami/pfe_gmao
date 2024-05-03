import 'package:flutter/material.dart';

import '../../model/constants/intervention_types_list.dart';
import 'nested_intervention_files_tab.dart';

class GlobalInterventionFilesList extends StatefulWidget {
  const GlobalInterventionFilesList({super.key});

  @override
  State<GlobalInterventionFilesList> createState() =>
      _GlobalInterventionFilesListState();
}

class _GlobalInterventionFilesListState
    extends State<GlobalInterventionFilesList> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: const [
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
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              NestedCurativeTab(
                interventionType: interventionTypes[1], //"Preventive"
              ),
              NestedCurativeTab(
                interventionType: interventionTypes[0], // "Curative"
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(
//                   Icons.medical_services,
//                 ),
//                 text: "Preventive",
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.healing,
//                 ),
//                 text: "Curative",
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             NestedCurativeTab(
//               interventionType: interventionTypes[1], //"Preventive"
//             ),
//             NestedCurativeTab(
//               interventionType: interventionTypes[0], // "Curative"
//             ),
//           ],
//         ),