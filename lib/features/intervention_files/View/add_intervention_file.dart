import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/empty_selection_container.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/list_header.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/spare_part_card.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/technician_card.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/tool_card.dart';

import '../model/data_models/breakdown_types.dart';
import '../model/data_models/criticality_levels_list.dart';
import '../model/data_models/intervention_types_list.dart';
import '../model/data_models/time_periods_list.dart';
import '../model/spare_part.dart';
import '../model/tool.dart';
import 'widgets/intervention_file_drop_down_menu.dart';
import 'widgets/intervention_file_form_title.dart';
import 'widgets/intervntion_file_form_files.dart';

class AddInterventionFile extends StatefulWidget {
  final String equipmentTagName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  const AddInterventionFile({
    required this.equipmentTagName,
    required this.equipmentStatus,
    required this.equipmentDiscipline,
    super.key,
  });

  @override
  State<AddInterventionFile> createState() => _AddInterventionFileState();
}

class _AddInterventionFileState extends State<AddInterventionFile> {
  // Form key for managing the state of the intervention file form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //variable for the initial value for drop down menu for the intervention type
  /// initial value is "Preventive"
  String _initialIntervnetionType = interventionTypes[1];

  //variable for the initialvalue for drop down menu for the intervention period
  /// initial value is "Daily"
  String _initialTimePeriod = timePeriods[0];

  //variable for the initialvalue for drop down menu for the intervention Criticality
  ///initial value is "Minor"
  String _initialCritciality = criticalityLevels[0];

  //variable for the initialvalue for drop down menu for the intervention breakdown type
  ///initial value is "Minor"
  String _initialBreakDownType = breakdownTypes[0];

  //variable for the starting date
  DateTime? startingDate;

  //controller for the starting date field
  final TextEditingController _startingDateController = TextEditingController();

  //controller for the starting date field
  final TextEditingController _customDurationController =
      TextEditingController();

  //bool for the Mechanical Technician check box
  bool _isMechanicalTechnicianSelected = false;

  //bool for the electrical Technician check box
  bool _isElectricalTechnicianSelected = false;

  //list of the spare parts selected by the user
  List<SparePart> selectedSparePartsList = [];
  //list of all the spare parts fetched from db
  List<SparePart> sparePartsList = [];
  //list for the spare parts for filting (by name)
  List<SparePart> filteredSparePartsList = [];

