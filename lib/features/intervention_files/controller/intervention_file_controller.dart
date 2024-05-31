import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/data_models/spare_part.dart';
import '../model/data_models/tool.dart';
import '../model/intervention_file_model.dart';

class InterventionFileController {
  //creating an instance of intervention file model
  final InterventionFileModel _interventionFileModel = InterventionFileModel();

  //add methode
  Future<void> addInterventionFile({
    required String creatorID,
    required Timestamp createdAt,
    required String equipmentID,
    required String equipmentTagName,
    required String equipmentStatus,
    required String equipmentDiscipline,
    required String fileID,
    required String fileName,
    required String maintenanceType,
    required String startingDay,
    required String interventionTask,
    required bool mechanicalTechnician,
    required bool electricalTechnician,
    required bool instrumentTechnician,
    required List<SparePart> spareParts,
    required List<Tool> tools,
    required String fileStatus,

    ///Preventive intervention unique values
    required int forecast,

    ///Curative intervention unique values
    required String criticity,
    required String breakDownType,
    required String breakDownDescription,
  }) async {
    try {
      _interventionFileModel.addInterventionFileDB(
        creatorID: creatorID,
        createdAt: createdAt,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentStatus: equipmentStatus,
        equipmentDiscipline: equipmentDiscipline,
        fileID: fileID,
        fileName: fileName,
        maintenanceType: maintenanceType,
        startingDay: startingDay,
        interventionTask: interventionTask,
        mechanicalTechnician: mechanicalTechnician,
        electricalTechnician: electricalTechnician,
        instrumentTechnician: instrumentTechnician,
        spareParts: spareParts,
        tools: tools,
        fileStatus: fileStatus,
        forecast: forecast,
        criticity: criticity,
        breakDownType: breakDownType,
        breakDownDescription: breakDownDescription,
      );
    } catch (e) {
      rethrow;
    }
  }

  //change intervention file status
  Future<void> changeInterventionFileStatus({
    required String equipmentID,
    required String equipmentDiscipline,
    required String interventionFileID,
    required String interventionType,
    required String newStatus,
  }) async {
    try {
      _interventionFileModel.changeInterventionFileStatusDB(
        equipmentID: equipmentID,
        equipmentDiscipline: equipmentDiscipline,
        interventionFileID: interventionFileID,
        interventionType: interventionType,
        newStatus: newStatus,
      );
    } catch (e) {
      rethrow;
    }
  }
}
