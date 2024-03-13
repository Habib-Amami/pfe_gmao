import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/Equipments/View/alerts/equipment_camera_permission_denied_alert.dart';

import '../../../firebase/cloud_firestore_references.dart';

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
extension StatusToString on Priority {
  String statusToShortString() {
    return toString().split('.').last;
  }
}

class AddEquipmentPage extends StatefulWidget {
  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => AddEquipmentPageState();
}

class AddEquipmentPageState extends State<AddEquipmentPage> {
  // Variable to store the selected image file
  File? selectedImageFile;

  // Variables to store equipment details
  String _tagName = "";
  String _area = "";
  String _workShop = "";
  String _discipline = "";
  String _priority = "";
  String _status = "";
  String _description = "";

  late bool equipmentStatus;

  // Future method to pick an image from the gallery or camera
  Future<CroppedFile?> pickImage({required ImageSource imageSource}) async {
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

  Priority defaultPriority = Priority.Medium;

  Status defaultStatus = Status.Active;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new equipment"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  // Display the selected image or a default image
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: selectedImageFile != null
                        ? CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(48),
                              child: Image.file(
                                selectedImageFile!,
                                height: 96,
                                width: 96,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 50,
                            child: const CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  NetworkImage(defaultEquipmentPicture),
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
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(2),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.secondaryContainer),
                        ),
                        onPressed: () async {
                          // Handle camera permissions and image picking
                          await Permission.camera.onDeniedCallback(() {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const EquipmentCameraPermissionDeniedAlert(),
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
                              );
                            }
                          }).request();
                        },
                        label: const Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      FilledButton.icon(
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(2),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.secondaryContainer),
                        ),
                        onPressed: () async {
                          // Handle camera permissions and image picking
                          await Permission.camera.onDeniedCallback(() {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const EquipmentCameraPermissionDeniedAlert(),
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
                              );
                            }
                          }).request();
                        },
                        label: const Text(
                          "Camera",
                          style: TextStyle(
                            color: Colors.black,
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
                      //create a email validation
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
                      segments: const [
                        ButtonSegment(
                          value: Priority.Low,
                          label: Text("Low"),
                          icon: Icon(Ionicons.checkmark_circle_outline),
                        ),
                        ButtonSegment(
                          value: Priority.Medium,
                          label: Text("Medium"),
                          icon: Icon(Ionicons.information_circle_outline),
                        ),
                        ButtonSegment(
                          value: Priority.High,
                          label: Text("High"),
                          icon: Icon(Ionicons.alert_circle_outline),
                        ),
                      ],
                      selected: <Priority>{defaultPriority},
                      onSelectionChanged: (Set<Priority> newvalue) {
                        setState(() {
                          defaultPriority = newvalue.first;
                          _priority = defaultPriority.priorityToShortString();
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
                      segments: const [
                        ButtonSegment(
                          value: Status.Standby,
                          label: Text("Standby"),
                          icon: Icon(Icons.pause_circle_outline),
                        ),
                        ButtonSegment(
                          value: Status.Active,
                          label: Text("Active"),
                          icon: Icon(Icons.access_time),
                        ),
                        ButtonSegment(
                          value: Status.Shutdown,
                          label: Text("Shutdown"),
                          icon: Icon(Icons.power_off),
                        ),
                      ],
                      selected: <Status>{defaultStatus},
                      onSelectionChanged: (Set<Status> newvalue) {
                        setState(() {
                          defaultStatus = newvalue.first;
                          _status = defaultPriority.priorityToShortString();
                        });
                      },
                      showSelectedIcon: false,
                    ),
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
                  padding: const EdgeInsets.only(bottom: 16),
                  // Description input field
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
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
                                      onPressed: () {
                                        // createNewEquipment();
                                        Navigator.pop(context);
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

  // Future<void> createNewEquipment() async {
  //   FirebaseFirestore.instance.collection("equipments").add({
  //     'TagName': tagNameTextEditingController.text,
  //     'Description': descriptionTextEditingController.text,
  //     'Status': false,
  //     'Photo': '',
  //     'Area': areaEditingController.text,
  //     'CreatedOn': Timestamp.now(),
  //     'UpdatedOn': Timestamp.now(),
  //     'Workshop': workshopEditingController.text,
  //     'Discipline': disciplineEditingController.text,
  //   });
  //   tagNameTextEditingController.clear();
  //   descriptionTextEditingController.clear();
  //   areaEditingController.clear();
  //   disciplineEditingController.clear();
  //   workshopEditingController.clear();
  // }
}
