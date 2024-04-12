import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pfe_gmao/features/profile_management/model/user.dart';
import '../../../firebase/cloud_firestore_references.dart';
import '../../../firebase/firebase_services.dart';
import '../model/equipment.dart';
import '../controller/firebase_api/db_service.dart';
import '../controller/my_equipment_functions.dart';
import 'add equipment pages/add_equipment_page.dart';
import 'alerts/equipment_location_permission_denied_alert.dart';
import 'alerts/equipment_location_service_alert.dart';
import 'edit_equipment_page.dart';
import 'equipment_map.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  EquipmentScreenState createState() => EquipmentScreenState();
}

class EquipmentScreenState extends State<EquipmentScreen> {
  bool isAdmin = true;
  //final String userRole = '';
  @override
  void initState() {
    super.initState();
    // Call a method to fetch equipment data from Firestore
    //fetchEquipmentData();
  }

  Future<String?> getUserRole() async {
    // Get the user document from Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    // Explicitly cast the result of data() to a Map<String, dynamic>
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    //retrieve the role from user collection
    String? userRole = userData?['role'].toString();
    return userRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              label: const Text("Add"),
              icon: const Icon(Icons.library_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEquipmentPage(),
                  ),
                );
              },
            )
          : null,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.815,
          child: StreamBuilder(
            stream: DatabaseService().getEquipments(),
            builder: (context, snapshot) {
              List equipments = snapshot.data?.docs ?? [];
              if (equipments.isEmpty) {
                return const Center(
                  child: Text("Equipments list is empty!"),
                );
              }
              return equipments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('No equipment match your search'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: equipments.length,
                      itemBuilder: (context, index) {
                        Equipment equipment = equipments[index].data();
                        // String equipmentTagName = equipment.TagName;
                        // String equipmentPictureURL = equipment.Photo;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              // TextButton(
                              //     onPressed: () {
                              //       setState(() {
                              //         isAdmin = !isAdmin;
                              //       });
                              //     },
                              //     child: isAdmin
                              //         ? Text('admin')
                              //         : Text('moch admin')),
                              isAdmin
                                  ? Slidable(
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            icon: Icons.edit_outlined,
                                            label: "Edit",
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            onPressed: (context) =>
                                                Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditEquipmentPage(
                                                  equipment: equipment,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: ExpansionTile(
                                        title: Text(
                                          equipment.TagName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            equipment.Photo,
                                          ),
                                        ),
                                        subtitle: showState(
                                          equipment.Status,
                                        ),
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 90,
                                                      height: 21,
                                                      child: Text(
                                                        "Description:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        equipment.Description,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 90,
                                                        height: 21,
                                                        child: Text(
                                                          "Created at:",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        formattedDate(
                                                          equipment.CreatedOn,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 90,
                                                        height: 21,
                                                        child: Text(
                                                          "Priority:",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        equipment.Priority,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 90,
                                                        height: 21,
                                                        child: Text(
                                                          "Discipline:",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        equipment.Discipline,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 90,
                                                        height: 21,
                                                        child: Text(
                                                          "Workshop:",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        equipment.Workshop,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 21,
                                                        width: 90,
                                                        child: Text(
                                                          "Area:",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          equipment.Area,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text(
                                                "Show equipment location"),
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => EquipmentView(
                                              //       equipmentId: idEquipment,
                                              //       equipment: equipment,
                                              //     ),
                                              //   ),
                                              // );
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  : ExpansionTile(
                                      title: Text(
                                        equipment.TagName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          equipment.Photo,
                                        ),
                                      ),
                                      subtitle: showState(equipment.Status),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 90,
                                                    height: 21,
                                                    child: Text(
                                                      "Description:",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      equipment.Description,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 90,
                                                      height: 21,
                                                      child: Text(
                                                        "Created at:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      formattedDate(
                                                        equipment.CreatedOn,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 90,
                                                      height: 21,
                                                      child: Text(
                                                        "Priority:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      equipment.Priority,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 90,
                                                      height: 21,
                                                      child: Text(
                                                        "Discipline:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      equipment.Discipline,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 90,
                                                      height: 21,
                                                      child: Text(
                                                        "Workshop:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      equipment.Workshop,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 21,
                                                      width: 90,
                                                      child: Text(
                                                        "Area:",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      equipment.Area,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          child: const Text(
                                              "Show equipment location"),
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => EquipmentView(
                                            //       equipmentId: idEquipment,
                                            //       equipment: equipment,
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                        )
                                      ],
                                    )
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  // void downloadPDF({
  //   required String fileName,
  //   required String downloadURL,
  // }) async {
  //   final dio = Dio();
  //   final dir = await getExternalStorageDirectory();
  //   await dio
  //       .download(
  //         downloadURL,
  //         "${dir!.path}/equipments_files/$fileName",
  //       )
  //       .then(
  //         (_) => print('File downloaded successfully '),
  //       );
  // }
}
