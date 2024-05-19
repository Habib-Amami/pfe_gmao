import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../interventions/model/constants/intervention_status.dart';
import 'data_models/work_order.dart';

class WorkOrderModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWorkOrderDB({
    required String workorderID,
    required String workorderStatus,
    required String workorderCreatorID,
    required String workorderCreatorUserName,
    required String workorderCreatorToken,
    required String interventionID,
    required String interventionType,
    required String interventionFileID,
    required String equipmentTagName,
    required String equipmentDiscipline,
    required String technicianID,
    required String technicianUserName,
    required String technicianToken,
    required List<String> tools,
    required List<String> spareParts,
    required DateTime executionDay,
    required TimeOfDay startTime,
    required TimeOfDay finishTime,
  }) async {
    //Creating a batch write
    WriteBatch batch = firestore.batch();
    //Creating a wWorkOrder object
    WorkOrder order = WorkOrder(
      workorderID: workorderID,
      workorderStatus: workorderStatus,
      workorderCreatorID: workorderCreatorID,
      workorderCreatorUserName: workorderCreatorUserName,
      workorderCreatorToken: workorderCreatorToken,
      interventionID: interventionID,
      interventionType: interventionType,
      interventionFileID: interventionFileID,
      equipmentTagName: equipmentTagName,
      equipmentDiscipline: equipmentDiscipline,
      technicianID: technicianID,
      technicianUserName: technicianUserName,
      technicianToken: technicianToken,
      tools: tools,
      spareParts: spareParts,
      executionDay: executionDay,
      startTime: startTime,
      finishTime: finishTime,
    );
    //Step 1 : change the intervention status to 'In Progress'
    batch.update(
      firestore.collection("interventions").doc(interventionID),
      {"interventionStatus": interventionStatus[1]},
    );
    //Step 2 : add work order to the selecetd engineer
    batch.set(
      firestore
          .collection(userCollectionRef)
          .doc(technicianID)
          .collection("work_order")
          .doc(workorderID),
      order.toJson(),
    );
    //Step : 3 add work order to the admin
    batch.set(
      firestore
          .collection(userCollectionRef)
          .doc(workorderCreatorID)
          .collection("work_order")
          .doc(workorderID),
      order.toJson(),
    );
    //commiting the batch
    await batch.commit();
  }
}
