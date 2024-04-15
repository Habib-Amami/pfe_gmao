// ignore_for_file: prefer_final_fields
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/Equipments/controller/equipment_controller.dart';
import 'package:pfe_gmao/features/Equipments/model/equipment_model.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

import '../model/data_models/discipline_list.dart';
import '../model/data_models/equipment.dart';
import '../model/data_models/priority_enum.dart';
import '../model/data_models/status_enum.dart';
import '../model/data_models/workshop_list.dart';
import 'widgets/form_widgets/equipment_dropdown_menu.dart';
import 'widgets/form_widgets/equipment_file_preview.dart';
import 'widgets/form_widgets/equipment_file_upload_container.dart';
import 'widgets/form_widgets/equipment_form_field.dart';
import 'widgets/form_widgets/equipment_form_title.dart';
import 'widgets/form_widgets/equipment_image_button.dart';
import 'widgets/form_widgets/equipment_location_button.dart';
import 'widgets/form_widgets/equipment_picture_avatar.dart';
import 'widgets/form_widgets/equipment_segmented_button.dart';

class EditEquipmentPage extends StatefulWidget {
  final Equipment equipment;

  const EditEquipmentPage({
    super.key,
    required this.equipment,
  });

  @override
  State<EditEquipmentPage> createState() => _EditEquipmentPageState();
}

class _EditEquipmentPageState extends State<EditEquipmentPage> {
  //equipmentController instance
  final EquipmentController _equipmentController = EquipmentController();

  // Form key for managing the state of the add equipment form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //a boolean flag to check if the Tagname is unique
  bool _isTagNameUnique = false;

  // Variable to store initial equipment TagName
  late String _initialTagName;
  // Variables to store equipment details
  // late String _photoURL;
  String _tagName = "";
  String _area = "";
  String _description = "";
  late String _userManualInitialURL;
  late String _contractInitialURL;

  //controllers for the form
  TextEditingController tagNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  // Variable to store the selected image file
  File? _equipmentPictureFile;

  // Variables to store equipment discipline information
  late String _disciplineValue;
  // Variables to store equipment workshop information
  late String _workshopValue;

  // Variable to store the equipment user manual file
  File? _userManualFile;

  // Variable to store the equipment contract file
  File? _contractFile;

  //initial value of the priority
  late Priority _defaultPriority;

  //initial value of the status
  late Status _defaultStatus;

