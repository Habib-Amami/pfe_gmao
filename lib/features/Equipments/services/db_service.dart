import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/equipment.dart';
import 'uid_generator.dart';

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

// create method
  // void createEquipments() {
  //   FirebaseFirestore.instance.collection(Equipment_Collection_ref).add();
  // }

  // Create method
  void addEquipment(
      {required String tagName,
      required String docId,
      required String desc,
      required String area,
      required String dis,
      required String workshop}) async {
    FirebaseFirestore.instance.collection("equipments").doc(docId).set({
      'id': docId,
      'TagName': tagName,
      'Description': desc,
      'Area': area,
      'Status': false,
      'Discipline': dis,
      'Workshop': workshop,
      'CreatedOn': Timestamp.now(),
      'UpdatedOn': Timestamp.now(),
      'Photo':
          'https://firebasestorage.googleapis.com/v0/b/pfe-gmao-11445214.appspot.com/o/default%20picture.jpg?alt=media&token=c964483d-03dd-4ce2-982b-481d4fa22be2',
    });
    //_equipmentsRef.id;
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
