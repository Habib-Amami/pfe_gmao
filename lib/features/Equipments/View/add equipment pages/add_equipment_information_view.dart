import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_picture_avatar.dart';
import 'package:uuid/uuid.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../../../home.dart';
import '../../services/db_service.dart';
import '../edit_equipment_page.dart';
import '../widgets/equipment_dropdown_menu.dart';
import '../widgets/equipment_file_preview.dart';
import '../widgets/equipment_file_upload_container.dart';
import '../widgets/equipment_form_field.dart';
import '../widgets/equipment_form_title.dart';
import '../widgets/equipment_image_button.dart';
import '../widgets/equipment_location_button.dart';
import '../widgets/equipment_segmented_button.dart';

class AddEquipmentInformationScreen extends StatefulWidget {
  const AddEquipmentInformationScreen({super.key});

  @override
  State<AddEquipmentInformationScreen> createState() =>
      _AddEquipmentInformationScreenState();
}

class _AddEquipmentInformationScreenState
    extends State<AddEquipmentInformationScreen> {
  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  // Form key for managing the state of the add equipment form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Variables to store equipment discipline information
  final List disciplineValueList = ['Mechanics', 'Electrics', 'Instrumental'];
  String disciplineValue = 'Mechanics';

  // Variables to store equipment workshop information
  final List workshopValueList = ['QTTF', 'PGTF', 'GNTF'];
  String workshopValue = 'QTTF';

  // Variables to store equipment details
  String _photoURL = "";
  String _tagName = "";
  String _area = "";
  String _description = "";

  //controllers for the latitude and longitude fields
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  //initial value of the priority
  Priority defaultPriority = Priority.Medium;
  //initial value of the status
  Status defaultStatus = Status.Standby;

  //a boolean flag to check if the Tagname is unique
  bool isTagNameNotUnique = false;

  // Variable to store the selected image file
  File? equipmentPictureFile;

  // Variable to store the selected image file
  File? userManualFile;
  File? contractFile;
  List<File>? otherFiles;

  Future<String> uploadUserManual({
    required String equipmentUserManualRef,
    required File userManualFile,
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference equipmentUserManuelsDir =
        rootReference.child(equipmentUserManualsDir);
    Reference userManualRef =
        equipmentUserManuelsDir.child(equipmentUserManualRef);
    // Upload the profile picture file to Firebase Storage
    await userManualRef.putFile(
      userManualFile,
      SettableMetadata(
        contentType: 'application/pdf',
      ),
    );
    // Get the download URL of the uploaded image
    return await userManualRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Durations.medium4).then(
          (_) {
            _formkey.currentState!.reset();
            equipmentPictureFile = null;
            userManualFile = null;
            contractFile = null;
            otherFiles = null;
            longitudeController.clear();
            latitudeController.clear();
            defaultPriority = Priority.Medium;
            defaultStatus = Status.Standby;
            workshopValue = 'QTTF';
            disciplineValue = 'Mechanics';
          },
        );
      },
      child: SingleChildScrollView(
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
                  equipmentPictureFile: equipmentPictureFile,
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
                            equipmentPictureFile = imageFile;
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
                            equipmentPictureFile = imageFile;
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
                  },
                ),
                // Form fields for entering equipment details
                // Area
                const EquipmentFormTitle(
                  title: "Area",
                ),
                EquipmentFormField(
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
                  value: workshopValue,
                  onChanged: (value) {
                    setState(() {
                      workshopValue = value as String;
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
                  value: disciplineValue,
                  onChanged: (value) {
                    setState(() {
                      disciplineValue = value as String;
                    });
                  },
                ),
                // Form fields for entering equipment details
                // Description
                const EquipmentFormTitle(
                  title: "Description",
                ),
                EquipmentFormField(
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
                  selected: <Priority>{defaultPriority},
                  onSelectionChanged: (Set<Priority> newvalue) {
                    setState(() {
                      defaultPriority = newvalue.first;
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
                  selected: <Status>{defaultStatus},
                  onSelectionChanged: (Set<Status> newvalue) {
                    setState(() {
                      defaultStatus = newvalue.first;
                    });
                  },
                ),
                //
                // field for user manual pdf
                //
                const EquipmentFormTitle(
                  title: "User Manual",
                ),
                userManualFile == null
                    ? FileUploadContainer(
                        // Render FileUploadContainer if no file is selected
                        allowMultiple: false,
                        label:
                            "Tap this area to upload the user manual for the equipment (pdf)",
                        onFileSelected: (files) {
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              userManualFile = files.first;
                            });
                          } else {
                            userManualFile = null;
                          }
                        },
                      )
                    : FilePreviewContainer(
                        // Render FilePreviewContainer if a file is selected
                        file: userManualFile,
                        onFileDeleted: () {
                          setState(() {
                            userManualFile = null;
                          });
                        },
                      ),
                //
                // field for add contract pdf
                //
                const EquipmentFormTitle(
                  title: "Contract",
                ),
                contractFile == null
                    // Render FileUploadContainer if no file is selected
                    ? FileUploadContainer(
                        allowMultiple: false,
                        label:
                            "Tap this area to upload the contract manual for the equipment (pdf)",
                        onFileSelected: (files) {
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              contractFile = files.first;
                            });
                          } else {
                            contractFile = null;
                          }
                        },
                      )
                    // Render FilePreviewContainer if a file is selected
                    : FilePreviewContainer(
                        file: contractFile,
                        onFileDeleted: () {
                          setState(() {
                            contractFile = null;
                          });
                        },
                      ),
                //
                // field for other related equipment pdf files
                //
                const EquipmentFormTitle(
                  title: "Other",
                ),
                otherFiles == null
                    ? FileUploadContainer(
                        allowMultiple: true,
                        label:
                            "Tap this area to upload the other related files for the equipment (pdf)",
                        onFileSelected: (files) {
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              otherFiles = files;
                            });
                          } else {
                            otherFiles = null;
                          }
                        },
                      )
                    : Column(
                        children: [
                          ...otherFiles!.map(
                            (file) => FilePreviewContainer(
                              file: file,
                              onFileDeleted: () {
                                setState(() {
                                  otherFiles!.remove(file);
                                });
                              },
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              List<File>? addedFile =
                                  await FileUploadContainer.getPDF(
                                allowMultiple: false,
                              );
                              if (addedFile != null) {
                                setState(() {
                                  otherFiles!.add(
                                    addedFile.first,
                                  );
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                          ),
                        ],
                      ),

                // Button to create new equipment
                Center(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        // Show a confirmation dialog before creating new equipment
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                "Do you want to add this equipment ?",
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
                                          _formkey.currentState!.save();
                                          isTagNameNotUnique =
                                              await DatabaseService
                                                  .checkDocumentExistence(
                                            collectionName:
                                                tagNamesCollectionRef,
                                            documentId: _tagName,
                                          );
                                          if (isTagNameNotUnique) {
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
                                            String docId = const Uuid().v4();
                                            // createNewEquipment();
                                            if (equipmentPictureFile != null) {
                                              _photoURL =
                                                  await DatabaseService()
                                                      .addEquipmentPicture(
                                                equipmentPictureRef:
                                                    "${_tagName}_profile_picture",
                                                equipmentPicture:
                                                    equipmentPictureFile!,
                                              );
                                              DatabaseService().addEquipment(
                                                photoURL: _photoURL,
                                                tagName: _tagName,
                                                docId: docId,
                                                description: _description,
                                                area: _area,
                                                discipline: disciplineValue,
                                                workshop: workshopValue,
                                                status: defaultStatus
                                                    .statusToShortString(),
                                                priority: defaultPriority
                                                    .priorityToShortString(),
                                                longitude:
                                                    longitudeController.text,
                                                latitude:
                                                    longitudeController.text,
                                              );
                                            } else {
                                              DatabaseService().addEquipment(
                                                tagName: _tagName,
                                                docId: docId,
                                                description: _description,
                                                area: _area,
                                                discipline: disciplineValue,
                                                workshop: workshopValue,
                                                status: defaultStatus
                                                    .statusToShortString(),
                                                priority: defaultPriority
                                                    .priorityToShortString(),
                                                longitude:
                                                    longitudeController.text,
                                                latitude:
                                                    latitudeController.text,
                                              );
                                            }
                                          }
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home(),
                                              ),
                                            );
                                          }
                                        } else {
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
                      child: const Text(
                        "Create new equipment",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
