import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/constants/breakdown_types.dart';
import '../../model/constants/criticality_levels_list.dart';
import '../../model/constants/intervention_types_list.dart';
import '../../model/constants/time_periods_list.dart';
import '../../model/data_models/preventive_intervention_file.dart';
import '../../model/data_models/spare_part.dart';
import '../../model/data_models/tool.dart';
import '../../model/intervention_file_model.dart';
import '../widgets/add_file_form/empty_selection_container.dart';
import '../widgets/add_file_form/intervention_file_drop_down_menu.dart';
import '../widgets/add_file_form/intervention_file_form_title.dart';
import '../widgets/add_file_form/intervntion_file_form_files.dart';
import '../widgets/add_file_form/list_header.dart';
import '../widgets/add_file_form/spare_part_card.dart';
import '../widgets/add_file_form/technician_card.dart';
import '../widgets/add_file_form/tool_card.dart';

class AddInterventionFile extends StatefulWidget {
  final String equipmentID;
  final String equipmentTagName;
  final String equipmentStatus;
  final String equipmentDiscipline;
  const AddInterventionFile({
    required this.equipmentID,
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

  // Variable for the initial value for the intervention type dropdown menu
  /// Default value is "Preventive"
  String _initialIntervnetionType = interventionTypes[1];

  // Variable for the initial value for the intervention period dropdown menu
  /// Default value is "Daily"
  String _initialTimePeriod = timePeriods[0];

  // Variable for the initial value for the intervention criticality dropdown menu
  /// Default value is "Minor"
  String _initialCritciality = criticalityLevels[0];

  //variable for the initialvalue for drop down menu for the intervention breakdown type
  ///initial value is "At the start"
  String _initialBreakDownType = breakdownTypes[0];

  //variable for the starting date
  DateTime? startingDate;

  // Controller for the starting date field
  final TextEditingController _startingDateController = TextEditingController();

  // Controller for the custom duration field
  final TextEditingController _customDurationController =
      TextEditingController();

  // Boolean for the Mechanical Technician checkbox
  bool _isMechanicalTechnicianSelected = false;

  // Boolean for the Electrical Technician checkbox
  bool _isElectricalTechnicianSelected = false;

  // Boolean for the Instrument Technician checkbox
  bool _isInstrumentTechnicianSelected = false;

  //variables for storing form values
  String _fileName = ""; // Stores the file name
  String _interventionTask = ""; // Stores the intervention task description
  String _breakDownDescription = ""; // Stores the breakdown description

  //
  // List of the spare parts selected by the user
  List<SparePart> selectedSparePartsList = [];
  // List of all the spare parts fetched from the database
  List<SparePart> sparePartsList = [];
  // List for the spare parts for filtering (by name)
  List<SparePart> filteredSparePartsList = [];
  // Function to filter spare parts based on the entered keyword
  void filterSpareParts(String enteredKeyword) {
    List<SparePart> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space,
      //we'll display all Tools
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
  //

  //
  // List of the tools selected by the user
  List<Tool> selectedToolsList = [];
  // List of all the tools fetched from the database
  List<Tool> toolsList = [];
  // List for the tools for filtering (by name)
  List<Tool> filteredToolsList = [];
  // Function to filter tools based on the entered keyword
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
  //

  // Function to fetch spare parts data from the database
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

  // Function to fetch tools data from the database
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

  // Function to fetch both spare parts and tools data from the database
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add an Intervention File",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
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
                  onSaved: (value) {
                    _fileName = value!;
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
                                      child:
                                          Text("Pick your custom duration :"),
                                    ),
                                    // Row containing buttons for increasing/decreasing custom duration
                                    Row(
                                      children: [
                                        //Icon button for decreasing the field count
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: IconButton.outlined(
                                            onPressed: () {
                                              int custionDuration = int.parse(
                                                  _customDurationController
                                                      .text);
                                              custionDuration--;
                                              setState(() {
                                                _customDurationController.text =
                                                    custionDuration.toString();
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.remove_rounded),
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
                                            controller:
                                                _customDurationController,
                                            suffexIcon: const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 16.0),
                                              child: Text(
                                                "days",
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "please provide a custom duration or use a preset";
                                              }
                                              if (int.parse(value) <= 0) {
                                                return "please provide a positive days count";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),

                                        //Icon button for increasing the field count
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: IconButton.outlined(
                                            onPressed: () {
                                              int custionDuration = int.parse(
                                                  _customDurationController
                                                      .text);
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
                            onSaved: (value) {
                              _breakDownDescription = value!;
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please provide a starting day";
                          }
                          return null;
                        },
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
                              tooltip:
                                  "press to select a day from the calender",
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
                  onSaved: (value) {
                    _interventionTask = value!;
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
                // Card widget containing a CheckboxListTile for selecting Instrument Technician technician
                TechnicianCard(
                  title: "Instrument Technician",
                  subtitle:
                      "An instrument technician execute the intervention.",
                  checkboxValue: _isInstrumentTechnicianSelected,
                  onChanged: (value) {
                    setState(() {
                      _isInstrumentTechnicianSelected =
                          !_isInstrumentTechnicianSelected;
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
                                      selectedSparePartsList.remove(
                                          selectedSparePartsList[index]);
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
                      itemCount: filteredToolsList.length,
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
                                      selectedToolsList[index].isSelected =
                                          false;
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
                Center(
                  child: FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text(
                              "Do you want to add this intervention file ?",
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        //check if the tool or the spare parts selection list are empty
                                        //if empty (at least one) show a snack bar
                                        if (selectedSparePartsList.isEmpty ||
                                            selectedToolsList.isEmpty) {
                                          //close the confirmation alert
                                          Navigator.pop(context);
                                          //show snack bar with a message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "please select spare parts and tools",
                                              ),
                                            ),
                                          );
                                        } else {
                                          //if not empty (both)
                                          _formkey.currentState!.save();
                                          //Map the forcat to it value in day
                                          int forcast =
                                              PreventiveInterventionFile
                                                  .mapTimePeriodToDays(
                                            selectedTimePeriod:
                                                _initialTimePeriod,
                                            customPeriodValue: int.parse(
                                                _customDurationController.text),
                                          );
                                          //creating a document ID for the intervention file
                                          String fileID = const Uuid().v4();
                                          //add file to db
                                          await InterventionFileModel()
                                              .addInterventionFileDB(
                                            creatorID: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            createdAt: Timestamp.now(),
                                            equipmentID: widget.equipmentID,
                                            equipmentTagName:
                                                widget.equipmentTagName,
                                            equipmentStatus:
                                                widget.equipmentStatus,
                                            equipmentDiscipline:
                                                widget.equipmentDiscipline,
                                            fileID: fileID,
                                            fileName: _fileName,
                                            maintenanceType:
                                                _initialIntervnetionType,
                                            startingDay:
                                                _startingDateController.text,
                                            interventionTask: _interventionTask,
                                            mechanicalTechnician:
                                                _isMechanicalTechnicianSelected,
                                            electricalTechnician:
                                                _isElectricalTechnicianSelected,
                                            instrumentTechnician:
                                                _isInstrumentTechnicianSelected,
                                            spareParts: selectedSparePartsList,
                                            tools: selectedToolsList,
                                            fileStatus: "In Progress",
                                            forecast: forcast,
                                            criticity: _initialCritciality,
                                            breakDownType:
                                                _initialBreakDownType,
                                            breakDownDescription:
                                                _breakDownDescription,
                                          );
                                          //getting the list of admins that will be notified
                                          List<String> adminsTokens =
                                              await NotificationsModel()
                                                  .getAdminsTokens(
                                            equipmentDiscipline:
                                                widget.equipmentDiscipline,
                                          );
                                          //creating a notification title
                                          String notifTitle =
                                              "Requesting Validation";
                                          String notifBody =
                                              "an new intervention file for ${widget.equipmentTagName} was created";
                                          //getting the current user ID
                                          String userId = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          //getting the stored token
                                          String? currentUserToken;
                                          await FirebaseFirestore.instance
                                              .collection(userCollectionRef)
                                              .doc(userId)
                                              .get()
                                              .then(
                                            (DocumentSnapshot doc) {
                                              Map<String, dynamic> data =
                                                  doc.data()
                                                      as Map<String, dynamic>;
                                              currentUserToken =
                                                  data["FCMtoken"];
                                            },
                                          );
                                          //sending psu notification to admins of that didcipline
                                          NotificationsModel()
                                              .sendIFValidationRequestNotification(
                                            adminsTokens: adminsTokens,
                                            equipmentDiscipline:
                                                widget.equipmentDiscipline,
                                            notificationTitle: notifTitle,
                                            notificationBody: notifBody,
                                          );
                                          //adding a notification document to
                                          //admins of that dscipline
                                          //notifications subcollection
                                          NotificationsModel()
                                              .addInterventionFileValidationNotification(
                                            notificationTitle: notifTitle,
                                            notificationBody: notifBody,
                                            interventionFileCreatorToken:
                                                currentUserToken!,
                                            interventionFileID: fileID,
                                            interventionType:
                                                _initialIntervnetionType,
                                            equipmentTagName:
                                                widget.equipmentTagName,
                                            equipmentDiscipline:
                                                widget.equipmentDiscipline,
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "intervention file added successfully",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      } else {
                                        //close the confirmation alert when for is not valid
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Confirm"),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Add Intervention File"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
