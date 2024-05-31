import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/notifications/controller/notification_controller.dart';
import 'package:uuid/uuid.dart';

import '../../interventions/controller/interventions_controller.dart';
import '../../interventions/model/constants/intervention_status.dart';
import '../../notifications/model/notification_model.dart';
import '../controller/intervention_file_controller.dart';
import '../model/constants/intervention_types_list.dart';
import '../model/data_models/curative_intervention_file.dart';
import '../model/data_models/intervention_file_status.dart';
import '../model/data_models/preventive_intervention_file.dart';
import 'widgets/file_status_rectangular_widgets/confirmed_status.dart';
import 'widgets/file_status_rectangular_widgets/denied_status.dart';
import 'widgets/intervention_file_widgets/curative_file_widget.dart';
import 'widgets/intervention_file_widgets/preventive_file_widget.dart';

class InterventionFileValidationView extends StatefulWidget {
  final String interventionFileCreatorID;
  final String interventionFileCreatorToken;
  final String interventionFileID;
  final String interventionType;
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentDiscipline;

  const InterventionFileValidationView({
    required this.interventionFileCreatorID,
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
  final InterventionFileController interventionFileController =
      InterventionFileController();

  final InterventionsController interventionController =
      InterventionsController();

  final NotificationController notificationController =
      NotificationController();

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
          // genearte the ui based on the type of the intervention
          //"Curative"
          if (widget.interventionType == interventionTypes[0]) {
            //mapping the document to a curative file
            CurativeInterventionFile interventionFile =
                CurativeInterventionFile.fromJson(snapshot.data!.data()!);

            //list of tehnicians taht will execute the interevntion
            List technicians = [];
            if (interventionFile.mechanicalTechnician) {
              technicians.add('Mechanical Technician');
            }
            if (interventionFile.electricalTechnician) {
              technicians.add('Electrical Technician');
            }
            if (interventionFile.instrumentTechnician) {
              technicians.add('Instrument Technician');
            }
            String technicianList = technicians.join(' - ');

            //joining the spare parts of the intervention file in one string
            String spareParts = interventionFile.spareParts.join(' - ');

            //joining the tools of the intervention file in one string
            String tools = interventionFile.tools.join(' - ');

            return ListView(
              children: [
                SingleChildScrollView(
                  child: CurativeInterventionFileView(
                    equipmentName: widget.equipmentTagName,
                    equipmentStatus: interventionFile.equipmentStatus,
                    equipmentDiscipline: widget.equipmentDiscipline,
                    fileName: interventionFile.fileName,
                    interventionType: widget.interventionType,
                    criticality: interventionFile.criticity,
                    breakdownType: interventionFile.breakDownType,
                    technicians: technicianList,
                    startingDay: interventionFile.startingDay,
                    tools: tools,
                    spareParts: spareParts,
                    task: interventionFile.interventionTask,
                    breakdownDescription: interventionFile.breakDownDescription,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 25),
                  child:
                      // If the intervention file is still in progress
                      interventionFile.fileStatus == interventionFileStatus[2]
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      String notificationID =
                                                          const Uuid().v4();
                                                      setState(
                                                        () {
                                                          interventionFileController
                                                              .changeInterventionFileStatus(
                                                            equipmentID: widget
                                                                .equipmentID,
                                                            equipmentDiscipline:
                                                                widget
                                                                    .equipmentDiscipline,
                                                            interventionFileID:
                                                                widget
                                                                    .interventionFileID,
                                                            interventionType: widget
                                                                .interventionType,
                                                            newStatus:
                                                                interventionFileStatus[
                                                                    0],
                                                          );
                                                        },
                                                      );
                                                      notificationController
                                                          .sendNotificationToDevice(
                                                        deviceToken: widget
                                                            .interventionFileCreatorToken,
                                                        notificationTitle:
                                                            "Validation Update",
                                                        notificationBody:
                                                            "The intervention file you created for ${widget.equipmentTagName} was validated",
                                                      );
                                                      NotificationsModel()
                                                          .addValidationNotificationUpdateDB(
                                                        notificationID:
                                                            notificationID,
                                                        notificationTitle:
                                                            "Validation Update",
                                                        notificationBody:
                                                            "The intervention file you created for ${widget.equipmentTagName} was validated",
                                                        interventionFileCreatorID:
                                                            widget
                                                                .interventionFileCreatorID,
                                                        interventionFileCreatorToken:
                                                            widget
                                                                .interventionFileCreatorToken,
                                                        interventionFileID: widget
                                                            .interventionFileID,
                                                        interventionType: widget
                                                            .interventionType,
                                                        equipmentID:
                                                            widget.equipmentID,
                                                        equipmentTagName: widget
                                                            .equipmentTagName,
                                                        equipmentDiscipline: widget
                                                            .equipmentDiscipline,
                                                      );
                                                      interventionController
                                                          .addCurativeIntervention(
                                                        startDate:
                                                            interventionFile
                                                                .startingDay,
                                                        interventionFileID: widget
                                                            .interventionFileID,
                                                        equipmentTagName: widget
                                                            .equipmentTagName,
                                                        equipmentDiscipline: widget
                                                            .equipmentDiscipline,
                                                        mechanicalTechnician:
                                                            interventionFile
                                                                .mechanicalTechnician,
                                                        electricalTechnician:
                                                            interventionFile
                                                                .electricalTechnician,
                                                        instrumentTechnician:
                                                            interventionFile
                                                                .instrumentTechnician,
                                                        spareParts:
                                                            interventionFile
                                                                .spareParts,
                                                        tools: interventionFile
                                                            .tools,
                                                        interventionStatus:
                                                            interventionStatus[
                                                                0],
                                                        interventionTask:
                                                            interventionFile
                                                                .interventionTask,
                                                      );

                                                      Navigator.pop(context);
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      String notificationID =
                                                          const Uuid().v4();
                                                      setState(
                                                        () {
                                                          interventionFileController
                                                              .changeInterventionFileStatus(
                                                            equipmentID: widget
                                                                .equipmentID,
                                                            equipmentDiscipline:
                                                                widget
                                                                    .equipmentDiscipline,
                                                            interventionFileID:
                                                                widget
                                                                    .interventionFileID,
                                                            interventionType: widget
                                                                .interventionType,
                                                            newStatus:
                                                                interventionFileStatus[
                                                                    1],
                                                          );
                                                          notificationController
                                                              .sendNotificationToDevice(
                                                            deviceToken: widget
                                                                .interventionFileCreatorToken,
                                                            notificationTitle:
                                                                "Validation Update",
                                                            notificationBody:
                                                                "The intervention file you created for ${widget.equipmentTagName} was denied",
                                                          );
                                                          NotificationsModel()
                                                              .addValidationNotificationUpdateDB(
                                                            notificationID:
                                                                notificationID,
                                                            notificationTitle:
                                                                "Validation Update",
                                                            notificationBody:
                                                                "The intervention file you created for ${widget.equipmentTagName} was denied",
                                                            interventionFileCreatorID:
                                                                widget
                                                                    .interventionFileCreatorID,
                                                            interventionFileCreatorToken:
                                                                widget
                                                                    .interventionFileCreatorToken,
                                                            interventionFileID:
                                                                widget
                                                                    .interventionFileID,
                                                            interventionType: widget
                                                                .interventionType,
                                                            equipmentID: widget
                                                                .equipmentID,
                                                            equipmentTagName: widget
                                                                .equipmentTagName,
                                                            equipmentDiscipline:
                                                                widget
                                                                    .equipmentDiscipline,
                                                          );
                                                          Navigator.pop(
                                                              context);
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
                          : interventionFile.fileStatus ==
                                  interventionFileStatus[0]
                              ? const ConfirmedState()
                              : const DeniedState(),
                ),
              ],
            );
          } else {
            //mapping the document to a Preventive file
            PreventiveInterventionFile interventionFile =
                PreventiveInterventionFile.fromJson(snapshot.data!.data()!);

            //list of tehnicians taht will execute the interevntion
            List technicians = [];
            if (interventionFile.mechanicalTechnician) {
              technicians.add('Mechanical Technician');
            }
            if (interventionFile.electricalTechnician) {
              technicians.add('Electrical Technician');
            }
            if (interventionFile.instrumentTechnician) {
              technicians.add('Instrument Technician');
            }
            String technicianList = technicians.join(' - ');

            //joining the spare parts of the intervention file in one string
            String spareParts = interventionFile.spareParts.join(' - ');

            //joining the tools of the intervention file in one string
            String tools = interventionFile.tools.join(' - ');
            return ListView(
              children: [
                SingleChildScrollView(
                  child: PreventiveFile(
                    spareParts: spareParts,
                    task: interventionFile.interventionTask,
                    startingDay: interventionFile.startingDay,
                    forecast: interventionFile.forecast,
                    equipmentName: interventionFile.equipmentTagName,
                    equipmentStatus: interventionFile.equipmentStatus,
                    equipmentDiscipline: widget.equipmentDiscipline,
                    fileName: interventionFile.fileStatus,
                    interventionType: widget.interventionType,
                    technicians: technicianList,
                    tools: tools,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 25),
                  child:
                      // If the intervention file is still in progress
                      interventionFile.fileStatus == interventionFileStatus[2]
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilledButton(
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
                                                    String notificationID =
                                                        const Uuid().v4();
                                                    setState(
                                                      () {
                                                        interventionFileController
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
                                                      },
                                                    );
                                                    notificationController
                                                        .sendNotificationToDevice(
                                                      deviceToken: widget
                                                          .interventionFileCreatorToken,
                                                      notificationTitle:
                                                          "Validation Update",
                                                      notificationBody:
                                                          "The intervention file you created for ${widget.equipmentTagName} was validated",
                                                    );
                                                    notificationController
                                                        .addValidationNotificationUpdateDB(
                                                      notificationID:
                                                          notificationID,
                                                      notificationTitle:
                                                          "Validation Update",
                                                      notificationBody:
                                                          "The intervention file you created for ${widget.equipmentTagName} was validated",
                                                      interventionFileCreatorID:
                                                          widget
                                                              .interventionFileCreatorID,
                                                      interventionFileCreatorToken:
                                                          widget
                                                              .interventionFileCreatorToken,
                                                      interventionFileID: widget
                                                          .interventionFileID,
                                                      interventionType: widget
                                                          .interventionType,
                                                      equipmentID:
                                                          widget.equipmentID,
                                                      equipmentTagName: widget
                                                          .equipmentTagName,
                                                      equipmentDiscipline: widget
                                                          .equipmentDiscipline,
                                                    );
                                                    interventionController
                                                        .addPreventiveInterventions(
                                                      startDate:
                                                          interventionFile
                                                              .startingDay,
                                                      forecast: interventionFile
                                                          .forecast,
                                                      interventionFileID: widget
                                                          .interventionFileID,
                                                      equipmentTagName: widget
                                                          .equipmentTagName,
                                                      equipmentDiscipline: widget
                                                          .equipmentDiscipline,
                                                      mechanicalTechnician:
                                                          interventionFile
                                                              .mechanicalTechnician,
                                                      electricalTechnician:
                                                          interventionFile
                                                              .electricalTechnician,
                                                      instrumentTechnician:
                                                          interventionFile
                                                              .instrumentTechnician,
                                                      spareParts:
                                                          interventionFile
                                                              .spareParts,
                                                      tools: interventionFile
                                                          .tools,
                                                      interventionStatus:
                                                          interventionFileStatus[
                                                              0],
                                                      interventionTask:
                                                          interventionFile
                                                              .interventionTask,
                                                    );

                                                    Navigator.pop(context);
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      String notificationID =
                                                          const Uuid().v4();
                                                      setState(
                                                        () {
                                                          interventionFileController
                                                              .changeInterventionFileStatus(
                                                            equipmentID: widget
                                                                .equipmentID,
                                                            equipmentDiscipline:
                                                                widget
                                                                    .equipmentDiscipline,
                                                            interventionFileID:
                                                                widget
                                                                    .interventionFileID,
                                                            interventionType: widget
                                                                .interventionType,
                                                            newStatus:
                                                                interventionFileStatus[
                                                                    1],
                                                          );
                                                          notificationController
                                                              .sendNotificationToDevice(
                                                            deviceToken: widget
                                                                .interventionFileCreatorToken,
                                                            notificationTitle:
                                                                "Validation Update",
                                                            notificationBody:
                                                                "The intervention file you created for ${widget.equipmentTagName} was denied",
                                                          );
                                                          NotificationsModel()
                                                              .addValidationNotificationUpdateDB(
                                                            notificationID:
                                                                notificationID,
                                                            notificationTitle:
                                                                "Validation Update",
                                                            notificationBody:
                                                                "The intervention file you created for ${widget.equipmentTagName} was denied",
                                                            interventionFileCreatorID:
                                                                widget
                                                                    .interventionFileCreatorID,
                                                            interventionFileCreatorToken:
                                                                widget
                                                                    .interventionFileCreatorToken,
                                                            interventionFileID:
                                                                widget
                                                                    .interventionFileID,
                                                            interventionType: widget
                                                                .interventionType,
                                                            equipmentID: widget
                                                                .equipmentID,
                                                            equipmentTagName: widget
                                                                .equipmentTagName,
                                                            equipmentDiscipline:
                                                                widget
                                                                    .equipmentDiscipline,
                                                          );
                                                          Navigator.pop(
                                                              context);
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
                          : interventionFile.fileStatus ==
                                  interventionFileStatus[0]
                              ? const ConfirmedState()
                              : const DeniedState(),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
