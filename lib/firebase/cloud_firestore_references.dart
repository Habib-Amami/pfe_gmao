// Reference to the users collection in Firestore
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

const String userCollectionRef = "users";

// References to the fields in the user document
const String usernameFieldRef = "userName"; // User's username field
const String emailFieldRef = "email"; // User's email field
const String phoneNumberFieldRef = "phoneNumber"; // User's phone number field
const String photoURLFieldRef = "photoURL"; // User's photo URL field
const String updateAtFieldRef =
    "updatedAt"; // User's document update time stamp

// Retrieve the current user
User? currentUser = FirebaseAuth.instance.currentUser;
//References to the default equipment picture
const defaultEquipmentPicture =
    "https://firebasestorage.googleapis.com/v0/b/pfe-gmao-11445214.appspot.com/o/default%20picture.jpg?alt=media&token=c964483d-03dd-4ce2-982b-481d4fa22be2";

// Reference to the users collection in Firestore
const String equipmentCollectionRef = "equipments";

//References ti the fields in the equipment document
const String id = 'TagName';
const String tagName = 'TagName';
const String area = 'Area';
const String description = 'Description';
const String discipline = 'Discipline';
const String equipmentPicture = 'Photo';
const String priority = 'Priority';
const String status = 'Status';
const String createdOn = 'CreatedOn';
const String updatedOn = 'UpdatedOn';
const String workshop = 'Workshop';
const String longitude = 'Longitude';
const String latitude = 'Latitude';

//Reference to the equipments pictures folder in the firebase storage
const String equipmnetPictureDic = "equipment_pictures";

//Reference to the equipments user manuels folder in the firebase storage
const String equipmentUserManualsDir = "equipment_user_manuals";

//Reference to the tag name collection
const String tagNamesCollectionRef = "equipment_tag_names";
