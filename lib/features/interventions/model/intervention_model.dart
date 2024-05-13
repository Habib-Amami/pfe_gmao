import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../intervention_files/model/constants/intervention_types_list.dart';
import 'data_models/intervention.dart';

class InterventionModel {
  Future<void> addPreventiveInterventions({
    required String startDate,
    required int forecast,
    required String interventionFileID,
    required String equipmentTagName,
    required String equipmentDiscipline,
    required bool mechanicalTechnician,
    required bool electricalTechnician,
    required bool instrumentTechnician,
    required List<String> spareParts,
    required List<String> tools,
    required String interventionStatus,
    required String interventionTask,
  }) async {
    String interventionType = interventionTypes[1]; // "Preventive"
    //creating a firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //creating a batch writer
    WriteBatch batch = firestore.batch();
    //formatting the starting day to a DateTime object
    DateTime startingDate = DateFormat("dd/MM/yyyy").parse(startDate);
    if (kDebugMode) {
      print(startingDate.toString());
    }

    // Calculate the interval between interventions
    int interval = (365 / forecast).ceil();

    for (int i = 0; i < interval; i++) {
      //generating an intervention id
      String interventionID = const Uuid().v4();
      //creating the intervention
      Intervention intervention = Intervention(
        interventionID: interventionID,
        interventionDate: startingDate,
        interventionType: interventionType,
        interventionFileID: interventionFileID,
        equipmentTagName: equipmentTagName,
        equipmentDiscipline: equipmentDiscipline,
        mechanicalTechnician: mechanicalTechnician,
        electricalTechnician: electricalTechnician,
        instrumentTechnician: instrumentTechnician,
        spareParts: spareParts,
        tools: tools,
        interventionStatus: interventionStatus,
        interventionTask: interventionTask,
      );
      //adding intervention to firebase
      batch.set(
        firestore.collection("interventions").doc(interventionID),
        intervention.toJson(),
      );
      //Add forecast days to the start date to get the next date
      startingDate = startingDate.add(
        Duration(days: forecast),
      );
    }
    //committing batch
    await batch.commit();
  }

  Future<void> addCurativeIventions({
    required String startDate,
    required String interventionFileID,
    required String equipmentTagName,
    required String equipmentDiscipline,
    required bool mechanicalTechnician,
    required bool electricalTechnician,
    required bool instrumentTechnician,
    required List<String> spareParts,
    required List<String> tools,
    required String interventionStatus,
    required String interventionTask,
  }) async {
    String interventionType = interventionTypes[0]; // "Curative"
    //creating a firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //formatting the starting day to a DateTime object
    DateTime startingDate = DateFormat("dd/MM/yyyy").parse(startDate);
    if (kDebugMode) {
      print(startingDate.toString());
    }

    //generating an intervention id
    String interventionID = const Uuid().v4();
    //creating the intervention
    Intervention intervention = Intervention(
      interventionID: interventionID,
      interventionDate: startingDate,
      interventionType: interventionType,
      interventionFileID: interventionFileID,
      equipmentTagName: equipmentTagName,
      equipmentDiscipline: equipmentDiscipline,
      mechanicalTechnician: mechanicalTechnician,
      electricalTechnician: electricalTechnician,
      instrumentTechnician: instrumentTechnician,
      spareParts: spareParts,
      tools: tools,
      interventionStatus: interventionStatus,
      interventionTask: interventionTask,
    );
    //adding intervention to firebase
    await firestore
        .collection("interventions")
        .doc(interventionID)
        .set(intervention.toJson());
  }
}
