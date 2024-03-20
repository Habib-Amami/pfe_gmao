import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../firebase/cloud_firestore_references.dart';

import '../model/equipment.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _equipmentsRef;
  DatabaseService() {
    _equipmentsRef =
        _firestore.collection(equipmentCollectionRef).withConverter<Equipment>(
              fromFirestore: (snapshots, _) => Equipment.fromJSON(
                snapshots.data()!,
              ),
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
  void addEquipment({
    required String tagName,
    required String docId,
    required String description,
    required String area,
    required String discipline,
    required String workshop,
    required String status,
    required String priority,
    String photoURL =
        'https://firebasestorage.googleapis.com/v0/b/pfe-gmao-11445214.appspot.com/o/default%20picture.jpg?alt=media&token=c964483d-03dd-4ce2-982b-481d4fa22be2',
  }) async {
    FirebaseFirestore.instance
        .collection(tagNamesCollectionRef)
        .doc(tagName)
        .set({});
    FirebaseFirestore.instance
        .collection(equipmentCollectionRef)
        .doc(docId)
        .set({
      'id': docId,
      'TagName': tagName,
      'Description': description,
      'Area': area,
      'Status': status,
      'Priority': priority,
      'Discipline': discipline,
      'Workshop': workshop,
      'CreatedOn': Timestamp.now(),
      'UpdatedOn': Timestamp.now(),
      'Photo': photoURL,
    });
    //_equipmentsRef.id;
  }

  // update method
  void updateEquipment(String idEquipment, Equipment equipment) {
    _equipmentsRef.doc(idEquipment).update(equipment.toJson());
  }

  // update method
  Future<void> updateEquipmentPicture({
    required String idEquipment,
    required String imageUrl,
  }) async {
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

  // Method to upload the selected profile picture to Firebase Storage and
  //get it doawload URL
  Future<String> addEquipmentPicture({
    required String equipmentPictureRef,
    required File equipmnetPicture,
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference profilePicturesDir = rootReference.child(equipmnetPictureDic);
    Reference imageToUploadRef = profilePicturesDir.child(equipmentPictureRef);
    // Upload the profile picture file to Firebase Storage
    await imageToUploadRef.putFile(
      equipmnetPicture,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    // Get the download URL of the uploaded image
    return await imageToUploadRef.getDownloadURL();
  }
}
