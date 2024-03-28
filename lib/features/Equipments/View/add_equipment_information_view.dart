import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../firebase/cloud_firestore_references.dart';
import 'alerts/equipment_camera_permission_denied_alert.dart';
import 'alerts/equipment_location_permission_denied_alert.dart';
import 'alerts/equipment_location_service_alert.dart';

// Define an enumeration for equipment priorities
enum Priority {
  // ignore: constant_identifier_names
  High,
  // ignore: constant_identifier_names
  Medium,
  // ignore: constant_identifier_names
  Low,
}

// Extension to convert enum values to strings
extension PriorityToString on Priority {
  String priorityToShortString() {
    return toString().split('.').last;
  }
}

enum Status {
  // ignore: constant_identifier_names
  Active,
  // ignore: constant_identifier_names
  Standby,
  // ignore: constant_identifier_names
  Shutdown
}

// Extension to convert enum values to strings
extension StatusToString on Status {
  String statusToShortString() {
    return toString().split('.').last;
  }
}

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

  // Variables to store equipment details
  String _photoURL = "";
  String _tagName = "";
  String _area = "";
  String _workShop = "";
  String _discipline = "";
  String _description = "";
  //controllers for the latitude and longitude fields
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  //initial value of the priority
  Priority defaultPriority = Priority.Medium;
  //initial value of the status
  Status defaultStatus = Status.Active;
  //a boolean flag to check if the Tagname is unique
  bool isTagNameNotUnique = false;

  //Future methode to check if the tag name is unique or not
  Future<bool> checkDocumentExistence(
    String collectionName,
    String documentId,
  ) async {
    // Get a reference to the document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    // Get the document snapshot
    DocumentSnapshot docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  // Variable to store the selected image file
  File? selectedImageFile;

  // Future method to pick an image from the gallery or camera
  Future<CroppedFile?> pickImage({
    required ImageSource imageSource,
  }) async {
    // Use ImagePicker to pick an image
    ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );
    if (pickedImage != null) {
      // Crop the selected image using the ImageCropper package
      ImageCropper cropper = ImageCropper();
      CroppedFile? croppedFile = await cropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxHeight: 96,
        maxWidth: 96,
      );
      if (croppedFile != null) {
        return croppedFile;
      } else {
        return null;
      }
    }
    return null;
  }

  // Variable to store the selected image file
  File? userManualFile;

  Future<File?> getUserManual() async {
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
                  child: selectedImageFile != null
                      ? SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.file(
                                selectedImageFile!,
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
              Padding(
                // Buttons for selecting an image from the gallery or camera
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      icon: Icon(
                        Icons.add_a_photo_outlined,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(2),
                        backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                      onPressed: () async {
                        // Handle camera permissions and image picking
                        await Permission.camera.onDeniedCallback(() {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const EquipmentCameraPermissionDeniedAlert(),
                              barrierDismissible: false,
                            );
                          }
                        }).onGrantedCallback(() async {
                          CroppedFile? pickedImge = await pickImage(
                            imageSource: ImageSource.gallery,
                          );
                          if (pickedImge != null) {
                            selectedImageFile = File(pickedImge.path);
                          } else {
                            selectedImageFile = null;
                          }
                          setState(() {});
                        }).onPermanentlyDeniedCallback(() {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const EquipmentCameraPermissionDeniedAlert(),
                              barrierDismissible: false,
                            );
                          }
                        }).request();
                      },
                      label: Text(
                        "Gallery",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FilledButton.icon(
                      icon: Icon(
                        Icons.add_a_photo_outlined,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(2),
                        backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                      onPressed: () async {
                        // Handle camera permissions and image picking
                        await Permission.camera.onDeniedCallback(() {
                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    const EquipmentCameraPermissionDeniedAlert(),
                                barrierDismissible: false);
                          }
                        }).onGrantedCallback(() async {
                          CroppedFile? pickedImge = await pickImage(
                            imageSource: ImageSource.camera,
                          );
                          if (pickedImge != null) {
                            selectedImageFile = File(pickedImge.path);
                          } else {
                            selectedImageFile = null;
                          }
                          setState(() {});
                        }).onPermanentlyDeniedCallback(() {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const EquipmentCameraPermissionDeniedAlert(),
                              barrierDismissible: false,
                            );
                          }
                        }).request();
                      },
                      label: Text(
                        "Camera",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Form fields for entering equipment details
              // Tag Name
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Tag name",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              // Tag Name input field
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter the Tag name",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.local_offer_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.grey.shade500;
                      },
                    ),
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
              ),
              // Form fields for entering equipment details
              // Area
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Area",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                // Area input field
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter the Area ",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.grey.shade500;
                      },
                    ),
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
              ),
              // Form fields for entering equipment details
              // Workshop
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Workshop",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                // Workshop input field
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter the Workshop",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.build_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.grey.shade500;
                      },
                    ),
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "please provide a workshop";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _workShop = newValue!.trim();
                  },
                ),
              ),
              // Form fields for entering equipment details
              // Discipline
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Discipline",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                // Discipline input field
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter the Discipline",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.build_circle_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.grey.shade500;
                      },
                    ),
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "please provide an discipline";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _discipline = newValue!.trim();
                  },
                ),
              ),
              // Form fields for entering equipment details
              // Description
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                // Description input field
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter a brief Description",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(
                        Icons.description_outlined,
                      ),
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.grey.shade500;
                      },
                    ),
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "please provide a description";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _description = newValue!.trim();
                  },
                ),
              ),
              // Form fields for entering equipment details
              // Description
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Location",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "latitude",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 24,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          // Description input field
                          child: TextFormField(
                            enabled: false,
                            controller: latitudeController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              hintText: "latitude value",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              prefixIconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary;
                                  }
                                  if (states.contains(MaterialState.error)) {
                                    return Theme.of(context).colorScheme.error;
                                  }
                                  return Colors.grey.shade500;
                                },
                              ),
                            ),
                            validator: (value) {
                              //create a email validation
                              if (value == null || value.isEmpty) {
                                return "please provide a latitude";
                              }
                              return null;
                            },

                            // onSaved: (newValue) {
                            //   _description = newValue!.trim();
                            // },
                          ),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "longitude",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 24,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          // Description input field
                          child: TextFormField(
                            enabled: false,
                            controller: longitudeController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              hintText: "longitude value",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              prefixIconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary;
                                  }
                                  if (states.contains(MaterialState.error)) {
                                    return Theme.of(context).colorScheme.error;
                                  }
                                  return Colors.grey.shade500;
                                },
                              ),
                            ),
                            validator: (value) {
                              //create a email validation
                              if (value == null || value.isEmpty) {
                                return "please provide a longitude";
                              }
                              return null;
                            },

                            // onSaved: (newValue) {
                            //   _description = newValue!.trim();
                            // },
                          ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Priority",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: SegmentedButton(
                    segments: [
                      ButtonSegment(
                        value: Priority.Low,
                        label: Text(
                          "Low",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Ionicons.checkmark_circle_outline),
                      ),
                      ButtonSegment(
                        value: Priority.Medium,
                        label: Text(
                          "Medium",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Ionicons.information_circle_outline),
                      ),
                      ButtonSegment(
                        value: Priority.High,
                        label: Text(
                          "High",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Ionicons.alert_circle_outline),
                      ),
                    ],
                    selected: <Priority>{defaultPriority},
                    onSelectionChanged: (Set<Priority> newvalue) {
                      setState(() {
                        defaultPriority = newvalue.first;
                      });
                    },
                    showSelectedIcon: false,
                  ),
                ),
              ),

              // Segmented Button for entering equipment details
              // State
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "State",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: SegmentedButton(
                    segments: [
                      ButtonSegment(
                        value: Status.Standby,
                        label: Text(
                          "Standby",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Icons.pause_circle_outline),
                      ),
                      ButtonSegment(
                        value: Status.Active,
                        label: Text(
                          "Active",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Icons.access_time),
                      ),
                      ButtonSegment(
                        value: Status.Shutdown,
                        label: Text(
                          "Shutdown",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        icon: const Icon(Icons.power_off),
                      ),
                    ],
                    selected: <Status>{defaultStatus},
                    onSelectionChanged: (Set<Status> newvalue) {
                      setState(() {
                        defaultStatus = newvalue.first;
                      });
                    },
                    showSelectedIcon: false,
                  ),
                ),
              ),
              // field for add user manual
              // State
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "User Manual",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: GestureDetector(
                    onTap: () async {
                      // Handle File permissions and image picking
                      await Permission.manageExternalStorage
                          .onGrantedCallback(() async {
                        userManualFile = await getUserManual();
                        if (userManualFile != null) {
                          print(userManualFile!.path);
                        }
                      }).request();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_upload_outlined,
                          ),
                          Text(
                            "Tap this area to upload the user manual \n for the equipment",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Button to create new equipment
              Center(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () async {
                      // // Show a confirmation dialog before creating new equipment
                      // return showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text("Confirmation"),
                      //       content: const Text(
                      //         "Do you want to add this equipment ?",
                      //       ),
                      //       actions: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             TextButton(
                      //               onPressed: () => Navigator.pop(context),
                      //               child: Text(
                      //                 "Cancel",
                      //                 style: TextStyle(
                      //                   color: Theme.of(context)
                      //                       .colorScheme
                      //                       .primary,
                      //                 ),
                      //               ),
                      //             ),
                      //             TextButton(
                      //               onPressed: () async {
                      //                 // if (_formkey.currentState!.validate()) {
                      //                 //   _formkey.currentState!.save();
                      //                 //   isTagNameNotUnique =
                      //                 //       await checkDocumentExistence(
                      //                 //     tagNamesCollectionRef,
                      //                 //     _tagName,
                      //                 //   );
                      //                 //   if (isTagNameNotUnique) {
                      //                 //     if (context.mounted) {
                      //                 //       ScaffoldMessenger.of(context)
                      //                 //           .showSnackBar(
                      //                 //         const SnackBar(
                      //                 //           content: Text(
                      //                 //             "Tag name already exist! please provide a unique tag name",
                      //                 //           ),
                      //                 //         ),
                      //                 //       );
                      //                 //     }
                      //                 //   } else {
                      //                 //     String docId = const Uuid().v4();
                      //                 //     // createNewEquipment();
                      //                 //     if (selectedImageFile != null) {
                      //                 //       _photoURL = await DatabaseService()
                      //                 //           .addEquipmentPicture(
                      //                 //         equipmentPictureRef:
                      //                 //             "${_tagName}_profile_picture",
                      //                 //         equipmentPicture:
                      //                 //             selectedImageFile!,
                      //                 //       );
                      //                 //       DatabaseService().addEquipment(
                      //                 //         photoURL: _photoURL,
                      //                 //         tagName: _tagName,
                      //                 //         docId: docId,
                      //                 //         description: _description,
                      //                 //         area: _area,
                      //                 //         discipline: _discipline,
                      //                 //         workshop: _workShop,
                      //                 //         status: defaultStatus
                      //                 //             .statusToShortString(),
                      //                 //         priority: defaultPriority
                      //                 //             .priorityToShortString(),
                      //                 //         longitude:
                      //                 //             longitudeController.text,
                      //                 //         latitude:
                      //                 //             longitudeController.text,
                      //                 //       );
                      //                 //     } else {
                      //                 //       DatabaseService().addEquipment(
                      //                 //         tagName: _tagName,
                      //                 //         docId: docId,
                      //                 //         description: _description,
                      //                 //         area: _area,
                      //                 //         discipline: _discipline,
                      //                 //         workshop: _workShop,
                      //                 //         status: defaultStatus
                      //                 //             .statusToShortString(),
                      //                 //         priority: defaultPriority
                      //                 //             .priorityToShortString(),
                      //                 //         longitude:
                      //                 //             longitudeController.text,
                      //                 //         latitude: latitudeController.text,
                      //                 //       );
                      //                 //     }
                      //                 //   }
                      //                 //   if (context.mounted) {
                      //                 //     Navigator.pop(context);
                      //                 //     Navigator.push(
                      //                 //       context,
                      //                 //       MaterialPageRoute(
                      //                 //         builder: (context) =>
                      //                 //             const Home(),
                      //                 //       ),
                      //                 //     );
                      //                 //   }
                      //                 // } else {
                      //                 //   Navigator.pop(context);
                      //                 // }
                      //               },
                      //               child: const Text("Confirm"),
                      //             )
                      //           ],
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
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
