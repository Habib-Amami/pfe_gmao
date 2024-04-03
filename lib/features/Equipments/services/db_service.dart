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

  // Create method
  Future<void> addEquipment({
    required String tagName,
    required String docId,
    required String description,
    required String area,
    required String discipline,
    required String workshop,
    required String status,
    required String priority,
    required String longitude,
    required String latitude,
    required String photoURL,
    required String userManual,
    required String contract,
    required List<String> otherFiles,
  }) async {
    CollectionReference tagNamesCollection =
        FirebaseFirestore.instance.collection("equipment_tag_names");
    CollectionReference equipmentCollection =
        FirebaseFirestore.instance.collection("equipments");

    // Add a document to the tag names collection
    await tagNamesCollection.doc(tagName).set({
      'TagName': tagName,
    });

    // Add a document to the equipment collection
    await equipmentCollection.doc(docId).set({
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
      'Longitude': longitude,
      'Latitude': latitude,
      'UserManual': userManual,
      'Contract': contract,
      'OtherFiles': otherFiles,
    });
  }

  // update method
  Future<void> updateEquipment({
    required String tagName,
    required String docId,
    required String description,
    required String area,
    required String discipline,
    required String workshop,
    required String status,
    required String priority,
    required String longitude,
    required String latitude,
    required String photoURL,
    required String userManual,
    required String contract,
    required List<String> otherFiles,
  }) async {
    CollectionReference tagNamesCollection =
        FirebaseFirestore.instance.collection("equipment_tag_names");
    CollectionReference equipmentCollection =
        FirebaseFirestore.instance.collection("equipments");

    // Add a document to the tag names collection if it doesn't exist
    await tagNamesCollection.doc(tagName).update({
      'TagName': tagName,
    });

    // Add or update the document in the equipment collection
    await equipmentCollection.doc(docId).update({
      'id': docId,
      'TagName': tagName,
      'Description': description,
      'Area': area,
      'Status': status,
      'Priority': priority,
      'Discipline': discipline,
      'Workshop': workshop,
      'UpdatedOn': Timestamp.now(),
      'Photo': photoURL,
      'Longitude': longitude,
      'Latitude': latitude,
      'UserManual': userManual,
      'Contract': contract,
      'OtherFiles': otherFiles,
    });
  }

  // update method
  Future<void> updateEquipmentPicture({
    required String idEquipment,
    required String imageUrl,
  }) async {
    await _equipmentsRef.doc(idEquipment).update({'Photo': imageUrl});
  }

  // delete method
  void deleteEquipment({
    required String idEquipment,
    required String tagName,
    required String photoURL,
  }) {
    FirebaseFirestore.instance
        .collection(tagNamesCollectionRef)
        .doc(tagName)
        .delete();
    if (photoURL != defaultEquipmentPicture) {
      Reference equipmentPictureRef = FirebaseStorage.instance
          .ref()
          .child(equipmnetPictureDic)
          .child("${tagName}_equipment_picture");
      equipmentPictureRef.delete();
    }
    _equipmentsRef.doc(idEquipment).delete();
  }

  // update the equipment photo
  Future<void> updatePhotoURL(
    String idEquipment,
    Equipment equipment,
  ) async {
    await _equipmentsRef.doc(idEquipment).update(equipment.toJson());
  }

  //Future methode to check if a document exists in a collection in cloud firestore
  static Future<bool> checkDocumentExistence({
    required String collectionName,
    required String documentId,
  }) async {
    // Get a reference to the document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    // Get the document snapshot
    DocumentSnapshot docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  // Method to upload the selected profile picture to Firebase Storage and
  //get it download URL
  static Future<String> uploadEquipmentPicture({
    required String fileName,
    required File file,
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference profilePicturesDir = rootReference.child(
      equipmnetPictureDic,
    );
    Reference imageToUploadRef = profilePicturesDir.child(
      fileName,
    );
    // Upload the profile picture file to Firebase Storage
    await imageToUploadRef.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    // Get the download URL of the uploaded image
    return await imageToUploadRef.getDownloadURL();
  }

  static Future<List<String>> uploadEquipmentPDFtoStorage({
    required String equipmentTagName,
    required List<File> files,
    required String baseFileName,
  }) async {
    List<String> downloadURLs = [];

    // Get a reference to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference equipmentFiles = rootReference.child(allEquipmentsFilesFolder);
    Reference directoryReference = equipmentFiles.child(equipmentTagName);

    // Upload each file in the list to Firebase Storage
    for (int i = 0; i < files.length; i++) {
      // Concatenate the base file name with the index
      String fileName = '$baseFileName$i';

      Reference fileReference = directoryReference.child(fileName);

      // Upload the file to Firebase Storage
      await fileReference.putFile(
        files[i],
        SettableMetadata(
          contentType: 'application/pdf',
        ),
      );

      // Get the download URL of the uploaded file
      String downloadURL = await fileReference.getDownloadURL();
      downloadURLs.add(downloadURL);
    }
    return downloadURLs;
  }
}
