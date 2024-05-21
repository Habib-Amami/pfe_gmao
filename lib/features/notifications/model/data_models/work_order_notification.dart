class WorkorderNotification {
  final String notificationID;
  final String notificationTitle;
  final String notificationBody;

  final String equipmentTagName;
  final String equipmentDiscipline;

  final String workorderCreatorID;
  final String workorderCreatorToken;

  final String technicianID;
  final String technicianToken;

  final DateTime createdAt;

  WorkorderNotification({
    required this.notificationID,
    required this.notificationTitle,
    required this.notificationBody,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.workorderCreatorID,
    required this.workorderCreatorToken,
    required this.technicianID,
    required this.technicianToken,
    required this.createdAt,
  });

  // Factory constructor to create an instance from JSON
  factory WorkorderNotification.fromJson(Map<String, dynamic> json) {
    return WorkorderNotification(
      notificationID: json['notificationID'],
      notificationTitle: json['notificationTitle'],
      notificationBody: json['notificationBody'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
      workorderCreatorID: json['workorderCreatorID'],
      workorderCreatorToken: json['workorderCreatorToken'],
      technicianID: json['technicianID'],
      technicianToken: json['technicianToken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'workorderCreatorID': workorderCreatorID,
      'workorderCreatorToken': workorderCreatorToken,
      'technicianID': technicianID,
      'technicianToken': technicianToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
