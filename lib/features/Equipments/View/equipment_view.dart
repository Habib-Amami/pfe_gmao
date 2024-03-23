import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/equipment.dart';
import '../services/my_equipment_functions.dart';

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
          //String picture = NetworkImage(equipmentData['Photo']);
          return ListView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: SizedBox(
                  height: 150,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    radius: 150,
                    child: CircleAvatar(
                      radius: 72,
                      backgroundImage: NetworkImage(equipmentData['Photo']),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: TextButton(
              //     style: const ButtonStyle(
              //       elevation: MaterialStatePropertyAll(2),
              //     ),
              //     onPressed: () {
              //       showModalBottomSheet(
              //         context: context,
              //         builder: (context) {
              //           return EquipmentPictureBottomSheet(
              //             equipmentId: equipmentData['id'],
              //             equipmentImageUrl: equipmentData['Photo'],
              //             tagName: equipmentData['TagName'],
              //           );
              //         },
              //       );
              //     },
              //     child: const Text(
              //       "Change Equipment Picture",
              //     ),
              //   ),
              // ),
              myProperty('TagName', equipmentData['TagName'],
                  const Icon(Icons.local_offer_outlined)),
              myProperty(
                  'Description',
                  equipmentData['Description'],
                  const Icon(
                    Icons.description_outlined,
                  )),
              myProperty('Area', equipmentData['Area'],
                  const Icon(Icons.location_on_outlined)),
              myProperty(
                  'Discipline',
                  equipmentData['Discipline'],
                  const Icon(
                    Icons.build_circle_outlined,
                  )),
              myProperty(
                  'Workshop',
                  equipmentData['Workshop'],
                  const Icon(
                    Icons.build_outlined,
                  )),
              myProperty(
                  'Status', equipmentData['Status'], const Icon(Icons.power)),
            ],
          );
        },
      ),
    );
  }
}
