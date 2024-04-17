import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../model/data_models/equipment.dart';
import '../model/equipment_model.dart';
import 'add equipment pages/add_equipment_page.dart';
import 'edit_equipment_page.dart';
import 'widgets/equipment_tile/equipment_tile.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  EquipmentScreenState createState() => EquipmentScreenState();
}

class EquipmentScreenState extends State<EquipmentScreen> {
  bool isAdmin = false;

  // Variables for the search operation
  TextEditingController searchedTagName = TextEditingController();

  // Getting the user role
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
  void initState() {
    super.initState();
    getUserRole().then((role) {
      setState(() {
        isAdmin = role == 'Administrator';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            controller: searchedTagName,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchedTagName.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          searchedTagName.clear();
                        });
                      },
                      icon: const Icon(Icons.close))
                  : null,
              hintText: "Search",
            ),
            onChanged: (value) {
              setState(() {
                searchedTagName.text = value;
              });
            },
          ),
        ),
      ),
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
        child: StreamBuilder(
          stream: EquipmentModel().getEquipments(),
          builder: (context, snapshot) {
            // Handle interruption of connection
            if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    SizedBox(height: 10.0),
                    Text("Lost connection"),
                  ],
                ),
              );
            }
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading equipments ...")
                  ],
                ),
              );
            }
            // Show error message if an error occurs
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const CircularProgressIndicator(),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            }
            List equipments = snapshot.data?.docs ?? [];
            var lastDocument = snapshot.data?.docs.last;
            print(lastDocument);

            return equipments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('No equipment to display'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: equipments.length,
                    itemBuilder: (context, index) {
                      Equipment currentEquipment = equipments[index].data();
                      if (searchedTagName.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              // IconButton(
                              //   onPressed: () async {
                              //     equipments.add(
                              //       FirebaseFirestore.instance
                              //           .collection(equipmentCollectionRef)
                              //           .startAfter([lastDocument])
                              //           .orderBy('CreatedOn', descending: true)
                              //           .limit(5)
                              //           .snapshots(),
                              //     );
                              //     setState(() {});
                              //   },
                              //   icon: const Icon(Icons.add),
                              // ),
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
                                            onPressed: (context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return EditEquipmentPage(
                                                      equipment:
                                                          currentEquipment,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      child: EquipmentTile(
                                        equipment: currentEquipment,
                                      ),
                                    )
                                  : EquipmentTile(
                                      equipment: currentEquipment,
                                    ),
                            ],
                          ),
                        );
                      }
                      if (currentEquipment.TagName.toString()
                          .toLowerCase()
                          .contains(searchedTagName.text.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              // IconButton(
                              //   onPressed: () async {
                              //     equipments.add(
                              //       FirebaseFirestore.instance
                              //           .collection(equipmentCollectionRef)
                              //           .startAfter([lastDocument])
                              //           .orderBy('CreatedOn', descending: true)
                              //           .limit(5)
                              //           .snapshots(),
                              //     );
                              //     setState(() {});
                              //   },
                              //   icon: const Icon(Icons.add),
                              // ),
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
                                            onPressed: (context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return EditEquipmentPage(
                                                      equipment:
                                                          currentEquipment,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      child: EquipmentTile(
                                        equipment: currentEquipment,
                                      ),
                                    )
                                  : EquipmentTile(
                                      equipment: currentEquipment,
                                    ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  );
          },
        ),
      ),
    );
  }
}
