import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_form_field.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_segmented_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../firebase/cloud_firestore_references.dart';
import '../../../../home.dart';
import '../../services/db_service.dart';
import '../alerts/equipment_location_permission_denied_alert.dart';
import '../alerts/equipment_location_service_alert.dart';
import '../edit_equipment_page.dart';
import '../widgets/equipment_image_button.dart';
import '../widgets/equipment_form_title.dart';

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

  // Variables to store equipment discipline information
  final List disciplineValueList = ['Mechanics', 'Electrics', 'Instrumental'];
  String disciplineValue = 'Mechanics';

  // Variables to store equipment workshop information
  final List workshopValueList = ['QTTF', 'PGTF', 'GNTF'];
  String workshopValue = 'QTTF';
  // Form key for managing the state of the add equipment form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
  List<File> otherFiles = [];

  Future<File?> getSinglePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  Future<List<File>> getMultiplePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      return [];
    }
  }

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                // Display the selected image or a default image
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: equipmentPictureFile != null
                      ? SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.file(
                                equipmentPictureFile!,
                                height: 145,
                                width: 145,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 150,
                            child: const CircleAvatar(
                              radius: 72,
                              backgroundImage:
                                  NetworkImage(defaultEquipmentPicture),
                            ),
                          ),
                        ),
                ),
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: DropdownButtonFormField(
                    padding: const EdgeInsets.only(right: 16),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.build_outlined,
                      ),
                      border: InputBorder.none,
                    ),
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
                ),
              ),
              // Form fields for entering equipment details
              // Discipline
              const EquipmentFormTitle(
                title: "Discipline",
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: DropdownButtonFormField(
                    padding: const EdgeInsets.only(right: 16),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.build_circle_outlined,
                      ),
                      border: InputBorder.none,
                    ),
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
                ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: FilledButton.icon(
                    icon: Icon(
                      Icons.my_location_outlined,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(2),
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                    onPressed: () async {
                      // Handle location permissions and image picking
                      await Permission.location.onDeniedCallback(() {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const EquipmentLocationPermissionDeniedAlert(),
                          );
                        }
                      }).onGrantedCallback(() async {
                        bool serviceEnabled =
                            await Geolocator.isLocationServiceEnabled();
                        if (serviceEnabled) {
                          Position currentPosition =
                              await Geolocator.getCurrentPosition();

                          _formkey.currentState!.setState(() {
                            latitudeController.text =
                                currentPosition.latitude.toString();

                            longitudeController.text =
                                currentPosition.longitude.toString();
                          });
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const EquipmentLocationServiceAlert(),
                              barrierDismissible: false,
                            );
                          }
                        }
                      }).onPermanentlyDeniedCallback(() {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const EquipmentLocationPermissionDeniedAlert(),
                          );
                        }
                      }).request();
                    },
                    label: Text(
                      "Locate equipment",
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
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

              const EquipmentFormTitle(
                title: "User Manual",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: userManualFile == null
                      ? GestureDetector(
                          onTap: () async {
                            // Handle File permissions and image picking
                            await Permission.manageExternalStorage
                                .onGrantedCallback(
                              () async {
                                userManualFile = await getSinglePDF();
                                setState(() {});
                              },
                            ).request();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                ),
                                Text(
                                  "Tap this area to upload the user manual \n for the equipment (pdf)",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? "assets/light_pdf.svg"
                                  : "assets/dark_pdf.svg",
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => OpenFilex.open(
                                  userManualFile!.absolute.path,
                                ),
                                child: Text(
                                  userManualFile!.path.split("/").last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  userManualFile = null;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              ),
                            )
                          ],
                        ),
                ),
              ),
              //
              // field for add contract pdf
              //
              const EquipmentFormTitle(
                title: "Contract",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: contractFile == null
                      ? GestureDetector(
                          onTap: () async {
                            // Handle File permissions and image picking
                            await Permission.manageExternalStorage
                                .onGrantedCallback(
                              () async {
                                contractFile = await getSinglePDF();
                                setState(() {});
                              },
                            ).request();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                ),
                                Text(
                                  "Tap this area to upload the contract \n for the equipment (pdf)",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? "assets/light_pdf.svg"
                                  : "assets/dark_pdf.svg",
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => OpenFilex.open(
                                  contractFile!.absolute.path,
                                ),
                                child: Text(
                                  contractFile!.path.split("/").last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  contractFile = null;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              ),
                            )
                          ],
                        ),
                ),
              ),
              //
              // field for other related equipment pdf files
              //
              const EquipmentFormTitle(
                title: "Other",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: otherFiles.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: GestureDetector(
                          onTap: () async {
                            // Handle File permissions and image picking
                            await Permission.manageExternalStorage
                                .onGrantedCallback(
                              () async {
                                otherFiles = await getMultiplePDF();
                                setState(() {});
                              },
                            ).request();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                ),
                                Text(
                                  "Tap this area to upload other related files\n for the equipment (pdf)",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ...otherFiles.map(
                            (file) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? "assets/light_pdf.svg"
                                        : "assets/dark_pdf.svg",
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => OpenFilex.open(
                                        file.absolute.path,
                                      ),
                                      child: Text(
                                        file.path.split("/").last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        otherFiles.remove(
                                          file,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              File? addedFile = await getSinglePDF();
                              if (addedFile != null) {
                                setState(() {
                                  otherFiles.add(
                                    addedFile,
                                  );
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                          ),
                        ],
                      ),
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
                                          collectionName: tagNamesCollectionRef,
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
                                            _photoURL = await DatabaseService()
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
                                              latitude: latitudeController.text,
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
    );
  }
}
