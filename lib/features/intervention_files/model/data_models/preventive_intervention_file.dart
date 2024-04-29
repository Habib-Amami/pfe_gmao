class PreventiveInterventionFile {
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  final String fileID;
  final String fileName;
  final String maintenanceType;
  final int forecast;
  final String startingDay;
  final String interventionTask;
  final bool mechanicalTechnician;
  final bool electricalTechnician;
  final bool instrumentTechnician;
  final List<String> spareParts;
  final List<String> tools;
  final String fileStatus;

  PreventiveInterventionFile({
    required this.equipmentID,
    required this.equipmentTagName,
    required this.equipmentStatus,
    required this.equipmentDiscipline,
    required this.fileID,
    required this.fileName,
    required this.maintenanceType,
    required this.forecast,
    required this.startingDay,
    required this.interventionTask,
    required this.mechanicalTechnician,
    required this.electricalTechnician,
    required this.instrumentTechnician,
    required this.spareParts,
    required this.tools,
    required this.fileStatus,
  });

  // toJson method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'equipmentID': equipmentID,
      'equipmentTagName': equipmentTagName,
      'equipmentStatus': equipmentStatus,
      'equipmentDiscipline': equipmentDiscipline,
      'fileID': fileID,
      'fileName': fileName,
      'maintenanceType': maintenanceType,
      'forecast': forecast,
      'startingDay': startingDay,
      'interventionTask': interventionTask,
      'mechanicalTechnician': mechanicalTechnician,
      'electricalTechnician': electricalTechnician,
      'instrumentTechnician': instrumentTechnician,
      'spareParts': spareParts,
      'tools': tools,
      'fileStatus': fileStatus,
    };
  }

  // fromJson method to create object from JSON
  factory PreventiveInterventionFile.fromJson(Map<String, dynamic> json) {
    return PreventiveInterventionFile(
      equipmentID: json['equipmentID'],
      equipmentTagName: json['equipmentTagName'],
      equipmentStatus: json['equipmentStatus'],
      equipmentDiscipline: json['equipmentDiscipline'],
      fileID: json['fileID'],
      fileName: json['fileName'],
      maintenanceType: json['maintenanceType'],
      forecast: json['forecast'],
      startingDay: json['startingDay'],
      interventionTask: json['interventionTask'],
      mechanicalTechnician: json['mechanicalTechnician'],
      electricalTechnician: json['electricalTechnician'],
      instrumentTechnician: json['instrumentTechnician'],
      spareParts: List<String>.from(json['spareParts']),
      tools: List<String>.from(json['tools']),
      fileStatus: json['fileStatus'],
    );
  }

  /// Helper method to map time periods to days
  /// This methode uses the const list [timePeriods].
  static int mapTimePeriodToDays({
    required String selectedTimePeriod,
    // This parameter represents the custom period value input by the user.
    // It defaults to 0 if not provided.
    int customPeriodValue = 0,
  }) {
    switch (selectedTimePeriod) {
      case "Daily":
        return 1;
      case "Weekly":
        return 7;
      case "Biweekly":
        return 14;
      case "Monthly":
        return 30;
      case "Quarterly":
        return 90;
      case "Yearly":
        return 365;
      case "Custom Period":
        // If the selected time period is "Custom Period",
        // return the custom period value provided by the user.
        return customPeriodValue;
      default:
        // If the provided time period is not recognized,
        // return a default value of 0.
        return 0;
    }
  }
}
