class InterventionFileValidationNotification {
  final String notificationID;
  final String notificationTitle;
  final String notificationBody;
  final String interventionFileCreatorID;
  final String interventionFileCreatorToken;
  final String interventionFileID;
  final String interventionType;
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentDiscipline;
  final DateTime createdAt;

  InterventionFileValidationNotification({
    required this.notificationID,
    required this.notificationTitle,
    required this.notificationBody,
    required this.interventionFileCreatorID,
    required this.interventionFileCreatorToken,
    required this.interventionFileID,
    required this.equipmentID,
    required this.interventionType,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.createdAt,
  });

  // toJson method to convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'interventionFileCreatorID': interventionFileCreatorID,
      'interventionFileCreatorToken': interventionFileCreatorToken,
      'interventionFileID': interventionFileID,
      'interventionType': interventionType,
      'equipmentID': equipmentID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor to create an object from a JSON map
  factory InterventionFileValidationNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterventionFileValidationNotification(
      notificationID: json['notificationID'],
      notificationTitle: json['notificationTitle'],
      notificationBody: json['notificationBody'],
      interventionFileCreatorID: json['interventionFileCreatorID'],
      interventionFileCreatorToken: json['interventionFileCreatorToken'],
      interventionFileID: json['interventionFileID'],
      interventionType: json['interventionType'],
      equipmentID: json['equipmentID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
