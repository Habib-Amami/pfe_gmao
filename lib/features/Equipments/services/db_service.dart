import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

import '../model/equipment.dart';

const String Equipment_Collection_ref = "equipments";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _equipmentsRef;
  DatabaseService() {
    _equipmentsRef = _firestore
        .collection(Equipment_Collection_ref)
        .withConverter<Equipment>(
          fromFirestore: (snapshots, _) =>
              Equipment.fromJSON(snapshots.data()!),
          toFirestore: (equipment, _) => equipment.toJson(),
        );
  }
  // Get method
  Stream<QuerySnapshot> getEquipments() {
    return _equipmentsRef.snapshots();
  }

  // Create method
  void addEquipment(Equipment equipment) async {
    _equipmentsRef.add(equipment);
  }

  // update method
  void updateEquipment(String idEquipment, Equipment equipment) {
    _equipmentsRef.doc(idEquipment).update(equipment.toJson());
  }

  // update method
  Future<void> updateEquipmentPicture(
      {required String idEquipment, required String imageUrl}) async {
    await _equipmentsRef.doc(idEquipment).update({'Photo': imageUrl});
  }

  // delete method
  void deleteEquipment(String idEquipment) {
    _equipmentsRef.doc(idEquipment).delete();
  }

  // update the equipment photo
  updatePhotoURL(
    String idEquipment,
    Equipment equipment,
  ) {
    _equipmentsRef.doc(idEquipment).update(equipment.toJson());
  }
}