  // This function is called whenever the user filter tools
  void filterSpareParts(String enteredKeyword) {
    List<SparePart> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all Tools
      results = sparePartsList;
    } else {
      results = sparePartsList
          .where(
            (sparePart) => sparePart.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      filteredSparePartsList = results;
    });
  }

  //list of the tools selected by the user
  List<Tool> selectedToolsList = [];
  //list of all the tools fetched from db
  List<Tool> toolsList = [];
  //lust for the tools for filting (by name)
  List<Tool> filteredToolsList = [];

  // This function is called whenever the user filter tools
  void filterTools(String enteredKeyword) {
    List<Tool> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all Tools
      results = toolsList;
    } else {
      results = toolsList
          .where(
            (tool) => tool.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      filteredToolsList = results;
    });
  }

  Future<List<SparePart>> getSpareParts() async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('Spare_Parts');
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();

    final List<SparePart> sparePartsList = querySnapshot.docs.map((document) {
      final Map<String, dynamic> data = document.data();
      return SparePart(
        name: data["name"] as String,
        description: data["description"] as String,
        quantity: data["quantity"] as int,
      );
    }).toList();

    return sparePartsList;
  }

  Future<List<Tool>> getTools() async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('Tools');
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();

    final List<Tool> toolsList = querySnapshot.docs.map((document) {
      final Map<String, dynamic> data = document.data();
      return Tool(
        name: data["name"] as String,
        description: data["description"] as String,
        quantity: data["quantity"] as int,
      );
    }).toList();

    return toolsList;
  }

  void fetchData() async {
    toolsList = await getTools();
    sparePartsList = await getSpareParts();
    setState(() {
      filteredToolsList = toolsList;
      filteredSparePartsList = sparePartsList;
    });
  }

  @override
  void initState() {
    _customDurationController.text = "0";
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _startingDateController.dispose();
    _customDurationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData statusIconData;
    // Switch statement to determine the icon status filed based on equipment status
    switch (widget.equipmentStatus.toLowerCase()) {
      case 'active':
        statusIconData = Ionicons.checkmark_sharp;
        break;
      case 'shutdown':
        statusIconData = Icons.power_off_outlined;
        break;
      case 'standby':
        statusIconData = Ionicons.pause_circle_outline;
        break;
      default:
        statusIconData = Icons.error_outline;
    }
    IconData disciplineIconData;
    // Switch statement to determine the icon discipline filed based on equipment status
    switch (widget.equipmentDiscipline.toLowerCase()) {
      case 'mechanics':
        disciplineIconData = Icons.build;
        break;
      case 'electrics':
        disciplineIconData = Icons.flash_on;
        break;
      case 'instrumental':
        disciplineIconData = Icons.design_services;

        break;
      default:
        disciplineIconData = Icons.error_outline;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formkey,
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
                initialValue: widget.equipmentTagName,
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
                          prefixIcon: Icon(statusIconData),
                          initialValue: widget.equipmentStatus,
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
                          prefixIcon: Icon(disciplineIconData),
                          initialValue: widget.equipmentDiscipline,
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
                hintText: "Enter the intervention file name",
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.file_copy_rounded,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please provide name for the file";
                  }
                  return null;
                },
              ),
              const InterventionFileFormTitle(
                title: "Maintenance Type",
              ),
              // Dropdown menu for selecting the maintenance type
              InterventionFileDropDownMenu(
                valuesList: interventionTypes,
                iconsList: const [
                  Icons.healing,
                  Icons.medical_services,
                ],
                initialValue: _initialIntervnetionType,
                onChanged: (value) {
                  setState(() {
                    _initialIntervnetionType = value as String;
                  });
                },
              ),
              // Conditionally display additional fields based on the selected maintenance type
              _initialIntervnetionType == interventionTypes[1]
                  //"Preventive" intervention type
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InterventionFileFormTitle(
                          title: "Forecast",
                        ),
                        // Dropdown menu for selecting the forecast time period
                        InterventionFileDropDownMenu(
                          valuesList: timePeriods,
                          iconsList: const [
                            Icons.calendar_today_rounded,
                            Icons.calendar_view_week_rounded,
                            Icons.calendar_view_week_rounded,
                            Icons.calendar_view_month_rounded,
                            Icons.calendar_view_month_rounded,
                            Icons.calendar_month_rounded,
                            Icons.more_vert
                          ],
                          initialValue: _initialTimePeriod,
                          onChanged: (value) {
                            setState(() {
                              _initialTimePeriod = value as String;
                            });
                          },
                        ),
                        // Conditionally display custom duration input field
                        //if "Custom Period" time period is selected
                        _initialTimePeriod == timePeriods.last
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text prompting user to pick custom duration
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text("Pick your custom duration :"),
                                  ),
                                  // Row containing buttons for increasing/decreasing custom duration
                                  Row(
                                    children: [
                                      //Icon button for decreasing the field count
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: IconButton.outlined(
                                          onPressed: () {
                                            int custionDuration = int.parse(
                                                _customDurationController.text);
                                            custionDuration--;
                                            setState(() {
                                              _customDurationController.text =
                                                  custionDuration.toString();
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.remove_rounded),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      // Form field for displaying custom duration
                                      Expanded(
                                        flex: 4,
                                        child: InterventionFileFormField(
                                          prefixIcon: const Icon(
                                            Icons.hourglass_empty_rounded,
                                          ),
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          controller: _customDurationController,
                                          suffexIcon: const Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              "days",
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "please provide a custopn duration or use a preset";
                                            }
                                            if (int.parse(value) <= 0) {
                                              return "please provide a positive days count";
                                            }
                                            // if (value.) {

                                            // }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),

                                      //Icon button for increasing the field count
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: IconButton.outlined(
                                          onPressed: () {
                                            int custionDuration = int.parse(
                                                _customDurationController.text);
                                            custionDuration++;
                                            setState(() {
                                              _customDurationController.text =
                                                  custionDuration.toString();
                                            });
                                          },
                                          icon: const Icon(Icons.add_rounded),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    )
                  //"Curative" intervention type
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InterventionFileFormTitle(
                          title: "Criticality",
                        ),
                        // Dropdown menu for selecting the criticality level
                        InterventionFileDropDownMenu(
                          iconsList: const [
                            Ionicons.warning_outline,
                            Ionicons.alert_circle_outline,
                            Ionicons.warning_sharp,
                          ],
                          valuesList: criticalityLevels,
                          initialValue: _initialCritciality,
                          onChanged: (value) {
                            setState(() {
                              _initialCritciality = value as String;
                            });
                          },
                        ),
                        const InterventionFileFormTitle(
                          title: "Breakdown type",
                        ),
                        // Dropdown menu for selecting the breakdown type
                        InterventionFileDropDownMenu(
                          iconsList: const [
                            Icons.play_arrow,
                            Icons.build,
                            Icons.settings,
                            Icons.error,
                          ],
                          valuesList: breakdownTypes,
                          initialValue: _initialBreakDownType,
                          onChanged: (value) {
                            setState(() {
                              _initialBreakDownType = value as String;
                            });
                          },
                        ),
                        const InterventionFileFormTitle(
                          title: "Breakdown Description",
                        ),
                        // Form field for entering the breakdown description
                        InterventionFileFormField(
                          maxLines: 3,
                          hintText: "Describe the breakdown",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 48.0),
                            child: Icon(
                              Icons.description_outlined,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please provide a breakdown description";
                            }
                            return null;
                          },
                        )
                      ],
                    ),
              const InterventionFileFormTitle(
                title: "Starting Day",
              ),
              // Row containing two widgets: text field and icon button
              Row(
                children: [
                  // Expanded widget to ensure the text field takes up most of the row
                  Expanded(
                    flex: 4,
                    child: InterventionFileFormField(
                      controller: _startingDateController,
                      enabled: false,
                      hintText: "Pick a date from the calender",
                      prefixIcon: const Icon(Icons.timelapse_rounded),
                    ),
                  ),
                  // Expanded widget to ensure the icon button takes up the remaining space
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        bottom: 16.0,
                      ),
                      child: Column(
                        children: [
                          IconButton.filledTonal(
                            tooltip: "press to select a day from the calender",
                            onPressed: () async {
                              // Show date picker dialog
                              startingDate = await showDatePicker(
                                context: context,
                                barrierDismissible: false,
                                currentDate: DateTime.now(),
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(
                                  DateTime.now().year, //year
                                  12, // month
                                  31, // day
                                ),
                                helpText:
                                    "Pick a the starting day for the intervrntion",
                                errorFormatText:
                                    "Follow the mm/dd/yyyy format please",
                              );
                              // Update text field value if a date is selected
                              if (startingDate != null) {
                                setState(() {
                                  _startingDateController.text = DateFormat(
                                    "dd/MM/yyyy",
                                  ).format(
                                    startingDate!,
                                  );
                                });
                              }
                            },
                            // Icon displayed on the button
                            icon: const Icon(
                              Icons.edit_calendar_rounded,
                            ),
                          ),
                          Text(
                            "Pick a day",
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const InterventionFileFormTitle(
                title: "Intervention task",
              ),
              // Form field for entering the intervention task
              InterventionFileFormField(
                prefixIcon: const Icon(Icons.task),
                hintText: "Enter an intervention task",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please provide an intervention task";
                  }
                  return null;
                },
              ),
              const InterventionFileFormTitle(
                title: "Maintenance technicians",
              ),
              // Card widget containing a CheckboxListTile for selecting mechanical technician
              TechnicianCard(
                title: "Mechanical Technician",
                subtitle:
                    "A mechanical technician will handle the intervention.",
                checkboxValue: _isMechanicalTechnicianSelected,
                onChanged: (value) {
                  setState(() {
                    _isMechanicalTechnicianSelected =
                        !_isMechanicalTechnicianSelected;
                  });
                },
              ),
              // Card widget containing a CheckboxListTile for selecting electrical technician
              TechnicianCard(
                title: "Electrical Technician",
                subtitle:
                    "An electrical technician will execute the intervention.",
                checkboxValue: _isElectricalTechnicianSelected,
                onChanged: (value) {
                  setState(() {
                    _isElectricalTechnicianSelected =
                        !_isElectricalTechnicianSelected;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const InterventionFileFormTitle(
                title: "Spare Parts",
              ),
              // Form field for searching spare parts by name
              InterventionFileFormField(
                prefixIcon: const Icon(Icons.search),
                hintText: "search for a spare part by name",
                // Callback function invoked when the input value changes
                onChanged: (value) => filterSpareParts(value),
              ),
              // Widget containing column titles for spare parts list
              const ListViewHeader(
                firstColumnName: "Spare part name",
                secondColumnName: "Quantity",
              ),
              // List view displaying spare parts with selection capability
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    itemCount: filteredSparePartsList.length,
                    itemExtent: 95,
                    itemBuilder: (context, index) {
                      return SparePartCard(
                        sparePart: filteredSparePartsList[index],
                        onTap: () {
                          setState(() {
                            // Toggle selection state
                            filteredSparePartsList[index].isSelected =
                                !filteredSparePartsList[index].isSelected;
                            // Add or remove selected spare part from the list
                            if (filteredSparePartsList[index].isSelected) {
                              selectedSparePartsList
                                  .add(filteredSparePartsList[index]);
                            } else {
                              selectedSparePartsList
                                  .remove(filteredSparePartsList[index]);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const InterventionFileFormTitle(
                title: "Selected Spare Parts",
              ),
              // Check if the selected spare parts list is empty
              selectedSparePartsList.isEmpty
                  // Display a message if no spare parts are selected
                  ? const EmptySelectionContainer(
                      message: "no spare parts has been selected yet !",
                    )
                  // Display the list of selected spare parts
                  : SizedBox(
                      width: double.infinity,
                      height: 135,
                      child: ListView.builder(
                        itemCount: selectedSparePartsList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                              title: Text(
                                selectedSparePartsList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    // Set isSelected to false and remove from the list
                                    selectedSparePartsList[index].isSelected =
                                        false;
                                    selectedSparePartsList
                                        .remove(selectedSparePartsList[index]);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              )),
                        ),
                      ),
                    ),
              const InterventionFileFormTitle(
                title: "Tools",
              ),
              // Form field for searching tools by name
              InterventionFileFormField(
                prefixIcon: const Icon(Icons.search),
                hintText: "search for a tool by name",
                onChanged: (value) => filterTools(value),
              ),
              // Widget containing column titles for spare parts list
              const ListViewHeader(
                firstColumnName: "Tool name",
                secondColumnName: "Quantity",
              ),
              // List view displaying tools with selection capability
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    itemCount: filteredToolsList.length + 1,
                    itemExtent: 95,
                    itemBuilder: (context, index) {
                      return ToolCard(
                        tool: filteredToolsList[index],
                        onTap: () {
                          setState(() {
                            // Toggle selection state
                            filteredToolsList[index].isSelected =
                                !filteredToolsList[index].isSelected;
                            // Add or remove selected tool from the list
                            if (filteredToolsList[index].isSelected) {
                              selectedToolsList.add(filteredToolsList[index]);
                            } else {
                              selectedToolsList
                                  .remove(filteredToolsList[index]);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const InterventionFileFormTitle(
                title: "Selected Tools",
              ),
              // Check if the selected tools list is empty
              selectedToolsList.isEmpty
                  // Display a message if no tools are selected
                  ? const EmptySelectionContainer(
                      message: "no tools has been selected yet !",
                    )
                  // Display the list of selected tools
                  : SizedBox(
                      width: double.infinity,
                      height: 140,
                      child: ListView.builder(
                        itemExtent: 64,
                        itemCount: selectedToolsList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                              title: Text(
                                selectedToolsList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedToolsList[index].isSelected = false;
                                    selectedToolsList
                                        .remove(selectedToolsList[index]);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              )),
                        ),
                      ),
                    ),
              // Row widget to display confirm and cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button for registering
                  SizedBox(
                    width: 105,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text("Register"),
                    ),
                  ),
                  // Button for canceling
                  SizedBox(
                    width: 105,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text("Cancel"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
