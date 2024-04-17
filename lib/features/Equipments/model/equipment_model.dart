import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../firebase/cloud_firestore_references.dart';
import 'data_models/equipment.dart';

class EquipmentModel {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _equipmentsRef;
  EquipmentModel() {
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
    return _equipmentsRef
        .orderBy(
          'CreatedOn',
          descending: true,
        )
        .snapshots();
  }

  //
  // Adds equipment information to Firestore
  //
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
    required String userManualURL,
    required String contractURL,
  }) async {
    // Get Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Reference to tag names collection document
    DocumentReference tagNameDocRef =
        firestore.collection(tagNamesCollectionRef).doc(tagName);
    // Reference to equipment collection document
    DocumentReference equipmentDocRef =
        firestore.collection(equipmentCollectionRef).doc(docId);
    // Create a batched write for adding documents to both collections
    WriteBatch batch = firestore.batch();
    // Add a document to the tag names collection
    batch.set(tagNameDocRef, {'TagName': tagName});
    // Add a document to the equipment collection
    batch.set(equipmentDocRef, {
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
      'UserManual': userManualURL,
      'Contract': contractURL,
    });
    // Commit the batched write
    await batch.commit();
  }

  //
  // Uploads the selected profile picture to Firebase Storage and returns its download URL
  //
  static Future<String> uploadEquipmentPicture({
    required String fileName, // The name of the file to upload
    required File file, // The file to upload
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    // Reference to the directory for equipment pictures
    Reference profilePicturesDir = rootReference.child(
      equipmnetPicturesFolder,
    );
    // Reference to the specific file to upload
    Reference imageToUploadRef = profilePicturesDir.child(
      fileName,
    );
    // Upload the profile picture file to Firebase Storage
    await imageToUploadRef.putFile(
      file, // File to upload
      SettableMetadata(
        contentType: 'image/jpeg', // Setting content type as JPEG image
      ),
    );
    // Get the download URL of the uploaded image
    return await imageToUploadRef.getDownloadURL(); // Return the download URL
  }

  //
  // Uploads a PDF file to Firebase Storage and returns its download URL
  //
  static Future<String> uploadEquipmentPDFtoStorage({
    required String equipmentTagName,
    required File fileToUpload, // The PDF file to upload
    required String baseFileName,
  }) async {
    // Get a reference to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    // Reference to the folder for equipment files
    Reference equipmentFiles = rootReference.child(allEquipmentsFilesFolder);
    // Reference to the specific equipment's folder
    Reference directoryReference = equipmentFiles.child(equipmentTagName);
    // Concatenate the base file name with the tag name
    String fileName =
        '${equipmentTagName}_$baseFileName'; // Constructing the full file name
    // Reference to the file in Firebase Storage
    Reference fileReference = directoryReference.child(fileName);
    // Upload the file to Firebase Storage
    await fileReference.putFile(
      fileToUpload, // File to upload
      SettableMetadata(
        contentType: 'application/pdf', // Setting content type as PDF
      ),
    );
    // Return the download URL
    return await fileReference.getDownloadURL();
  }

  // update method
  Future<void> updateEquipment({
    required String initialTagName,
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
  }) async {
    // Get Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get references to Firestore collections
    CollectionReference tagNamesCollection =
        firestore.collection(tagNamesCollectionRef);
    CollectionReference equipmentCollection =
        firestore.collection(equipmentCollectionRef);
    // Create a batched write for updating documents
    WriteBatch batch = firestore.batch();
    // If the tag name has changed, delete the old tag name document and add the new one
    if (tagName != initialTagName) {
      batch.delete(tagNamesCollection.doc(initialTagName));
      batch.set(tagNamesCollection.doc(tagName), {'TagName': tagName});
    }
    // Update the equipment document in the equipment collection
    batch.update(equipmentCollection.doc(docId), {
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
    });
    // Commit the batched write
    await batch.commit();
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

  Future<void> deleteEquipment({
    required String docId,
    required String tagName,
    required String photoURL,
    required String userManualURL,
    required String contractURL,
  }) async {
    CollectionReference equipmentCollection =
        FirebaseFirestore.instance.collection(equipmentCollectionRef);
    CollectionReference tagNamesCollection =
        FirebaseFirestore.instance.collection(tagNamesCollectionRef);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Delete the document from the equipment collection
    batch.delete(equipmentCollection.doc(docId));

    // Delete the document from the tag names collection
    batch.delete(tagNamesCollection.doc(tagName));

    // Commit the batch write
    await batch.commit();

    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();

    // Delete the equipment picture from storage
    if (photoURL != defaultEquipmentPicture) {
      // Reference to the directory for equipment pictures
      Reference profilePicturesDir = rootReference.child(
        equipmnetPicturesFolder,
      );
      // Reference to the specific file to upload
      Reference equipmentPictureRef = profilePicturesDir.child(
        "${tagName}_picture",
      );
      await equipmentPictureRef.delete();
    }
    // Reference to the folder for equipment files
    Reference equipmentFiles = rootReference.child(allEquipmentsFilesFolder);

    // Reference to the specific equipment's folder
    Reference directoryReference = equipmentFiles.child(tagName);

    if (userManualURL != "" && contractURL != "") {
      directoryReference.delete();
    }

    // Delete the user manual file from storage
    if (userManualURL != "") {
      // Reference to the userManual in Firebase Storage
      Reference userManualRef = directoryReference.child(
        "${tagName}_user_manual",
      );
      await userManualRef.delete();
    }

    // Delete the contract file from storage
    if (contractURL != "") {
      // Reference to the userManual in Firebase Storage
      Reference contractRef = directoryReference.child(
        "${tagName}_contract",
      );
      await contractRef.delete();
    }
  }
}
