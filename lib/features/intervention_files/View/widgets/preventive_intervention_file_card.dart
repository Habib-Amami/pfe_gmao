import 'package:flutter/material.dart';
import 'add_file_form/intervention_file_status.dart';

class PreventiveInterventionFileCard extends StatelessWidget {
  final String fileName;
  final String fileStatus;
  final String equipmentDiscipline;
  final String interventionTask;
  final String startingDay;
  final int forecast;
  final List<String> spareParts;
  final List<String> tools;
  final bool isMechanicalTechnicianSelected;
  final bool isElectricalTechnicianSelected;
  final bool isInstrumentTechnicianSelected;

  const PreventiveInterventionFileCard({
    super.key,
    required this.fileName,
    required this.fileStatus,
    required this.equipmentDiscipline,
    required this.interventionTask,
    required this.startingDay,
    required this.forecast,
    required this.spareParts,
    required this.tools,
    required this.isMechanicalTechnicianSelected,
    required this.isElectricalTechnicianSelected,
    required this.isInstrumentTechnicianSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "File Name :   $fileName",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InterventionFileStatus(
            status: fileStatus,
          ),
        ),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Discipline :   $equipmentDiscipline",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Task :   $interventionTask",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Starting Day :   $startingDay",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Forecast :   $forecast days",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Tools :   $tools",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "Spare Parts :   $spareParts",
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Text(
                  "Technicians :",
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isMechanicalTechnicianSelected
                          ? const Text(
                              "Mechanical technician",
                            )
                          : Container(),
                      isElectricalTechnicianSelected
                          ? const Text(
                              'Electrical technician',
                            )
                          : Container(),
                      isInstrumentTechnicianSelected
                          ? const Text(
                              'Instrument technician',
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
