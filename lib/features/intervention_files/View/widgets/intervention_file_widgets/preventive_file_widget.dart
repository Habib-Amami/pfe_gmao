import 'package:flutter/material.dart';

import '../add_file_form/intervention_file_form_title.dart';
import '../add_file_form/intervntion_file_form_files.dart';

class PreventiveFile extends StatelessWidget {
  final String equipmentName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  final String fileName;
  final String interventionType;
  final String startingDay;
  final String technicians;
  final String spareParts;
  final String tools;
  final String task;
  final int forecast;

  const PreventiveFile({
    super.key,
    required this.equipmentName,
    required this.equipmentStatus,
    required this.equipmentDiscipline,
    required this.fileName,
    required this.interventionType,
    required this.forecast,
    required this.startingDay,
    required this.task,
    required this.technicians,
    required this.spareParts,
    required this.tools,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const InterventionFileFormTitle(
            title: "Tag name",
          ),
          // Display a form field for displaying the equipment tag name
          InterventionFileFormField(
            readOnly: true,
            prefixIcon: const Icon(
              Icons.local_offer_outlined,
            ),
            initialValue: equipmentName,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InterventionFileFormTitle(
                    title: "Status",
                  ),
                  // Form field for displaying equipment status
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2 - 24,
                    child: InterventionFileFormField(
                      prefixIcon: const Icon(
                        Icons.power,
                      ),
                      initialValue: equipmentStatus,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InterventionFileFormTitle(
                    title: "Discipline",
                  ),
                  // Form field for displaying equipment discipline
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2 - 24,
                    child: InterventionFileFormField(
                      prefixIcon: const Icon(
                        Icons.workspace_premium,
                      ),
                      initialValue: equipmentDiscipline,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const InterventionFileFormTitle(
            title: "Name Intervention File",
          ),
          // Form field for entering the intervention file name
          InterventionFileFormField(
            readOnly: true,
            initialValue: fileName,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(
              Icons.file_copy_rounded,
            ),
          ),
          const InterventionFileFormTitle(
            title: "Maintenance Type",
          ),
          // Dropdown menu for selecting the maintenance type
          InterventionFileFormField(
            initialValue: interventionType,
            readOnly: true,
          ),
          const InterventionFileFormTitle(
            title: "Forecast",
          ),
          InterventionFileFormField(
            readOnly: true,
            initialValue: '${forecast.toString()} days',
          ),
          const InterventionFileFormTitle(
            title: "Starting Day",
          ),
          InterventionFileFormField(
            readOnly: true,
            initialValue: startingDay,
            prefixIcon: const Icon(
              Icons.timelapse_rounded,
            ),
          ),
          const InterventionFileFormTitle(
            title: "Intervention task",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(
              Icons.task,
            ),
            initialValue: task,
            readOnly: true,
          ),
          const InterventionFileFormTitle(
            title: "Maintenance technicians",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(
              Icons.engineering_rounded,
            ),
            initialValue: technicians,
            readOnly: true,
          ),
          const InterventionFileFormTitle(
            title: "Spare parts",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(
              Icons.construction,
            ),
            initialValue: spareParts,
            readOnly: true,
          ),

          const InterventionFileFormTitle(
            title: "Tools",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(
              Icons.construction,
            ),
            initialValue: tools,
            readOnly: true,
          ),
        ]),
      ),
    );
  }
}
