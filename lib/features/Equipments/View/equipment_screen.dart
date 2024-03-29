import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../model/equipment.dart';
import '../services/db_service.dart';
import '../services/my_equipment_functions.dart';
import 'add equipment pages/add_equipment_page.dart';
import 'edit_equipment_page.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  EquipmentScreenState createState() => EquipmentScreenState();
}

class EquipmentScreenState extends State<EquipmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _equipmentList =
      []; // List to store equipment data
  List<Map<String, dynamic>> _filteredEquipmentList =
      []; // List to store filtered equipment data

  @override
  void initState() {
    super.initState();
    // Call a method to fetch equipment data from Firestore
    fetchEquipmentData();
  }

  void fetchEquipmentData() async {
    try {
      // Fetch equipment data from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipments').get();

      // Update the equipment list with data from Firestore
      setState(() {
        _equipmentList = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        // Initialize filtered list with all equipment
        _filteredEquipmentList = List.from(_equipmentList);
      });
    } catch (error) {
      // Handle error
      debugPrint('Failed to fetch equipment data: $error');
    }
  }

  void filterEquipmentList(String query) {
    // Filter equipment list based on the search query
    setState(() {
      _filteredEquipmentList = _equipmentList.where((equipment) {
        // Check if any property contains the search query
        return equipment[tagName]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            equipment[workshop]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            equipment[area]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            equipment[discipline]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
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
    String? userRole = userData?['role'];
    return userRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
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
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: CupertinoSearchTextField(
                controller: _searchController,
                suffixIcon: const Icon(Icons.highlight_remove_rounded),
                onSuffixTap: () {
                  filterEquipmentList('');
                  _searchController.clear();
                },
                borderRadius: BorderRadius.circular(15),
                onChanged: (value) => filterEquipmentList(value),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.75,
              child: StreamBuilder(
                stream: DatabaseService().getEquipments(),
                builder: (context, snapshot) {
                  List equipments = snapshot.data?.docs ?? [];
                  if (equipments.isEmpty) {
                    return const Center(
                      child: Text("Equipments list is empty!"),
                    );
                  }
                  return _filteredEquipmentList.isEmpty
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
                          itemCount: _filteredEquipmentList.length,
                          itemBuilder: (context, index) {
                            Equipment equipment = equipments[index].data();
                            String idEquipment = equipments[index].id;
                            String equipmentTagName = equipment.TagName;
                            String equipmentPictureURL = equipment.Photo;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Slidable(
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
                                                equipmentId: idEquipment,
                                                equipment: equipment,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SlidableAction(
                                          icon: Ionicons.trash_bin,
                                          label: "Delete",
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 24, 9),
                                          onPressed: (context) {
                                            DatabaseService().deleteEquipment(
                                              idEquipment: idEquipment,
                                              tagName: equipmentTagName,
                                              photoURL: equipmentPictureURL,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        _filteredEquipmentList[index][tagName],
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
                                            _filteredEquipmentList[index]
                                                ['Photo']),
                                      ),
                                      subtitle: showState(
                                          _filteredEquipmentList[index]
                                              [status]),
                                      children: <Widget>[
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
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(_filteredEquipmentList[
                                                      index][description])
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(formattedDate(
                                                        _filteredEquipmentList[
                                                                index]
                                                            ['CreatedOn']))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(_filteredEquipmentList[
                                                        index][priority])
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(_filteredEquipmentList[
                                                        index][discipline])
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(_filteredEquipmentList[
                                                        index][workshop])
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
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
                                                    const SizedBox(width: 10),
                                                    Text(_filteredEquipmentList[
                                                        index][area])
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
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
