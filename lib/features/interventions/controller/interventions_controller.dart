import 'package:pfe_gmao/features/interventions/model/intervention_model.dart';

class InterventionsController {
  final InterventionModel model = InterventionModel();

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
    try {
      model.addPreventiveInterventionsDB(
          startDate: startDate,
          forecast: forecast,
          interventionFileID: interventionFileID,
          equipmentTagName: equipmentTagName,
          equipmentDiscipline: equipmentDiscipline,
          mechanicalTechnician: mechanicalTechnician,
          electricalTechnician: electricalTechnician,
          instrumentTechnician: instrumentTechnician,
          spareParts: spareParts,
          tools: tools,
          interventionStatus: interventionStatus,
          interventionTask: interventionTask);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCurativeIvention({
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
    try {
      model.addCurativeIventionDB(
          startDate: startDate,
          interventionFileID: interventionFileID,
          equipmentTagName: equipmentTagName,
          equipmentDiscipline: equipmentDiscipline,
          mechanicalTechnician: mechanicalTechnician,
          electricalTechnician: electricalTechnician,
          instrumentTechnician: instrumentTechnician,
          spareParts: spareParts,
          tools: tools,
          interventionStatus: interventionStatus,
          interventionTask: interventionTask);
    } catch (e) {
      rethrow;
    }
  }
}
