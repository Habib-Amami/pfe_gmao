import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/Equipments/services/my_equipment_functions.dart';

import '../model/equipment.dart';
import '../services/db_service.dart';
import 'add_equipment_page.dart';
import 'edit_equipment_page.dart';

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
              builder: (context) => const AddEquipmentPage(),
            ),
          );
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
                      child: Text("Equipments list is empty!"),
                    );
                  }
                  return ListView.builder(
                    itemCount: equipments.length,
                    itemBuilder: (context, index) {
                      Equipment equipment = equipments[index].data();
                      String idEquipment = equipments[index].id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  icon: Icons.edit_outlined,
                                  label: "Edit",
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  onPressed: (context) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditEquipmentPage(
                                                equipmentId: idEquipment,
                                                equipment: equipment,
                                              )))),
                              SlidableAction(
                                  icon: Ionicons.trash_bin,
                                  label: "Delete",
                                  backgroundColor:
                                      const Color.fromARGB(255, 237, 24, 9),
                                  onPressed: (context) {
                                    DatabaseService()
                                        .deleteEquipment(idEquipment);
                                  }),
                            ],
                          ),
                          child: ExpansionTile(
                            title: Text(
                              equipment.TagName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(equipment.Photo),
                            ),
                            subtitle: showState(equipment.Status),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
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
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(equipment.Description)
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(formattedDate(
                                              equipment.CreatedOn))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(equipment.Priority)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(equipment.Discipline)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(equipment.Workshop)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(equipment.Area)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                child: const Text("Show equipment location"),
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
