import 'package:flutter/material.dart';

import '../add_file_form/intervention_file_form_title.dart';
import '../add_file_form/intervntion_file_form_files.dart';

class CurativeInterventionFileView extends StatelessWidget {
  const CurativeInterventionFileView({
    super.key,
    required this.equipmentName,
    required this.equipmentStatus,
    required this.equipmentDiscipline,
    required this.fileName,
    required this.interventionType,
    required this.criticality,
    required this.breakdownType,
    required this.startingDay,
    required this.technicians,
    required this.spareParts,
    required this.tools,
    required this.task,
    required this.breakdownDescription,
    //required this.creationDate,
  });
  final String equipmentName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  final String fileName;
  final String interventionType;
  final String criticality;
  final String breakdownType;
  //final String creationDate;
  final String breakdownDescription;
  final String startingDay;
  final String technicians;
  final String spareParts;
  final String tools;
  final String task;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InterventionFileFormTitle(
              title: "Tag name",
            ),
            // Display a form field for displaying the equipment tag name
            InterventionFileFormField(
              prefixIcon: const Icon(Icons.local_offer_outlined),
              initialValue: equipmentName,
              enabled: false,
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

            InterventionFileFormField(
              enabled: false,
              initialValue: fileName,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.file_copy_rounded,
              ),
            ),
            const InterventionFileFormTitle(
              title: "Maintenance Type",
            ),

            InterventionFileFormField(
              enabled: false,
              prefixIcon: const Icon(Icons.medical_services),
              initialValue: interventionType,
            ),

            const InterventionFileFormTitle(
              title: "Criticality",
            ),
            InterventionFileFormField(
              enabled: false,
              prefixIcon: const Icon(Icons.medical_services),
              initialValue: criticality,
            ),

            const InterventionFileFormTitle(
              title: "Breakdown type",
            ),
            InterventionFileFormField(
              enabled: false,
              prefixIcon: const Icon(Icons.medical_services),
              initialValue: breakdownType,
            ),

            const InterventionFileFormTitle(
              title: "Breakdown description",
            ),
            InterventionFileFormField(
              maxLines: 3,
              enabled: false,
              initialValue: breakdownDescription,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 48.0),
                child: Icon(
                  Icons.description_outlined,
                ),
              ),
            ),
            // const InterventionFileFormTitle(
            //   title: "Creation date",
            // ),
            // InterventionFileFormField(
            //   maxLines: 3,
            //   enabled: false,
            //   initialValue: creationDate,
            //   prefixIcon: const Padding(
            //     padding: EdgeInsets.only(bottom: 48.0),
            //     child: Icon(
            //       Icons.description_outlined,
            //     ),
            //   ),
            // ),
            const InterventionFileFormTitle(
              title: "Starting Day",
            ),
            InterventionFileFormField(
              enabled: false,
              initialValue: startingDay,
              prefixIcon: const Icon(Icons.timelapse_rounded),
            ),
            const InterventionFileFormTitle(
              title: "Intervention task",
            ),
            InterventionFileFormField(
              prefixIcon: const Icon(Icons.task),
              initialValue: task,
              enabled: false,
            ),
            const InterventionFileFormTitle(
              title: "Maintenance technicians",
            ),
            InterventionFileFormField(
              prefixIcon: const Icon(Icons.engineering_rounded),
              initialValue: technicians,
              enabled: false,
            ),
            const InterventionFileFormTitle(
              title: "Spare parts",
            ),
            InterventionFileFormField(
              prefixIcon: const Icon(Icons.construction),
              initialValue: spareParts,
              enabled: false,
            ),

            const InterventionFileFormTitle(
              title: "Tools",
            ),
            InterventionFileFormField(
              prefixIcon: const Icon(Icons.construction),
              initialValue: tools,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
