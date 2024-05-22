class WorkorderNotification {
  final String notificationID;
  final String notificationTitle;
  final String notificationBody;

  final String workOrderID;
  final String interventionID;

  final String workorderCreatorID;
  final String technicianID;

  final DateTime createdAt;

  WorkorderNotification({
    required this.notificationID,
    required this.notificationTitle,
    required this.notificationBody,
    required this.workorderCreatorID,
    required this.technicianID,
    required this.createdAt,
    required this.workOrderID,
    required this.interventionID,
  });

  // Factory constructor to create an instance from JSON
  factory WorkorderNotification.fromJson(Map<String, dynamic> json) {
    return WorkorderNotification(
      notificationID: json['notificationID'],
      notificationTitle: json['notificationTitle'],
      notificationBody: json['notificationBody'],
      workorderCreatorID: json['workorderCreatorID'],
      technicianID: json['technicianID'],
      createdAt: DateTime.parse(json['createdAt']),
      workOrderID: json['workOrderID'],
      interventionID: json['interventionID'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'workorderCreatorID': workorderCreatorID,
      'technicianID': technicianID,
      'createdAt': createdAt.toIso8601String(),
      'workOrderID': workOrderID,
      'interventionID': interventionID,
    };
  }
}
