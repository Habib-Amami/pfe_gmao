import 'package:flutter/material.dart';

import '../intervention_file_view.dart';
import 'add_file_form/intervention_file_status.dart';

class PreventiveInterventionFileCard extends StatelessWidget {
  final String fileName;
  final String fileID;
  final String interventionType;
  final String fileStatus;
  final String equipmentName;
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
    required this.fileID,
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
    required this.equipmentName,
    required this.interventionType,
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
          child: Row(
            children: [
              const Text('Status'),
              const SizedBox(width: 10),
              InterventionFileStatus(
                status: fileStatus,
              ),
            ],
          ),
        ),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Equipment:   $equipmentName",
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
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InterventionFileViewPage(
                    interventionFileID: fileID,
                    interventionType: interventionType,
                    equipmentDiscipline: equipmentDiscipline,
                  ),
                ),
              ),
              label: const Text('See more'),
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
