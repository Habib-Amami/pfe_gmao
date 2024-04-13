import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../controller/firebase_api/db_service.dart';
import '../model/equipment.dart';
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
          stream: DatabaseService().getEquipments(),
          builder: (context, snapshot) {
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
                      Equipment currentEquipment = equipments[index].data();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Column(
                          children: [
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
                                                    equipment: currentEquipment,
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
                    },
                  );
          },
        ),
      ),
    );
  }
}
