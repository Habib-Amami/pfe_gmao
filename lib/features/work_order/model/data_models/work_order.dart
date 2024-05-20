import 'package:flutter/material.dart';

class WorkOrder {
  final String workorderID;
  final String workorderStatus;
  final String workorderCreatorID;
  final String workorderCreatorUserName;
  final String workorderCreatorToken;
  final String interventionID;
  final String interventionType;
  final String interventionFileID;
  final String equipmentTagName;
  final String equipmentDiscipline;
  final String technicianID;
  final String technicianUserName;
  final String technicianToken;
  final List<String> steps;
  final List<String> tools;
  final List<String> spareParts;
  final DateTime executionDay;
  final TimeOfDay startTime;
  final TimeOfDay finishTime;

  WorkOrder({
    required this.workorderID,
    required this.workorderStatus,
    required this.workorderCreatorID,
    required this.workorderCreatorUserName,
    required this.workorderCreatorToken,
    required this.interventionID,
    required this.interventionType,
    required this.interventionFileID,
    required this.equipmentTagName,
    required this.equipmentDiscipline,
    required this.technicianID,
    required this.technicianUserName,
    required this.technicianToken,
    required this.steps,
    required this.tools,
    required this.spareParts,
    required this.executionDay,
    required this.startTime,
    required this.finishTime,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      workorderID: json['workorderID'],
      workorderStatus: json['workorderStatus'],
      workorderCreatorID: json['workorderCreatorID'],
      workorderCreatorUserName: json['workorderCreatorUserName'],
      workorderCreatorToken: json['workorderCreatorToken'],
      interventionID: json['interventionID'],
      interventionType: json['interventionType'],
      interventionFileID: json['interventionFileID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentDiscipline: json['equipmentDiscipline'],
      technicianID: json['technicianID'],
      technicianUserName: json['technicianUserName'],
      technicianToken: json['technicianToken'],
      steps: List<String>.from(json['steps']),
      tools: List<String>.from(json['tools']),
      spareParts: List<String>.from(json['spareParts']),
      executionDay: DateTime.parse(json['executionDay']),
      startTime: TimeOfDay(
        hour: int.parse(json['startHour'].split(":")[0]),
        minute: int.parse(json['startHour'].split(":")[1]),
      ),
      finishTime: TimeOfDay(
        hour: int.parse(json['finishHour'].split(":")[0]),
        minute: int.parse(json['finishHour'].split(":")[1]),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workorderID': workorderID,
      'workorderStatus': workorderStatus,
      'workorderCreatorID': workorderCreatorID,
      'workorderCreatorUserName': workorderCreatorUserName,
      'workorderCreatorToken': workorderCreatorToken,
      'interventionID': interventionID,
      'interventionType': interventionType,
      'interventionFileID': interventionFileID,
      'equipmentTagName': equipmentTagName,
      'equipmentDiscipline': equipmentDiscipline,
      'technicianID': technicianID,
      'technicianUserName': technicianUserName,
      'technicianToken': technicianToken,
      'steps': steps,
      'tools': tools,
      'spareParts': spareParts,
      'executionDay': executionDay.toIso8601String().split('T').first,
      'startHour':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'finishHour':
          '${finishTime.hour.toString().padLeft(2, '0')}:${finishTime.minute.toString().padLeft(2, '0')}',
    };
  }
}
