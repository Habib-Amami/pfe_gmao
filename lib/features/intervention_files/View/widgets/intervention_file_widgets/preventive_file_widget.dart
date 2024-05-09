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
            prefixIcon: const Icon(
              Icons.local_offer_outlined,
              color: Colors.black,
            ),
            initialValue: equipmentName,
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
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
                      enabled: false,
                      prefixIcon: const Icon(
                        Icons.power,
                        color: Colors.black,
                      ),
                      textStyle: const TextStyle(color: Colors.black),
                      initialValue: equipmentStatus,
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
                      enabled: false,
                      prefixIcon: const Icon(
                        Icons.workspace_premium,
                        color: Colors.black,
                      ),
                      textStyle: const TextStyle(color: Colors.black),
                      initialValue: equipmentDiscipline,
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
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
            initialValue: fileName,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(
              color: Colors.black,
              Icons.file_copy_rounded,
            ),
          ),
          const InterventionFileFormTitle(
            title: "Maintenance Type",
          ),
          // Dropdown menu for selecting the maintenance type
          InterventionFileFormField(
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.medical_services, color: Colors.black),
            initialValue: interventionType,
          ),
          const InterventionFileFormTitle(
            title: "Forecast",
          ),
          InterventionFileFormField(
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.medical_services, color: Colors.black),
            initialValue: '${forecast.toString()} days',
          ),
          const InterventionFileFormTitle(
            title: "Starting Day",
          ),
          InterventionFileFormField(
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
            initialValue: startingDay,
            prefixIcon:
                const Icon(Icons.timelapse_rounded, color: Colors.black),
          ),
          const InterventionFileFormTitle(
            title: "Intervention task",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(
              Icons.task,
              color: Colors.black,
            ),
            initialValue: task,
            textStyle: const TextStyle(color: Colors.black),
            enabled: false,
          ),
          const InterventionFileFormTitle(
            title: "Maintenance technicians",
          ),
          InterventionFileFormField(
            prefixIcon:
                const Icon(Icons.engineering_rounded, color: Colors.black),
            initialValue: technicians,
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
          ),
          const InterventionFileFormTitle(
            title: "Spare parts",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(Icons.construction, color: Colors.black),
            initialValue: spareParts,
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
          ),

          const InterventionFileFormTitle(
            title: "Tools",
          ),
          InterventionFileFormField(
            prefixIcon: const Icon(Icons.construction, color: Colors.black),
            initialValue: tools,
            enabled: false,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
