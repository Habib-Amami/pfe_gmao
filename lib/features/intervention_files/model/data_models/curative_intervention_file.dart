class CurativeInterventionFile {
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  final String fileID;
  final String fileName;
  final String maintenanceType; //default value "Curative"
  final String criticity;
  final String breakDownType;
  final String breakDownDescription;
  final String startingDay;
  final String interventionTask;
  final bool mechanicalTechnician;
  final bool electricalTechnician;
  final bool instrumentTechnician;
  final List<String> spareParts;
  final List<String> tools;
  final String fileStatus;

  CurativeInterventionFile({
    required this.equipmentID,
    required this.equipmentTagName,
    required this.equipmentStatus,
    required this.equipmentDiscipline,
    required this.fileID,
    required this.fileName,
    required this.maintenanceType,
    required this.criticity,
    required this.breakDownType,
    required this.breakDownDescription,
    required this.startingDay,
    required this.interventionTask,
    required this.mechanicalTechnician,
    required this.electricalTechnician,
    required this.instrumentTechnician,
    required this.spareParts,
    required this.tools,
    required this.fileStatus,
  });

  // toJson method to convert object to JSON
  // toJson method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'equipmentID': equipmentID,
      'equipmentTagName': equipmentTagName,
      'equipmentStatus': equipmentStatus,
      'equipmentDiscipline': equipmentDiscipline,
      'fileID': fileID,
      'fileName': fileName,
      'criticity': criticity,
      'breakDownType': breakDownType,
      'breakDownDescription': breakDownDescription,
      'startingDay': startingDay,
      'interventionTask': interventionTask,
      'mechanicalTechnician': mechanicalTechnician,
      'electricalTechnician': electricalTechnician,
      'instrumentTechnician': instrumentTechnician,
      'spareParts': spareParts,
      'tools': tools,
      'fileStatus': fileStatus,
    };
  }

  // fromJson method to create object from JSON
  factory CurativeInterventionFile.fromJson(Map<String, dynamic> json) {
    return CurativeInterventionFile(
      equipmentID: json['equipmentID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentStatus: json['equipmentStatus'],
      equipmentDiscipline: json['equipmentDiscipline'],
      fileID: json['fileID'],
      fileName: json['fileName'],
      maintenanceType: json['maintenanceType'],
      criticity: json['criticity'],
      breakDownType: json['breakDownType'],
      breakDownDescription: json['breakDownDescription'],
      startingDay: json['startingDay'],
      interventionTask: json['interventionTask'],
      mechanicalTechnician: json['mechanicalTechnician'],
      electricalTechnician: json['electricalTechnician'],
      instrumentTechnician: json['instrumentTechnician'],
      spareParts: List<String>.from(json['spareParts']),
      tools: List<String>.from(json['tools']),
      fileStatus: json['fileStatus'],
    );
  }
}
