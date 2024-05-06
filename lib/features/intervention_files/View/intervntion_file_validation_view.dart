import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention%20file%20widgets/confirmed_status.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention%20file%20widgets/curative_file_widget.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention%20file%20widgets/denied_status.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention%20file%20widgets/in_progress_status.dart';
import 'package:pfe_gmao/features/intervention_files/model/data_models/intervention_file_status.dart';

import 'widgets/intervention file widgets/preventive_file_widget.dart';

class InterventionFileValidationView extends StatefulWidget {
  final String interventionFileID;
  final String interventionType;
  final String equipmentID;
  final String equipmentDiscipline;

  const InterventionFileValidationView({
    required this.interventionFileID,
    required this.interventionType,
    required this.equipmentDiscipline,
    required this.equipmentID,
    super.key,
  });

  @override
  State<InterventionFileValidationView> createState() =>
      _InterventionFileValitionView();
}

class _InterventionFileValitionView
    extends State<InterventionFileValidationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Intervention File Validation',
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
                    Text("Loading Intervention File ...")
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
                      : CurativeInterventionFile(
                          equipmentName: data['equipmentTagName'],
                          equipmentStatus: data['equipmentStatus'],
                          equipmentDiscipline: widget.equipmentDiscipline,
                          fileName: data['fileName'],
                          interventionType: widget.interventionType,
                          criticality: data['criticity'],
                          breakdownType: data['breakDownType'],
                          technicians: technicianList,
                          startingDay: data['startingDay'],
                          tools: tools,
                          spareParts: spareParts,
                          task: data['interventionTask'],
                          breakdownDescription: data['breakDownDescription'],
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 25),
                  child:
                      // If the intervention file is still in progress
                      data['fileStatus'] == interventionFileStatus[2]
                          ? const InProgressState()
                          : data['fileStatus'] == interventionFileStatus[0]
                              ? const ConfirmedState()
                              : const DeniedState(),
                ),
              ],
            );
          })),
    );
  }
}
