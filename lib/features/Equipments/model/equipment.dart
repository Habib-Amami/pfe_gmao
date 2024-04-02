// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  String id;
  String TagName;
  String Description;
  String Status;
  String Priority;
  String Area;
  Timestamp CreatedOn;
  Timestamp UpdatedOn;
  String Discipline;
  String Workshop;
  String Photo;
  String Longitude;
  String Latitude;
  String userManual;
  String contract;
  List<String> otherFiles;

  Equipment({
    required this.id,
    required this.TagName,
    required this.Description,
    required this.Status,
    required this.Priority,
    required this.Area,
    required this.CreatedOn,
    required this.UpdatedOn,
    required this.Discipline,
    required this.Workshop,
    required this.Photo,
    required this.Longitude,
    required this.Latitude,
    required this.userManual,
    required this.contract,
    required this.otherFiles,
  });

  Equipment.fromJSON(Map<String, dynamic> json)
      : this(
          id: json['id']! as String,
          TagName: json['TagName']! as String,
          Description: json['Description']! as String,
          Status: json['Status']! as String,
          Priority: json['Priority']! as String,
          Area: json['Area']! as String,
          CreatedOn: json["CreatedOn"]! as Timestamp,
          UpdatedOn: json["UpdatedOn"]! as Timestamp,
          Discipline: json["Discipline"]! as String,
          Workshop: json["Workshop"]! as String,
          Photo: json['Photo']! as String,
          Longitude: json['Longitude']! as String,
          Latitude: json['Latitude']! as String,
          userManual:
              json['userManual'] != null ? json['userManual'] as String : '',
          contract: json['contract'] != null ? json['contract'] as String : '',
          otherFiles: json['otherFiles'] != null
              ? List<String>.from(json['otherFiles'])
              : [],
        );

  Equipment copyWith({
    String? id,
    String? TagName,
    String? Description,
    String? Status,
    String? Priority,
    String? Area,
    Timestamp? CreatedOn,
    Timestamp? UpdatedOn,
    String? Discipline,
    String? Workshop,
    String? Photo,
    String? Longitude,
    String? Latitude,
    String? userManual,
    String? contract,
    List<String>? otherFiles,
  }) {
    return Equipment(
      id: id ?? this.id,
      TagName: TagName ?? this.TagName,
      Description: Description ?? this.Description,
      Status: Status ?? this.Status,
      Priority: Priority ?? this.Priority,
      Area: Area ?? this.Area,
      CreatedOn: CreatedOn ?? this.CreatedOn,
      UpdatedOn: UpdatedOn ?? this.UpdatedOn,
      Discipline: Discipline ?? this.Discipline,
      Workshop: Workshop ?? this.Workshop,
      Photo: Photo ?? this.Photo,
      Longitude: Longitude ?? this.Longitude,
      Latitude: Latitude ?? this.Latitude,
      userManual: userManual ?? this.userManual,
      contract: contract ?? this.contract,
      otherFiles: otherFiles ?? this.otherFiles,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'TagName': TagName,
      'Description': Description,
      'Area': Area,
      'Status': Status,
      'Priority': Priority,
      'CreatedOn': CreatedOn,
      'UpdatedOn': UpdatedOn,
      'Discipline': Discipline,
      'WorkShop': Workshop,
      'Photo': Photo,
      'Longitude': Longitude,
      'Latitude': Latitude,
      'userManual': userManual,
      'contract': contract,
      'otherFiles': otherFiles,
    };
  }
}
