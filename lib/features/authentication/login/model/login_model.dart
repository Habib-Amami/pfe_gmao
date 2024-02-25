import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../firebase_services.dart';

class LoginModel {
  Future<User?> login({
    required emailAddress,
    required password,
  }) async {
    UserCredential userCredential =
        await FirebaseService.instance.authInstance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> saveCredentialsToLocalDB({
    required String email,
    required String password,
  }) async {
    await Hive.box<String>("credentials").putAll(
      {
        "email": email,
        "password": password,
      },
    );
  }

  String? getCachedEmail() {
    final cachedEmail = Hive.box<String>("credentials").get("email");
    return cachedEmail;
  }

  String? getCachedPassword() {
    final cachedPassword = Hive.box<String>("credentials").get("password");
    return cachedPassword;
  }
}
