import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  String TagName;
  String Description;
  bool Status;
  String Area;
  Timestamp CreatedOn;
  Timestamp UpdatedOn;
  String Discipline;
  String Workshop;
  String Photo;

  Equipment({
    required this.TagName,
    required this.Description,
    required this.Status,
    required this.Area,
    required this.CreatedOn,
    required this.UpdatedOn,
    required this.Discipline,
    required this.Workshop,
    required this.Photo,
  });

  Equipment.fromJSON(Map<String, dynamic> json)
      : this(
          TagName: json['TagName']! as String,
          Description: json['Description']! as String,
          Status: json['Status']! as bool,
          Area: json['Area']! as String,
          CreatedOn: json["CreatedOn"]! as Timestamp,
          UpdatedOn: json["UpdatedOn"]! as Timestamp,
          Discipline: json["Discipline"]! as String,
          Workshop: json["Workshop"]! as String,
          Photo: json['Photo'] as String,
        );

  Equipment copyWith({
    String? TagName,
    String? Description,
    bool? Status,
    String? Area,
    Timestamp? CreatedOn,
    Timestamp? UpdatedOn,
    String? Discipline,
    String? Workshop,
    String? Photo,
  }) {
    return Equipment(
      TagName: TagName ?? this.TagName,
      Description: Description ?? this.Description,
      Status: Status ?? this.Status,
      Area: Area ?? this.Area,
      CreatedOn: CreatedOn ?? this.CreatedOn,
      UpdatedOn: UpdatedOn ?? this.UpdatedOn,
      Discipline: Discipline ?? this.Discipline,
      Workshop: Workshop ?? this.Workshop,
      Photo: Photo ?? this.Photo,
    );
  }

  Map<String, Object> toJson() {
    return {
      'TagName': TagName,
      'Description': Description,
      'Area': Area,
      'Status': Status,
      'CreatedOn': CreatedOn,
      'UpdatedOn': UpdatedOn,
      'Discipline': Discipline,
      'WorkShop': Workshop,
      'Photo': Photo,
    };
  }
}
