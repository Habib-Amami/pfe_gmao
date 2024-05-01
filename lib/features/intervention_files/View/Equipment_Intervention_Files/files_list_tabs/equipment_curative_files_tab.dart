import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../firebase/cloud_firestore_references.dart';
import '../../../model/data_models/curative_intervention_file.dart';
import '../../widgets/curative_intervention_file_card.dart';

class EquipmentCurativeFilesTab extends StatelessWidget {
  final String equipmentID;
  const EquipmentCurativeFilesTab({
    super.key,
    required this.equipmentID,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(equipmentCollectionRef)
          .doc(equipmentID)
          .collection("curative_intervention_files")
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
        // data found
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
                  "assets/animations/no_IF_ligth.json",
                  repeat: false,
                ),
                Text(
                  "No Curative interventions files found",
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
                  "assets/animations/no_IF_dark.json",
                  repeat: false,
                ),
                Text(
                  "No Curative interventions files found",
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
              return CurativeInterventionFileCard(
                fileName: files[index].fileName,
                fileStatus: files[index].fileStatus,
                equipmentDiscipline: files[index].equipmentDiscipline,
                interventionTask: files[index].interventionTask,
                startingDay: files[index].startingDay,
                spareParts: files[index].spareParts,
                tools: files[index].tools,
                isMechanicalTechnicianSelected:
                    files[index].mechanicalTechnician,
                isElectricalTechnicianSelected:
                    files[index].electricalTechnician,
                isInstrumentTechnicianSelected:
                    files[index].instrumentTechnician,
                breakDownDescription: files[index].breakDownDescription,
                breakDownType: files[index].breakDownType,
                criticity: files[index].criticity,
              );
            },
          ),
        );
      },
    );
  }
}
