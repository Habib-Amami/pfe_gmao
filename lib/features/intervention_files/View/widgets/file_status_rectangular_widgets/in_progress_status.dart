import 'package:flutter/material.dart';

import '../../../model/data_models/intervention_file_status.dart';
import '../../../model/intervention_file_model.dart';

class InProgressState extends StatefulWidget {
  final String equipmentID;
  final String equipmentDiscipline;
  final String interventionFileID;
  final String interventionType;

  const InProgressState({
    super.key,
    required this.equipmentID,
    required this.equipmentDiscipline,
    required this.interventionFileID,
    required this.interventionType,
  });

  @override
  State<InProgressState> createState() => _InProgressStateState();
}

class _InProgressStateState extends State<InProgressState> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 100,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text(
                      'Do you really want to validate this intervention file?',
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  InterventionFileModel()
                                      .changeInterventionFileStatus(
                                    equipmentID: widget.equipmentID,
                                    equipmentDiscipline:
                                        widget.equipmentDiscipline,
                                    interventionFileID:
                                        widget.interventionFileID,
                                    interventionType: widget.interventionType,
                                    newStatus: interventionFileStatus[0],
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 90,
                              height: 40,
                              child: const Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Validate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.error,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Deny alert'),
                    content: const Text(
                      'Tell us why you denied this intervention file!',
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 70,
                              height: 35,
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Deny',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
