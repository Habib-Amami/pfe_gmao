import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  static FirebaseService get instance => _instance;

  FirebaseService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get authInstance => _auth;

  final FirebaseFirestore _store = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _store;
}
