import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../interventions/model/constants/intervention_status.dart';
import 'constants/work_order_status.dart';
import 'data_models/work_order.dart';

class WorkOrderModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //methode to add a work order to database
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
    required List<String> steps,
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
      steps: steps,
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
    //Step 2 : add work order to the selected engineer
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
    //committing the batch
    await batch.commit();
  }

  //Methode to update the work order status depending on the case
  Future<void> updateWorkOrderStatusDB({
    required String workOrderID,
    required String newStatus,
    required String creatorID,
    required String technicianID,
    required String interventionID,
  }) async {
    // Reference to the work order in the creator's document
    DocumentReference creatorWorkOrderRef = firestore
        .collection('users')
        .doc(creatorID)
        .collection('work_order')
        .doc(workOrderID);

    // Reference to the work order in the technician's document
    DocumentReference technicianWorkOrderRef = firestore
        .collection('users')
        .doc(technicianID)
        .collection('work_order')
        .doc(workOrderID);

    //Use a WriteBatch to perform both updates atomically
    WriteBatch batch = firestore.batch();

    if (newStatus == workOrderStatus[3]) {
      // Update the status in both documents
      batch.update(creatorWorkOrderRef, {'workorderStatus': newStatus});
      batch.update(technicianWorkOrderRef, {'workorderStatus': newStatus});
      // change the intervention status to 'In Progress'
      batch.update(
        firestore.collection("interventions").doc(interventionID),
        {"interventionStatus": interventionStatus[2]},
      );
    } else {
      // Update the status in both documents
      batch.update(creatorWorkOrderRef, {'workorderStatus': newStatus});
      batch.update(technicianWorkOrderRef, {'workorderStatus': newStatus});
    }

    // Commit the batch
    await batch.commit();
  }
}
