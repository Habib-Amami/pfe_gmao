import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../model/data_models/preventive_intervention_file.dart';
import 'widgets/intervention_file_status.dart';

class InterventionFilesList extends StatefulWidget {
  final String equipmentID;

  const InterventionFilesList({
    super.key,
    required this.equipmentID,
  });

  @override
  State<InterventionFilesList> createState() => _InterventionFilesListState();
}

class _InterventionFilesListState extends State<InterventionFilesList> {
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(equipmentCollectionRef)
                  .doc(widget.equipmentID)
                  .collection("preventive_intervention_files")
                  .snapshots(),
              builder: (context, snapshot) {
                // Handle interruption of connection
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50.0,
                        ),
                        SizedBox(height: 10.0),
                        Text("Lost connection"),
                      ],
                    ),
                  );
                }
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("Loading files ...")
                      ],
                    ),
                  );
                }
                // Show error message if an error occurs
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const CircularProgressIndicator(),
                        Center(
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      ],
                    ),
                  );
                }
                List<PreventiveInterventionFile> files = snapshot.data!.docs
                    .map(
                      (document) => PreventiveInterventionFile.fromJson(
                        document.data(),
                      ),
                    )
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      if (files.isEmpty) {
                        return const Text("No files were found!");
                      } else {
                        return Card(
                          child: ExpansionTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "File Name :   ${files[index].fileName}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InterventionFileStatus(
                                status: files[index].fileStatus,
                              ),
                            ),
                            expandedAlignment: Alignment.centerLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Discipline :   ${files[index].equipmentDiscipline}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Task :   ${files[index].interventionTask}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Starting Day :   ${files[index].startingDay}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Forecast :   ${files[index].forecast} days",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Tools :   ${files[index].tools}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "Spare Parts :   ${files[index].spareParts}",
                                overflow: TextOverflow.ellipsis,
                              ),

                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Technicians :",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 18),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          files[index].mechanicalTechnician
                                              ? const Text(
                                                  "Mechanical technician")
                                              : Container(),
                                          files[index].electricalTechnician
                                              ? const Text(
                                                  'Electrical technician')
                                              : Container(),
                                          files[index].instrumentTechnician
                                              ? const Text(
                                                  'Instrument technician')
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 8.0),
                              //   child: Table(
                              //     border: TableBorder
                              //         .all(), // Add border to the table
                              //     children: [
                              //       TableRow(
                              //         children: [
                              //           const TableCell(
                              //             child: Center(
                              //               child: Text("Mechanical Technician"),
                              //             ),
                              //           ),
                              //           TableCell(
                              //             child: Center(
                              //               child: Text(
                              //                 files[index].mechanicalTechnician
                              //                     ? 'Yes'
                              //                     : 'No',
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       TableRow(
                              //         children: [
                              //           const TableCell(
                              //             child: Center(
                              //               child: Text("Electrical Technician"),
                              //             ),
                              //           ),
                              //           TableCell(
                              //             child: Center(
                              //               child: Text(
                              //                 files[index].electricalTechnician
                              //                     ? 'Yes'
                              //                     : 'No',
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       TableRow(
                              //         children: [
                              //           const TableCell(
                              //             child: Center(
                              //               child: Text("Instrument Technician"),
                              //             ),
                              //           ),
                              //           TableCell(
                              //             child: Center(
                              //               child: Text(
                              //                 files[index].instrumentTechnician
                              //                     ? 'Yes'
                              //                     : 'No',
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
            Center(
              child: Text("It's rainy here"),
            ),
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
//   List<String> interverntionStatus = ["Confirmed", "Not"];
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
//                             interverntionStatus.length,
//                             (index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: ChoiceChip(
//                                   showCheckmark: false,
//                                   labelStyle:
//                                       Theme.of(context).textTheme.labelSmall,
//                                   label: Text(
//                                     interverntionStatus[index],
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
