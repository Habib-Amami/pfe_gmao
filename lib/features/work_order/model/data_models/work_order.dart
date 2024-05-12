import 'package:flutter/material.dart';

class WorkOrder {
  final String workorderID;
  final String workorderStatus;
  final String wordorderCreatorID;
  final String workorderCreatorToken;
  final String interventionID;
  final String interventionType;
  final String interventionFileID;
  final String equipmentTagName;
  final String equipmentDiscipline;
  final String mechanicalTechnicianID;
  final String mechanicalTechnicianToken;
  final String electricalTechnicianID;
  final String electricalTechnicianToken;
  final String instrumentTechnicianID;
  final String instrumentTechnicianToken;
  final List<String> tools;
  final List<String> spareParts;
  final DateTime executionDay;
  final TimeOfDay startHour;
  final TimeOfDay finishHour;

  WorkOrder({
    required this.workorderID,
    required this.workorderStatus,
    required this.wordorderCreatorID,
    required this.workorderCreatorToken,
    required this.interventionID,
    required this.interventionType,
    required this.interventionFileID,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.mechanicalTechnicianID,
    required this.mechanicalTechnicianToken,
    required this.electricalTechnicianID,
    required this.electricalTechnicianToken,
    required this.instrumentTechnicianID,
    required this.instrumentTechnicianToken,
    required this.tools,
    required this.spareParts,
    required this.executionDay,
    required this.startHour,
    required this.finishHour,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      workorderID: json['wordorderID'],
      workorderStatus: json['workorderStatus'],
      wordorderCreatorID: json['wordorderCreatorID'],
      workorderCreatorToken: json['workorderCreatorToken'],
      interventionID: json['interventionID'],
      interventionType: json['interventionType'],
      interventionFileID: json['interventionFileID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
      mechanicalTechnicianID: json['mechanicalTechnicianID'],
      mechanicalTechnicianToken: json['mechanicalTechnicianToken'],
      electricalTechnicianID: json['electricalTechnicianID'],
      electricalTechnicianToken: json['electricalTechnicianToken'],
      instrumentTechnicianID: json['instrumentTechnicianID'],
      instrumentTechnicianToken: json['instrumentTechnicianToken'],
      tools: List<String>.from(json['tools']),
      spareParts: List<String>.from(json['spareParts']),
      executionDay: DateTime.parse(json['executionDay']),
      startHour: TimeOfDay.fromDateTime(DateTime.parse(json['startHour'])),
      finishHour: TimeOfDay.fromDateTime(DateTime.parse(json['finishHour'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordorderID': workorderID,
      'workorderStatus': workorderStatus,
      'wordorderCreatorID': wordorderCreatorID,
      'workorderCreatorToken': workorderCreatorToken,
      'interventionID': interventionID,
      'interventionType': interventionType,
      'interventionFileID': interventionFileID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'mechanicalTechnicianID': mechanicalTechnicianID,
      'mechanicalTechnicianToken': mechanicalTechnicianToken,
      'electricalTechnicianID': electricalTechnicianID,
      'electricalTechnicianToken': electricalTechnicianToken,
      'instrumentTechnicianID': instrumentTechnicianID,
      'instrumentTechnicianToken': instrumentTechnicianToken,
      'tools': tools,
      'spareParts': spareParts,
      'executionDay': executionDay.toIso8601String(),
      'startHour': '${startHour.hour}:${startHour.minute}',
      'finishHour': '${finishHour.hour}:${finishHour.minute}',
    };
  }
}
