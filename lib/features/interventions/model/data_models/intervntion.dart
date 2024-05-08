class Intervention {
  final String interventionID;
  final DateTime interventionDate;
  final String interventionType;
  final String interventionFileID;
  final String equipmentTagName;
  final String equipmentDiscipline;

  Intervention({
    required this.interventionID,
    required this.interventionDate,
    required this.interventionType,
    required this.interventionFileID,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      interventionID: json['interventionID'],
      interventionDate: DateTime.parse(json['interventionDate']),
      interventionType: json['interventionType'],
      interventionFileID: json['interventionFileID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interventionID': interventionID,
      'interventionDate': interventionDate.toIso8601String(),
      'interventionType': interventionType,
      'interventionFileID': interventionFileID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
    };
  }
}
