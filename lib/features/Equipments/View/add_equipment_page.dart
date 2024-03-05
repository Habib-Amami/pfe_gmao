import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_gmao/features/Equipments/View/input_field.dart';

import '../model/equipment.dart';
import '../services/db_service.dart';

class AddEquipmentPage extends StatefulWidget {
  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  late bool equipmentStatus;
  final TextEditingController tagNameTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController areaEditingController = TextEditingController();
  final TextEditingController disciplineEditingController =
      TextEditingController();
  final TextEditingController workshopEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: [
          Text(
            "Add new Equipment",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          MyInputField(
              title: "Tag name",
              hint: "Enter the Tag name",
              controller: tagNameTextEditingController),
          MyInputField(
              title: "Description",
              hint: "Enter a brief description",
              controller: descriptionTextEditingController),
          MyInputField(
              title: "Area",
              hint: "Enter the area ",
              controller: areaEditingController),
          MyInputField(
              title: "Discipline",
              hint: "Enter the discipline",
              controller: disciplineEditingController),
          MyInputField(
              title: "workshop",
              hint: "Enter the workshop",
              controller: workshopEditingController),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                  onPressed: () async {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text(
                                "Do you want to add this equipment ?"),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      createNewEquipment();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Confirm"),
                                  )
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text("Create new equipment"))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> createNewEquipment() async {
    FirebaseFirestore.instance.collection("equipments").add({
      'TagName': tagNameTextEditingController.text,
      'Description': descriptionTextEditingController.text,
      'Status': false,
      'Photo': '',
      'Area': areaEditingController.text,
      'CreatedOn': Timestamp.now(),
      'UpdatedOn': Timestamp.now(),
      'Workshop': workshopEditingController.text,
      'Discipline': disciplineEditingController.text,
    });
    tagNameTextEditingController.clear();
    descriptionTextEditingController.clear();
    areaEditingController.clear();
    disciplineEditingController.clear();
    workshopEditingController.clear();
  }
}
