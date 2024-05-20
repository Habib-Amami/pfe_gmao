class Intervention {
  final String interventionID;
  final String interventionTask;
  final DateTime interventionDate;
  final String interventionType;
  final String interventionStatus;

  final String interventionFileID;

  final String equipmentTagName;
  final String equipmentDiscipline;

  final bool mechanicalTechnician;
  final bool electricalTechnician;
  final bool instrumentTechnician;

  final List<String> spareParts;
  final List<String> tools;

  Intervention({
    required this.interventionID,
    required this.interventionTask,
    required this.interventionDate,
    required this.interventionType,
    required this.interventionStatus,
    required this.interventionFileID,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.mechanicalTechnician,
    required this.electricalTechnician,
    required this.instrumentTechnician,
    required this.spareParts,
    required this.tools,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      interventionID: json['interventionID'] ?? '',
      interventionDate: DateTime.parse(
          json['interventionDate'] ?? DateTime.now().toIso8601String()),
      interventionType: json['interventionType'] ?? '',
      interventionFileID: json['interventionFileID'] ?? '',
      equipmentTagName: json['equipmentTagName'] ?? '',
      equipmentDiscipline: json['equipmentDiscipline'] ?? '',
      mechanicalTechnician: json['mechanicalTechnician'] ?? false,
      electricalTechnician: json['electricalTechnician'] ?? false,
      instrumentTechnician: json['instrumentTechnician'] ?? false,
      spareParts: List<String>.from(json['spareParts'] ?? []),
      tools: List<String>.from(json['tools'] ?? []),
      interventionStatus: json['interventionStatus'] ?? '',
      interventionTask: json['interventionTask'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interventionID': interventionID,
      'interventionDate': interventionDate.toIso8601String().split("T").first,
      'interventionType': interventionType,
      'interventionFileID': interventionFileID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'mechanicalTechnician': mechanicalTechnician,
      'electricalTechnician': electricalTechnician,
      'instrumentTechnician': instrumentTechnician,
      'spareParts': spareParts,
      'tools': tools,
      'interventionStatus': interventionStatus,
      'interventionTask': interventionTask,
    };
  }
}
