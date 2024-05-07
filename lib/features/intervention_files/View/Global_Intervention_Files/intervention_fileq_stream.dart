import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_gmao/features/intervention_files/View/intervention_file_view.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/add_file_form/intervention_file_status.dart';
import '../../model/constants/intervention_types_list.dart';
import '../../model/data_models/curative_intervention_file.dart';
import '../../model/data_models/preventive_intervention_file.dart';

class InterventionFilesStream extends StatelessWidget {
  final String interventionType;
  final String discipline;

  const InterventionFilesStream({
    super.key,
    required this.interventionType,
    required this.discipline,
  });

  @override
  Widget build(BuildContext context) {
    String collectionRef =
        "collective_${discipline}_${interventionType}_intervention_files";
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
            collectionRef,
          )
          .orderBy('createdAt', descending: true)
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
        // if intervention type is "Curative"
        if (interventionType == interventionTypes[0]) {
          List<CurativeInterventionFile> files = snapshot.data!.docs
              .map(
                (document) => CurativeInterventionFile.fromJson(
                  document.data(),
                ),
              )
              .toList();
          //no data found
          if (files.isEmpty) {
            if (Theme.of(context).brightness == Brightness.light) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/no_file_found_light.json",
                    repeat: false,
                  ),
                  Text(
                    "No $interventionType interventions files found",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/no_file_found_dark.json",
                    repeat: false,
                  ),
                  Text(
                    "No $interventionType interventions files found",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterventionFileViewPage(
                          interventionFileID: files[index].fileID,
                          interventionType: files[index].maintenanceType,
                          equipmentDiscipline: files[index].equipmentDiscipline,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            files[index].fileName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InterventionFileStatus(
                            status: files[index].fileStatus,
                          )
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Equipment  :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(files[index].equipmentTagName),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Discipline  :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(files[index].equipmentDiscipline),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Criticality  :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(files[index].criticity),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          // if intervention type is "Preventive"
          List<PreventiveInterventionFile> files = snapshot.data!.docs
              .map(
                (document) => PreventiveInterventionFile.fromJson(
                  document.data(),
                ),
              )
              .toList();
          //no data found
          if (files.isEmpty) {
            if (Theme.of(context).brightness == Brightness.light) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/no_file_found_light.json",
                    repeat: false,
                  ),
                  Text(
                    "No $interventionType interventions files found",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/no_file_found_dark.json",
                    repeat: false,
                  ),
                  Text(
                    "No $interventionType interventions files found",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                //TO DO : create the UI for the card
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterventionFileViewPage(
                          interventionFileID: files[index].fileID,
                          interventionType: files[index].maintenanceType,
                          equipmentDiscipline: files[index].equipmentDiscipline,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            files[index].fileName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InterventionFileStatus(
                            status: files[index].fileStatus,
                          )
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Equipment:  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(files[index].equipmentTagName),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Discipline:  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(files[index].equipmentDiscipline),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Forecast:  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text('${files[index].forecast.toString()} days'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
