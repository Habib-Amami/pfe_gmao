import 'package:cloud_firestore/cloud_firestore.dart';

class InterventionFileValidationNotification {
  final String notificationTitle;
  final String notificationBody;
  final String interventionFileCreatorToken;
  final String interventionFileID;
  final String interventionType;
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentDiscipline;
  final Timestamp createdAt;

  InterventionFileValidationNotification(
      {required this.notificationTitle,
      required this.notificationBody,
      required this.interventionFileCreatorToken,
      required this.interventionFileID,
      required this.equipmentID,
      required this.interventionType,
      required this.equipmentTagName,
      required this.equipmentDiscipline,
      required this.createdAt});

  // toJson method to convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'interventionFileCreatorToken': interventionFileCreatorToken,
      'interventionFileID': interventionFileID,
      'interventionType': interventionType,
      'equipmentID': equipmentID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Factory constructor to create an object from a JSON map
  factory InterventionFileValidationNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterventionFileValidationNotification(
      notificationTitle: json['notificationTitle'],
      notificationBody: json['notificationBody'],
      interventionFileCreatorToken: json['interventionFileCreatorToken'],
      interventionFileID: json['interventionFileID'],
      interventionType: json['interventionType'],
      equipmentID: json['equipmentID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
      createdAt: Timestamp.fromMicrosecondsSinceEpoch(json['createdAt']),
    );
  }
}
