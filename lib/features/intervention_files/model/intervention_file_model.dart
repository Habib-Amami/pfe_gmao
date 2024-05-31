import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firebase/cloud_firestore_references.dart';
import 'constants/intervention_types_list.dart';
import 'data_models/curative_intervention_file.dart';
import 'data_models/preventive_intervention_file.dart';
import 'data_models/spare_part.dart';
import 'data_models/tool.dart';

class InterventionFileModel {
  //add function
  Future<void> addInterventionFileDB({
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
    //creating a FireStore instance
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    //creating a batch writer
    WriteBatch batch = fireStore.batch();

    //creating list for tools and spare parts names
    List<String> toolsNames = [];
    List<String> sparePartsNames = [];

    //getting all the tools names from the given tools list
    for (var i = 0; i < tools.length; i++) {
      toolsNames.add(tools[i].name);
    }

    //getting all the spare parts from the given spare parts list
    for (var i = 0; i < spareParts.length; i++) {
      sparePartsNames.add(spareParts[i].name);
    }
    //maintenance type "Curative"
    if (maintenanceType == interventionTypes[0]) {
      CurativeInterventionFile interventionFile = CurativeInterventionFile(
        creatorID: creatorID,
        createdAt: createdAt,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentStatus: equipmentStatus,
        equipmentDiscipline: equipmentDiscipline,
        fileID: fileID,
        fileName: fileName,
        maintenanceType: maintenanceType,
        criticity: criticity,
        breakDownType: breakDownType,
        breakDownDescription: breakDownDescription,
        startingDay: startingDay,
        interventionTask: interventionTask,
        mechanicalTechnician: mechanicalTechnician,
        electricalTechnician: electricalTechnician,
        instrumentTechnician: instrumentTechnician,
        spareParts: sparePartsNames,
        tools: toolsNames,
        fileStatus: fileStatus,
        equipmentName: equipmentTagName,
      );
      //adding data to the equipment curative intervention files
      batch.set(
        fireStore
            .collection(equipmentCollectionRef)
            .doc(equipmentID)
            .collection("${interventionTypes[0]}_intervention_files")
            .doc(fileID),
        interventionFile.toJson(),
      );
      //adding data to globle intervention files collection
      batch.set(
        fireStore
            .collection(
              "collective_${equipmentDiscipline}_${interventionTypes[0]}_intervention_files",
            )
            .doc(fileID),
        interventionFile.toJson(),
      );
      // Commit the batch
      await batch.commit();
    } else {
      //maintenance type "Preventive"
      PreventiveInterventionFile interventionFile = PreventiveInterventionFile(
        creatorID: creatorID,
        createdAt: createdAt,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentStatus: equipmentStatus,
        equipmentDiscipline: equipmentDiscipline,
        fileID: fileID,
        fileName: fileName,
        maintenanceType: maintenanceType,
        forecast: forecast,
        startingDay: startingDay,
        interventionTask: interventionTask,
        mechanicalTechnician: mechanicalTechnician,
        electricalTechnician: electricalTechnician,
        instrumentTechnician: instrumentTechnician,
        spareParts: sparePartsNames,
        tools: toolsNames,
        fileStatus: fileStatus,
      );
      //adding data to the equipment preventive intervention files
      batch.set(
        fireStore
            .collection(equipmentCollectionRef)
            .doc(equipmentID)
            .collection("${interventionTypes[1]}_intervention_files")
            .doc(fileID),
        interventionFile.toJson(),
      );
      //adding data to globle intervention files collection
      batch.set(
        fireStore
            .collection(
              "collective_${equipmentDiscipline}_${interventionTypes[1]}_intervention_files",
            )
            .doc(fileID),
        interventionFile.toJson(),
      );
      // Commit the batch
      await batch.commit();
    }
  }

  //change intervention file status
  Future<void> changeInterventionFileStatusDB({
    required String equipmentID,
    required String equipmentDiscipline,
    required String interventionFileID,
    required String interventionType,
    required String newStatus,
  }) async {
    //creating a FireStore instance
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    //creating a batch for updating the intervention file status
    WriteBatch batch = FirebaseFirestore.instance.batch();

    //getting the reference of the file in the equipment collection
    DocumentReference fileEquipmentCollection = fireStore
        .collection(equipmentCollectionRef)
        .doc(equipmentID)
        .collection("${interventionType}_intervention_files")
        .doc(interventionFileID);
    //updating file in the equipment collection with the new status
    batch.update(fileEquipmentCollection, {'fileStatus': newStatus});

    //getting the file reference in the collective file collection
    //using the discipline and the intervention type
    DocumentReference fileCollectiveCollection = fireStore
        .collection(
          "collective_${equipmentDiscipline}_${interventionType}_intervention_files",
        )
        .doc(interventionFileID);

    //updating the file status in the collective files collection
    batch.update(fileCollectiveCollection, {'fileStatus': newStatus});

    //commiting batch
    batch.commit();
  }
}