  @override
  void initState() {
    super.initState();
    if (widget.equipment.Priority == 'Medium') {
      _defaultPriority = Priority.Medium;
    } else if (widget.equipment.Priority == 'High') {
      _defaultPriority = Priority.High;
    } else {
      _defaultPriority = Priority.Low;
    }

    if (widget.equipment.Status == 'Active') {
      _defaultStatus = Status.Active;
    } else if (widget.equipment.Status == 'Standby') {
      _defaultStatus = Status.Standby;
    } else {
      _defaultStatus = Status.Shutdown;
    }
    _initialTagName = widget.equipment.TagName;
    _contractInitialURL = widget.equipment.contract;
    _userManualInitialURL = widget.equipment.userManual;
    tagNameController = TextEditingController(text: widget.equipment.TagName);
    areaController = TextEditingController(text: widget.equipment.Area);
    descriptionController =
        TextEditingController(text: widget.equipment.Description);
    // _photoURL = widget.equipment.Photo;
    _disciplineValue = widget.equipment.Discipline;
    _workshopValue = widget.equipment.Workshop;
    latitudeController.text = widget.equipment.Latitude;
    longitudeController.text = widget.equipment.Longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Equipment"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the selected image or a default image
                EquipmentPictureAvatar(
                  equipmentPictureFile: _equipmentPictureFile,
                  defaultPictureURL: widget.equipment.Photo,
                ),
                // Buttons for selecting an image from the gallery or camera
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //custom button to select equipment image from gallery
                      EquipmentPictureButton(
                        buttonLable: "Gallery",
                        imageSource: ImageSource.gallery,
                        onImageSelected: (File? imageFile) {
                          setState(() {
                            _equipmentPictureFile = imageFile;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //custom button to select equipment image from camera
                      EquipmentPictureButton(
                        buttonLable: "Camera",
                        imageSource: ImageSource.camera,
                        onImageSelected: (File? imageFile) {
                          setState(() {
                            _equipmentPictureFile = imageFile;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Form fields for entering equipment details
                // Tag Name
                const EquipmentFormTitle(
                  title: "Tag name",
                ),
                EquipmentFormField(
                  controller: tagNameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: "Enter the Tag name",
                  prefixIcon: const Icon(
                    Icons.local_offer_outlined,
                  ),
                  validator: (value) {
                    //create a tag name validation
                    if (value == null || value.isEmpty) {
                      return "please provide an tag name";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _tagName = newValue!.trim();
                    tagNameController.text = _tagName;
                  },
                  //initialValue: widget.equipment.TagName,
                ),
                // Form fields for entering equipment details
                // Area
                const EquipmentFormTitle(
                  title: "Area",
                ),
                EquipmentFormField(
                  controller: areaController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: "Enter the Area ",
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "please provide an area";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _area = newValue!.trim();
                    areaController.text = _area;
                  },
                ),
                // Form fields for entering equipment details
                // Workshop
                const EquipmentFormTitle(
                  title: "Workshop",
                ),
                EquipmentDropDownMenu(
                  items: workshopValueList
                      .map(
                        (workshop) => DropdownMenuItem(
                          value: workshop,
                          child: Text(workshop),
                        ),
                      )
                      .toList(),
                  value: _workshopValue,
                  onChanged: (value) {
                    setState(() {
                      _workshopValue = value as String;
                    });
                  },
                ),
                // Form fields for entering equipment details
                // Discipline
                const EquipmentFormTitle(
                  title: "Discipline",
                ),
                EquipmentDropDownMenu(
                  items: disciplineValueList
                      .map(
                        (discipline) => DropdownMenuItem(
                          value: discipline,
                          child: Text(discipline),
                        ),
                      )
                      .toList(),
                  value: _disciplineValue,
                  onChanged: (value) {
                    setState(() {
                      _disciplineValue = value as String;
                    });
                  },
                ),
                // Form fields for entering equipment details
                // Description
                const EquipmentFormTitle(
                  title: "Description",
                ),
                EquipmentFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  maxLength: 200,
                  hintText: "Enter a brief Description",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(
                      Icons.description_outlined,
                    ),
                  ),
                  validator: (value) {
                    //create a description validation
                    if (value == null || value.isEmpty) {
                      return "please provide a description";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _description = newValue!.trim();
                    descriptionController.text = _description;
                  },
                ),
                // Form fields for entering equipment location
                // Location
                const EquipmentFormTitle(
                  title: "Location",
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EquipmentFormTitle(
                          title: "latitude",
                          textStyle: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2 - 24,
                          child: EquipmentFormField(
                            enabled: false,
                            controller: latitudeController,
                            hintText: "latitude value",
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                            ),
                            validator: (value) {
                              //create a latitude validation
                              if (value == null || value.isEmpty) {
                                return "please provide a latitude";
                              }
                              return null;
                            },
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
                        EquipmentFormTitle(
                          title: "longitude",
                          textStyle: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2 - 24,
                          child: EquipmentFormField(
                            enabled: false,
                            controller: longitudeController,
                            hintText: "longitude value",
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                            ),
                            validator: (value) {
                              //create a latitude validation
                              if (value == null || value.isEmpty) {
                                return "please provide a longitude";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //button to get the equipment coords
                EquipmentLocationButton(
                  onPositionSelected: (position) {
                    _formkey.currentState!.setState(() {
                      latitudeController.text = position.latitude.toString();
                      longitudeController.text = position.longitude.toString();
                    });
                  },
                ),
                //note the the user when locating an equipment
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Note : Please make sure you are close to the equipment to accurately locate and save its coordinates.",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                // Segmented Button for entering equipment details
                // Priority
                const EquipmentFormTitle(
                  title: "Priority",
                ),
                EquipmentSegmentedButton<Priority>(
                  buttonSegmentIconsList: const [
                    Icon(Ionicons.alert_circle_outline),
                    Icon(Ionicons.information_circle_outline),
                    Icon(Ionicons.checkmark_circle_outline),
                  ],
                  enumValues: Priority.values,
                  selected: <Priority>{_defaultPriority},
                  onSelectionChanged: (Set<Priority> newvalue) {
                    setState(() {
                      _defaultPriority = newvalue.first;
                    });
                  },
                ),
                // Segmented Button for entering equipment details
                // State
                const EquipmentFormTitle(
                  title: "State",
                ),
                EquipmentSegmentedButton<Status>(
                  enumValues: Status.values,
                  buttonSegmentIconsList: const [
                    Icon(Icons.access_time),
                    Icon(Icons.pause_circle_outline),
                    Icon(Icons.power_off),
                  ],
                  selected: <Status>{_defaultStatus},
                  onSelectionChanged: (Set<Status> newvalue) {
                    setState(() {
                      _defaultStatus = newvalue.first;
                    });
                  },
                ),
                //
                // field for user manual pdf
                //
                const EquipmentFormTitle(
                  title: "User Manual",
                ),
                _userManualFile == null
                    ? FileUploadContainer(
                        // Render FileUploadContainer if no file is selected
                        allowMultiple: false,
                        label:
                            "Tap this area to upload the user manual for the equipment (pdf)",
                        onFileSelected: (files) {
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              _userManualFile = files.first;
                            });
                          } else {
                            _userManualFile = null;
                          }
                        },
                      )
                    : FilePreviewContainer(
                        // Render FilePreviewContainer if a file is selected
                        file: _userManualFile,
                        onFileDeleted: () {
                          setState(() {
                            _userManualFile = null;
                          });
                        },
                      ),
                //
                // field for add contract pdf
                //
                const EquipmentFormTitle(
                  title: "Contract",
                ),
                _contractFile == null
                    // Render FileUploadContainer if no file is selected
                    ? FileUploadContainer(
                        allowMultiple: false,
                        label:
                            "Tap this area to upload the contract manual for the equipment (pdf)",
                        onFileSelected: (files) {
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              _contractFile = files.first;
                            });
                          } else {
                            _contractFile = null;
                          }
                        },
                      )
                    // Render FilePreviewContainer if a file is selected
                    : FilePreviewContainer(
                        file: _contractFile,
                        onFileDeleted: () {
                          setState(() {
                            _contractFile = null;
                          });
                        },
                      ),
                //Action buttons for finishing editing or deleting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //finish editing button
                    FilledButton.icon(
                      onPressed: () async {
                        // Show a confirmation dialog before finsh editing the equipment new equipment
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                "Do you want to edit this equipment ?",
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
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
                                          _formkey.currentState!.save();
                                          print(_contractInitialURL);
                                          print(_userManualInitialURL);
                                          if (_tagName == _initialTagName) {
                                            try {
                                              _equipmentController
                                                  .updateEquipment(
                                                initialTagName: _initialTagName,
                                                tagName: tagNameController.text,
                                                docId: widget.equipment.id,
                                                description:
                                                    descriptionController.text,
                                                area: areaController.text,
                                                discipline: _disciplineValue,
                                                workshop: _workshopValue,
                                                status: _defaultStatus
                                                    .statusToShortString(),
                                                priority: _defaultPriority
                                                    .priorityToShortString(),
                                                longitude:
                                                    longitudeController.text,
                                                latitude:
                                                    latitudeController.text,
                                                photoURL:
                                                    widget.equipment.Photo,
                                                userManualURL:
                                                    widget.equipment.userManual,
                                                contractURL:
                                                    widget.equipment.contract,
                                                equipmentPictureFile:
                                                    _equipmentPictureFile,
                                                userManualFile: _userManualFile,
                                                contractFile: _contractFile,
                                              );
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                // Show success message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${tagNameController.text} updated successfully',
                                                    ),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }
                                            } on FirebaseException catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Failed to update document: ${e.message!}',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          } else {
                                            _isTagNameUnique =
                                                await EquipmentModel
                                                    .checkDocumentExistence(
                                              collectionName:
                                                  tagNamesCollectionRef,
                                              documentId: _tagName,
                                            );
                                            if (_isTagNameUnique) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Tag name already exist! please provide a unique tag name",
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              try {
                                                _equipmentController
                                                    .updateEquipment(
                                                  initialTagName:
                                                      _initialTagName,
                                                  tagName:
                                                      tagNameController.text,
                                                  docId: widget.equipment.id,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  area: areaController.text,
                                                  discipline: _disciplineValue,
                                                  workshop: _workshopValue,
                                                  status: _defaultStatus
                                                      .statusToShortString(),
                                                  priority: _defaultPriority
                                                      .priorityToShortString(),
                                                  longitude:
                                                      longitudeController.text,
                                                  latitude:
                                                      latitudeController.text,
                                                  photoURL:
                                                      widget.equipment.Photo,
                                                  userManualURL: widget
                                                      .equipment.userManual,
                                                  contractURL:
                                                      widget.equipment.contract,
                                                  equipmentPictureFile:
                                                      _equipmentPictureFile,
                                                  userManualFile:
                                                      _userManualFile,
                                                  contractFile: _contractFile,
                                                );
                                                if (context.mounted) {
                                                  // Show success message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${tagNameController.text} updated successfully',
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              } on FirebaseException catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to update document: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          }
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
                      label: const Text(
                        "Finish",
                      ),
                      icon: const Icon(
                        Icons.done_rounded,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () async {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                  'Are you sure you want to delete this equipment?',
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
                                        onPressed: () {
                                          // DatabaseService().deleteEquipment(
                                          //   idEquipment:
                                          //       equipmentData['id'],
                                          //   tagName:
                                          //       equipmentData['TagName'],
                                          //   photoURL:
                                          //       equipmentData['Photo'],
                                          // );
                                          // // Show success message
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     content: Text(equipmentData[
                                          //             tagName] +
                                          //         ' deleted successfully'),
                                          //   ),
                                          // );

                                          // // close the alert dialog
                                          // Navigator.pop(context);

                                          // // go back to home
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: ((context) =>
                                          //             const Home())));
                                        },
                                        child: const Text("Confirm"),
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.error,
                        ),
                      ),
                      label: const Text(
                        'Delete',
                      ),
                      icon: const Icon(
                        Icons.delete_rounded,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
