import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/Equipments/model/equipment.dart';
import 'package:pfe_gmao/Equipments/services/db_service.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  _EquipmentScreenState createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final TextEditingController tagNameTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController areaEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_add),
        onPressed: _displayTextInputDialog,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.40,
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
                            // leading: CircleAvatar(
                            //   radius: 30,
                            //   backgroundImage: NetworkImage(equipment.Photo),
                            // ),
                            title: Text(equipment.TagName),
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
                                                      UpdatedOn:
                                                          Timestamp.now());
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
                                                      UpdatedOn:
                                                          Timestamp.now());
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
                                onPressed: () {},
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

  void _displayTextInputDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add an equipment"),
            content: Container(
              height: 250,
              child: Column(
                children: [
                  TextField(
                    controller: tagNameTextEditingController,
                    decoration: const InputDecoration(hintText: "TagName"),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descriptionTextEditingController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: areaEditingController,
                    decoration: const InputDecoration(hintText: "Area"),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Equipment equipment = Equipment(
                      TagName: tagNameTextEditingController.text,
                      Description: descriptionTextEditingController.text,
                      Status: false,
                      Area: areaEditingController.text,
                      CreatedOn: Timestamp.now(),
                      UpdatedOn: Timestamp.now());
                  DatabaseService().addEquipment(equipment);
                  Navigator.pop(context);
                  tagNameTextEditingController.clear();
                  descriptionTextEditingController.clear();
                  areaEditingController.clear();
                },
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}
