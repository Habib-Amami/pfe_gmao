import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../notifications/model/notification_model.dart';
import '../model/data_models/intervention_file_status.dart';
import '../model/intervention_file_model.dart';
import 'widgets/file_status_widgets/confirmed_status.dart';
import 'widgets/file_status_widgets/denied_status.dart';
import 'widgets/intervention_file_widgets/curative_file_widget.dart';
import 'widgets/intervention_file_widgets/preventive_file_widget.dart';

class InterventionFileValidationView extends StatefulWidget {
  final String interventionFileCreatorToken;
  final String interventionFileID;
  final String interventionType;
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentDiscipline;

  const InterventionFileValidationView({
    required this.interventionFileCreatorToken,
    required this.interventionFileID,
    required this.interventionType,
    required this.equipmentID,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    super.key,
  });

  @override
  State<InterventionFileValidationView> createState() =>
      _InterventionFileValidationView();
}

class _InterventionFileValidationView
    extends State<InterventionFileValidationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Intervention File Validation',
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
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
                child:
                    // If the intervention file is still in progress
                    data['fileStatus'] == interventionFileStatus[2]
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 100,
                                child: FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.primary),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: const Text(
                                            'Do you really want to validate this intervention file?',
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        InterventionFileModel()
                                                            .changeInterventionFileStatus(
                                                          equipmentID: widget
                                                              .equipmentID,
                                                          equipmentDiscipline:
                                                              widget
                                                                  .equipmentDiscipline,
                                                          interventionFileID: widget
                                                              .interventionFileID,
                                                          interventionType: widget
                                                              .interventionType,
                                                          newStatus:
                                                              interventionFileStatus[
                                                                  0],
                                                        );
                                                        NotificationsModel()
                                                            .sendNotificationToDevice(
                                                          deviceToken: widget
                                                              .interventionFileCreatorToken,
                                                          notificationTitle:
                                                              "Validation Update",
                                                          notificationBody:
                                                              "The intervention file you created for ${widget.equipmentTagName} was validated",
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Validate',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Validate',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Deny alert'),
                                          content: const Text(
                                            'Tell us why you denied this intervention file!',
                                          ),
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
                                                FilledButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        InterventionFileModel()
                                                            .changeInterventionFileStatus(
                                                          equipmentID: widget
                                                              .equipmentID,
                                                          equipmentDiscipline:
                                                              widget
                                                                  .equipmentDiscipline,
                                                          interventionFileID: widget
                                                              .interventionFileID,
                                                          interventionType: widget
                                                              .interventionType,
                                                          newStatus:
                                                              interventionFileStatus[
                                                                  1],
                                                        );
                                                        NotificationsModel()
                                                            .sendNotificationToDevice(
                                                          deviceToken: widget
                                                              .interventionFileCreatorToken,
                                                          notificationTitle:
                                                              "Validation Update",
                                                          notificationBody:
                                                              "The intervention file you created for ${widget.equipmentTagName} was denied",
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Deny',
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Deny',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : data['fileStatus'] == interventionFileStatus[0]
                            ? const ConfirmedState()
                            : const DeniedState(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
