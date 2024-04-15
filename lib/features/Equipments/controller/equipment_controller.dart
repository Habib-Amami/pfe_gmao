// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';
import 'package:uuid/uuid.dart';

import '../model/equipment_model.dart';

class EquipmentController {
  final EquipmentModel _equipmetModel = EquipmentModel();

  Future<void> addEquipment({
    required String tagName,
    required String description,
    required String area,
    required String discipline,
    required String workshop,
    required String status,
    required String priority,
    required String longitude,
    required String latitude,
    required File? equipmentPictureFile,
    required File? userManualFile,
    required File? contractFile,
  }) async {
    try {
      String _photoURL = defaultEquipmentPicture;
      String _userManualDowloadURL = "";
      String _contractDowloadURL = "";

      String docId = const Uuid().v4();

      if (equipmentPictureFile != null) {
        _photoURL = await EquipmentModel.uploadEquipmentPicture(
          fileName: "${tagName}_picture",
          file: equipmentPictureFile,
        );
      }
      if (userManualFile != null) {
        _userManualDowloadURL =
            await EquipmentModel.uploadEquipmentPDFtoStorage(
          equipmentTagName: tagName,
          fileToUpload: userManualFile,
          baseFileName: "user_manual",
        );
      }
      if (contractFile != null) {
        _contractDowloadURL = await EquipmentModel.uploadEquipmentPDFtoStorage(
          equipmentTagName: tagName,
          fileToUpload: userManualFile!,
          baseFileName: "contract",
        );
      }
      await _equipmetModel.addEquipment(
        tagName: tagName,
        docId: docId,
        description: description,
        area: area,
        discipline: discipline,
        workshop: workshop,
        status: status,
        priority: priority,
        longitude: longitude,
        latitude: latitude,
        photoURL: _photoURL,
        userManualURL: _userManualDowloadURL,
        contractURL: _contractDowloadURL,
      );
    } on FirebaseException {
      rethrow;
    }
  }

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
    required String userManualURL,
    required String contractURL,
    required File? equipmentPictureFile,
    required File? userManualFile,
    required File? contractFile,
  }) async {
    try {
      if (equipmentPictureFile != null) {
        photoURL = await EquipmentModel.uploadEquipmentPicture(
          fileName: "${tagName}_picture",
          file: equipmentPictureFile,
        );
      }
      if (userManualFile != null) {
        userManualURL = await EquipmentModel.uploadEquipmentPDFtoStorage(
          equipmentTagName: tagName,
          fileToUpload: userManualFile,
          baseFileName: "user_manual",
        );
      }
      if (contractFile != null) {
        contractURL = await EquipmentModel.uploadEquipmentPDFtoStorage(
          equipmentTagName: tagName,
          fileToUpload: userManualFile!,
          baseFileName: "contract",
        );
      }

      _equipmetModel.updateEquipment(
        initialTagName: initialTagName,
        tagName: tagName,
        docId: docId,
        description: description,
        area: area,
        discipline: discipline,
        workshop: workshop,
        status: status,
        priority: priority,
        longitude: longitude,
        latitude: latitude,
        photoURL: photoURL,
        userManual: userManualURL,
        contract: contractURL,
      );
    } on FirebaseException {
      rethrow;
    }
  }
}
