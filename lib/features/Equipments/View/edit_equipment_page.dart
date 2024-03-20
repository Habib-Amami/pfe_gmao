import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/Equipments/services/db_service.dart';
import 'package:pfe_gmao/home.dart';
import '../../../firebase/cloud_firestore_references.dart';
import '../model/equipment.dart';
import 'alerts/equipment_location_permission_denied_alert.dart';
import 'alerts/equipment_location_service_alert.dart';
import 'equipment_picture_bottom_sheet.dart';

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

class EditEquipmentPage extends StatefulWidget {
  //final String equipmentId;
  final Equipment equipment;
  const EditEquipmentPage(
      {super.key, required this.equipment, required String equipmentId});

  @override
  State<EditEquipmentPage> createState() => _EditEquipmentPageState();
}

class _EditEquipmentPageState extends State<EditEquipmentPage> {
  // Form key for managing the state of the add equipment form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //
  late Future<DocumentSnapshot> _equipmentFuture;

  late Priority defaultPriority;
  late Status defaultStatus;
  @override
  void initState() {
    super.initState();
    _equipmentFuture = FirebaseFirestore.instance
        .collection('equipments')
        .doc(widget.equipment.id)
        .get();
    if (widget.equipment.Priority == 'Medium') {
      defaultPriority = Priority.Medium;
    } else if (widget.equipment.Priority == 'High') {
      defaultPriority = Priority.High;
    } else {
      defaultPriority = Priority.Low;
    }

    if (widget.equipment.Status == 'Active') {
      defaultStatus = Status.Active;
    } else if (widget.equipment.Status == 'Standby') {
      defaultStatus = Status.Standby;
    } else {
      defaultStatus = Status.Shutdown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Equipment"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _equipmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Equipment not found'));
          }
          var equipmentData = snapshot.data!.data() as Map<String, dynamic>;
          // Variables to store equipment details
          TextEditingController _tagName =
              TextEditingController(text: equipmentData[tagName]);
          final TextEditingController _area =
              TextEditingController(text: equipmentData[area]);
          final TextEditingController _workShop =
              TextEditingController(text: equipmentData[workshop]);
          final TextEditingController _discipline =
              TextEditingController(text: equipmentData[discipline]);
          final TextEditingController _description =
              TextEditingController(text: equipmentData[description]);
          final TextEditingController longitudeController =
              TextEditingController(text: equipmentData[longitude]);
          final TextEditingController latitudeController =
              TextEditingController(text: equipmentData[latitude]);

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
                        padding: const EdgeInsets.only(bottom: 5),
                        child: SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 150,
                            child: CircleAvatar(
                              radius: 72,
                              backgroundImage:
                                  NetworkImage(equipmentData['Photo']),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(2),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return EquipmentPictureBottomSheet(
                                equipmentId: equipmentData['id'],
                                equipmentImageUrl: equipmentData['Photo'],
                                tagName: equipmentData['TagName'],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Change Equipment Picture",
                        ),
                      ),
                    ),
                    // Form fields for entering equipment details
                    // Tag Name
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
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
                        controller: _tagName,
                        //initialValue: equipmentData['TagName'],
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
                          _tagName.text = newValue!.trim();
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
                        controller: _area,
                        //initialValue: equipmentData['Area'],
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
                          _area.text = newValue!.trim();
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
                        //initialValue: equipmentData['Workshop'],
                        controller: _workShop,
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
                          _workShop.text = newValue!.trim();
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
                        controller: _discipline,
                        //initialValue: equipmentData['Discipline'],
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
                          _discipline.text = newValue!.trim();
                        },
                      ),
                    ),
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
                        //initialValue: equipmentData['Description'],
                        controller: _description,
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
                        validator: (value) {
                          //create a email validation
                          if (value == null || value.isEmpty) {
                            return "please provide a description";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _description.text = newValue!.trim();
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
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                    ),
                                    prefixIconColor:
                                        MaterialStateColor.resolveWith(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .primary;
                                        }
                                        if (states
                                            .contains(MaterialState.error)) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .error;
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
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                    ),
                                    prefixIconColor:
                                        MaterialStateColor.resolveWith(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .primary;
                                        }
                                        if (states
                                            .contains(MaterialState.error)) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .error;
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
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
                    // Button to create new equipment
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
                      padding: const EdgeInsets.only(bottom: 32),
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
                            });
                          },
                          showSelectedIcon: false,
                        ),
                      ),
                    ),
                    // Form fields for entering equipment details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to delete this equipment?'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                              DatabaseService().deleteEquipment(
                                                  equipmentData['id']);
                                              // Show success message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(equipmentData[
                                                          tagName] +
                                                      ' deleted successfully'),
                                                ),
                                              );

                                              // close the alert dialog
                                              Navigator.pop(context);

                                              // go back to home
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const Home())));
                                            },
                                            child: const Text("Confirm"),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: const Text(
                            'Delete this equipment',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            // Show a confirmation dialog before creating new equipment
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
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                            try {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                _formkey.currentState!
                                                    .validate();
                                                DocumentReference
                                                    documentReference =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'equipments')
                                                        .doc(widget
                                                            .equipment.id);
                                                Map<String, dynamic>
                                                    updatedEquipment = {
                                                  tagName: _tagName.text,
                                                  area: _area.text,
                                                  workshop: _workShop.text,
                                                  discipline: _discipline.text,
                                                  priority: defaultPriority
                                                      .priorityToShortString(),
                                                  status: defaultStatus
                                                      .statusToShortString(),
                                                  description:
                                                      _description.text,
                                                  updatedOn: Timestamp.now(),
                                                };

                                                //Update the document with the new data
                                                documentReference
                                                    .update(updatedEquipment);

                                                // Show success message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(equipmentData[
                                                            tagName] +
                                                        ' updated successfully'),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Failed to update document: $e'),
                                              ));
                                            }
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
                            "Finish Editing",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
