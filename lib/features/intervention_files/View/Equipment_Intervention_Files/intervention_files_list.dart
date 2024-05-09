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

// ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:pfe_gmao/features/Equipments/model/data_models/discipline_list.dart';

// class InterventionFilesList extends StatefulWidget {
//   const InterventionFilesList({super.key});

//   @override
//   State<InterventionFilesList> createState() => _InterventionFilesListState();
// }

// class _InterventionFilesListState extends State<InterventionFilesList> {
//   List<String> disciplineFilter = ["All", ...disciplineValueList];
//   List<String> interventionStatus = ["Confirmed", "Not"];
//   bool _customTileExpanded = true;
//   int? _value1 = 1;
//   int? _value2 = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ExpansionTile(
//                   onExpansionChanged: (bool expanded) {
//                     setState(() {
//                       _customTileExpanded = expanded;
//                     });
//                   },
//                   expandedAlignment: Alignment.centerLeft,
//                   expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                   initiallyExpanded: _customTileExpanded,
//                   tilePadding: const EdgeInsets.all(0),
//                   title: const SearchBar(
//                     leading: Icon(Icons.search_outlined),
//                     hintText: "search for intervention files",
//                   ),
//                   trailing: Icon(
//                     _customTileExpanded
//                         ? Icons.menu_open_rounded
//                         : Icons.menu_rounded,
//                   ),
//                   children: [
//                     const Text(
//                       "Search by Discipline:",
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         children: [
//                           ...List<Widget>.generate(
//                             disciplineFilter.length,
//                             (index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: ChoiceChip(
//                                   showCheckmark: false,
//                                   labelStyle:
//                                       Theme.of(context).textTheme.labelSmall,
//                                   label: Text(
//                                     disciplineFilter[index],
//                                   ),
//                                   selected: _value1 == index,
//                                   onSelected: (bool selected) {
//                                     setState(() {
//                                       _value1 = selected ? index : null;
//                                     });
//                                   },
//                                 ),
//                               );
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                     const Text(
//                       "Search by Status:",
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         children: [
//                           ...List<Widget>.generate(
//                             interventionStatus.length,
//                             (index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: ChoiceChip(
//                                   showCheckmark: false,
//                                   labelStyle:
//                                       Theme.of(context).textTheme.labelSmall,
//                                   label: Text(
//                                     interventionStatus[index],
//                                   ),
//                                   selected: _value2 == index,
//                                   onSelected: (bool selected) {
//                                     setState(() {
//                                       _value2 = selected ? index : null;
//                                     });
//                                   },
//                                 ),
//                               );
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   disciplineValueList[0],
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 180,
//                   child: ListView(
//                     children: [
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   disciplineValueList[1],
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 180,
//                   child: ListView(
//                     children: [
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   disciplineValueList[2],
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 180,
//                   child: ListView(
//                     children: [
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Card(
//                         color: Theme.of(context).colorScheme.primaryContainer,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: CircleAvatar(
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("File Name"),
//                                   Text("other info ..")
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
