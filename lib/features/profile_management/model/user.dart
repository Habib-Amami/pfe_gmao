import 'package:cloud_firestore/cloud_firestore.dart';

enum Roles {
  // ignore: constant_identifier_names
  Engineer,
  // ignore: constant_identifier_names
  Administrator,
}

extension RolesToString on Roles {
  String toShortString() {
    return toString().split('.').last;
  }
}

class UserModel {
  String userName;
  String email;
  String phoneNumber;
  String photoURL;
  Roles role;
  Timestamp updatedAt;
  String serialNumber;

  UserModel({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.role,
    required this.updatedAt,
    required this.serialNumber,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      userName: data?['userName'] as String,
      email: data?['email'] as String,
      photoURL: data?['photoURL'] as String,
      role: _parseRole(data?['role']),
      updatedAt: data?['updatedAt'] as Timestamp,
      phoneNumber: data?['phoneNumber'] as String,
      serialNumber: data?['serialNumber'] as String,
    );
  }

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

  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    Roles? role,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? serialNumber,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      updatedAt: updatedAt ?? this.updatedAt,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'role': role.toShortString(),
      'updatedAt': updatedAt,
      'serialNumber': serialNumber,
    };
  }
}
