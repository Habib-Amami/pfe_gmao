// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

// Enum to represent user roles
enum Roles {
  // ignore: constant_identifier_names
  Engineer,
  // ignore: constant_identifier_names
  Administrator,
}

// Extension to convert enum values to a short string
extension RolesToString on Roles {
  String toShortString() {
    return toString().split('.').last;
  }
}

// Model class representing a user
class UserModel {
  final String id;
  final String userName;
  final String email;
  final String phoneNumber;
  final String photoURL;
  final Roles role;
  final String serialNumber;
  final String FCMtoken;
  final String discipline;

  // Constructor for creating a UserModel instance
  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.role,
    required this.serialNumber,
    required this.FCMtoken,
    required this.discipline,
  });

  // Factory method to create a UserModel instance from Firestore data
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      id: data?['id'] as String,
      userName: data?['userName'] as String,
      email: data?['email'] as String,
      photoURL: data?['photoURL'] as String,
      role: _parseRole(data?['role']),
      phoneNumber: data?['phoneNumber'] as String,
      serialNumber: data?['serialNumber'] as String,
      FCMtoken: data?["FCMtoken"] as String,
      discipline: data?['discipline'] as String,
    );
  }

  // Helper method to convert role string to Roles enum
  static Roles _parseRole(String roleString) {
    switch (roleString) {
      case 'Engineer':
        return Roles.Engineer;
      case 'Administrator':
        return Roles.Administrator;
      default:
        // Default role if not recognized
        return Roles.Engineer;
    }
  }

  // Method to create a copy of the UserModel with specified changes
  // UserModel copyWith({
  //   String? userName,
  //   String? email,
  //   String? phoneNumber,
  //   String? photoURL,
  //   Roles? role,
  //   String? serialNumber,
  // }) {
  //   return UserModel(
  //     userName: userName ?? this.userName,
  //     email: email ?? this.email,
  //     phoneNumber: phoneNumber ?? this.phoneNumber,
  //     photoURL: photoURL ?? this.photoURL,
  //     role: role ?? this.role,
  //     serialNumber: serialNumber ?? this.serialNumber,
  //   );
  // }

  // Method to convert UserModel to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'role': role.toShortString(),
      'serialNumber': serialNumber,
      'FCMtoken': FCMtoken,
      'discipline': discipline,
    };
  }

  // Override toString method to provide a string representation of UserModel
  @override
  String toString() {
    return 'UserModel{id: $id, userName: $userName, email: $email, phoneNumber: $phoneNumber, role: $role, serialNumber: $serialNumber, discipline: $discipline}';
  }
}
