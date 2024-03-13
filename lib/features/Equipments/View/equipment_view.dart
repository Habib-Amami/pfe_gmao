import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'equipment_picture_bottom_sheet.dart';
import '../model/equipment.dart';

class EquipmentView extends StatefulWidget {
  //final String equipmentId;
  final Equipment equipment;
  const EquipmentView(
      {super.key, required this.equipment, required String equipmentId});

  @override
  State<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends State<EquipmentView> {
  late Future<DocumentSnapshot> _equipmentFuture;
  @override
  void initState() {
    super.initState();
    _equipmentFuture = FirebaseFirestore.instance
        .collection('equipments')
        .doc(widget.equipment.id)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
          return ListView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 50,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(equipmentData['Photo']),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'TagName',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(left: 14),
                height: 58,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(12)),
                child: GestureDetector(
                  onTap: _alertDialogForEdit,
                  child: TextFormField(
                    enabled: false,
                    initialValue: equipmentData['TagName'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 20),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future _alertDialogForEdit() {
    TextEditingController textEditingController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit the TagName"),
            content: TextField(
              decoration: InputDecoration(
                hintText: "New TagName",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
              ),
              controller: textEditingController,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Confirm",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          );
        });
  }
}
