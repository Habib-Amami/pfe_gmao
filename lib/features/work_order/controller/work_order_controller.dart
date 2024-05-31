import 'package:flutter/material.dart';

import '../model/work_order_model.dart';

class WorkorderController {
  final WorkOrderModel model = WorkOrderModel();

  //methode to add a work order to database
  Future<void> addWorkOrder({
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
    try {
      model.addWorkOrderDB(
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
    } catch (e) {
      rethrow;
    }
  }

  ////Methode to update the work order status depending on the case
  Future<void> updateWorkOrderStatus({
    required String workOrderID,
    required String newStatus,
    required String creatorID,
    required String technicianID,
    required String interventionID,
  }) async {
    try {
      model.updateWorkOrderStatusDB(
        workOrderID: workOrderID,
        newStatus: newStatus,
        creatorID: creatorID,
        technicianID: technicianID,
        interventionID: interventionID,
      );
    } catch (e) {
      rethrow;
    }
  }
}
