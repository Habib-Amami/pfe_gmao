import 'package:pfe_gmao/features/intervention_files/model/data_models/curative_intervention_file.dart';
import 'package:pfe_gmao/features/intervention_files/model/data_models/preventive_intervention_file.dart';

class NotificationModel {
  final String title;
  final String body;
  final String ifCreatorToken;
  final PreventiveInterventionFile preventiveInterventionFile;
  final CurativeInterventionFile curativeInterventionFile;

  NotificationModel({
    required this.title,
    required this.body,
    required this.ifCreatorToken,
    required this.preventiveInterventionFile,
    required this.curativeInterventionFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'ifCreatorToken': ifCreatorToken,
      'prevenitveInterventionFile': preventiveInterventionFile,
      'curativeInterventionFile': curativeInterventionFile,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['title'],
      ifCreatorToken: json['ifCreatorToken'],
      preventiveInterventionFile: json['prevenitveInterventionFile'],
      curativeInterventionFile: json['curativeInterventionFile'],
    );
  }
}
