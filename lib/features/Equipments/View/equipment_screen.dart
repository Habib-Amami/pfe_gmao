import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';

import '../model/equipment.dart';
import '../services/db_service.dart';
import 'add_equipment_page.dart';
import 'equipment_view.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  EquipmentScreenState createState() => EquipmentScreenState();
}

class EquipmentScreenState extends State<EquipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEquipmentPage()));
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.7462,
              child: StreamBuilder(
                builder: (context, snapshot) {
                  List equipments = snapshot.data?.docs ?? [];
                  if (equipments.isEmpty) {
                    return const Center(
                        child: Text("Equipments list is empty!"));
                  }
                  return ListView.builder(
                    itemCount: equipments.length,
                    itemBuilder: (context, index) {
                      Equipment equipment = equipments[index].data();
                      String idEquipment = equipments[index].id;
                      debugPrint(idEquipment);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  icon: Ionicons.trash_bin,
                                  label: "Delete",
                                  backgroundColor:
                                      const Color.fromARGB(255, 237, 24, 9),
                                  onPressed: (context) {
                                    DatabaseService()
                                        .deleteEquipment(idEquipment);
                                  })
                            ],
                          ),
                          child: ExpansionTile(
                            title: Text(equipment.TagName),
                            leading: equipment.Photo == ''
                                ? const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/pfe-gmao-11445214.appspot.com/o/default%20picture.jpg?alt=media&token=c964483d-03dd-4ce2-982b-481d4fa22be2'),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(equipment.Photo),
                                  ),
                            subtitle: Text(equipment.Description),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text("Status:"),
                                    equipment.Status
                                        ? IconButton(
                                            alignment: Alignment.center,
                                            icon: const Icon(
                                              Ionicons.checkmark_circle,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              // changing the status of the equipment
                                              Equipment updatedEquipment =
                                                  equipment.copyWith(
                                                Status: false,
                                                UpdatedOn: Timestamp.now(),
                                              );
                                              DatabaseService().updateEquipment(
                                                  idEquipment,
                                                  updatedEquipment);
                                            },
                                          )
                                        : IconButton(
                                            alignment: Alignment.center,
                                            icon: const Icon(
                                              Ionicons.warning,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              Equipment updatedEquipment =
                                                  equipment.copyWith(
                                                Status: true,
                                                UpdatedOn: Timestamp.now(),
                                              );
                                              DatabaseService().updateEquipment(
                                                  idEquipment,
                                                  updatedEquipment);
                                            },
                                          ),
                                  ],
                                ),
                              ),
                              TextButton(
                                child: const Text("More details"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EquipmentView(
                                        equipmentId: idEquipment,
                                        equipment: equipment,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                stream: DatabaseService().getEquipments(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
