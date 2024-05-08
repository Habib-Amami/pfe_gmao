import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../intervention_files/model/constants/intervention_types_list.dart';
import 'data_models/intervntion.dart';

class InterventionModel {
  Future<void> addPreventiveInterventions({
    required String startDate,
    required int forecast,
    required String interventionFileID,
    required String equipmentTagName,
    required String equipmentDiscipline,
  }) async {
    String interventionType = interventionTypes[1]; // "Preventive"
    //creating a firestore insatance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //creating a batch writer
    WriteBatch batch = firestore.batch();
    //foramting the starting day to a DateTime object
    DateTime startingDate = DateFormat("MM/dd/yyyy").parse(startDate);
    if (kDebugMode) {
      print(startingDate.toString());
    }

    // Calculate the interval between interventions
    int interval = (365 / forecast).ceil();

    for (int i = 0; i < interval; i++) {
      //generating an intervntion id
      String interventionID = const Uuid().v4();
      //creating the intervention
      Intervention intervention = Intervention(
        interventionID: interventionID,
        interventionDate: startingDate,
        interventionType: interventionType,
        interventionFileID: interventionFileID,
        equipmentTagName: equipmentTagName,
        equipmentDiscipline: equipmentDiscipline,
      );
      //adding intervetion to firebase
      batch.set(
        firestore.collection("interventions").doc(interventionID),
        intervention.toJson(),
      );
      //Add forecast days to the start date to get the next date
      startingDate = startingDate.add(
        Duration(days: forecast),
      );
    }
    //commiting batch
    await batch.commit();
  }

  Future<void> addCurativeIventions({
    required String startDate,
    required String interventionFileID,
    required String equipmentTagName,
    required String equipmentDiscipline,
  }) async {
    String interventionType = interventionTypes[0]; // "Curative"
    //creating a firestore insatance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //foramting the starting day to a DateTime object
    DateTime startingDate = DateFormat("MM/dd/yyyy").parse(startDate);
    if (kDebugMode) {
      print(startingDate.toString());
    }

    //generating an intervntion id
    String interventionID = const Uuid().v4();
    //creating the intervention
    Intervention intervention = Intervention(
      interventionID: interventionID,
      interventionDate: startingDate,
      interventionType: interventionType,
      interventionFileID: interventionFileID,
      equipmentTagName: equipmentTagName,
      equipmentDiscipline: equipmentDiscipline,
    );
    //adding intervetion to firebase
    await firestore
        .collection("interventions")
        .doc(interventionID)
        .set(intervention.toJson());
  }
}
