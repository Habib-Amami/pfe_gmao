import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:pfe_gmao/features/notifications/view/widget/preventive_file_widget.dart';

class ViewInterventionFile extends StatefulWidget {
  final String interventionFileID;
  final String interventionType;
  final String equipmentDiscipline;
  const ViewInterventionFile({
    required this.interventionFileID,
    super.key,
    required this.interventionType,
    required this.equipmentDiscipline,
  });

  @override
  State<ViewInterventionFile> createState() => _AddInterventionFileState();
}

class _AddInterventionFileState extends State<ViewInterventionFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.interventionType} Intervention file',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(
                  'collective_${widget.equipmentDiscipline}_${widget.interventionType}_intervention_files')
              .doc(widget.interventionFileID)
              .get(),
          builder: ((context, snapshot) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            List technicians = [];
            data['instrumentTechnician']
                ? technicians.add('Instrument Technician')
                : debugPrint('no instrument');
            data['electricalTechnician']
                ? technicians.add('Electrical Technician')
                : debugPrint('no electrical');
            data['mechanicalTechnician']
                ? technicians.add('Mechanical Technician')
                : debugPrint('no mechanical');
            String technicianList = technicians.join(' - ');
            var spareParts = data['spareParts'].join(' - ');
            var tools = data['tools'].join(' - ');
            return ListView(
              children: [
                SingleChildScrollView(
                  child: widget.interventionType == 'Preventive'
                      ? PreventiveFile(
                          spareParts: spareParts,
                          task: data['interventionTask'],
                          startingDay: data['startingDay'],
                          forecast: data['forecast'],
                          equipmentName: data['equipmentTagName'],
                          equipmentStatus: data['equipmentStatus'],
                          equipmentDiscipline: widget.equipmentDiscipline,
                          fileName: data['fileName'],
                          interventionType: widget.interventionType,
                          technicians: technicianList,
                          tools: tools,
                        )
                      : Container(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.error)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Deny alert'),
                                  content: const Text(
                                      'Tell us why you denied this intervention file!'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              width: 70,
                                              height: 35,
                                              child: const Center(
                                                  child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Deny',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.primary)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Do you really want to validate this intervention file?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              width: 90,
                                              height: 40,
                                              child: const Center(
                                                  child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Validate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          })),
    );
  }
}
