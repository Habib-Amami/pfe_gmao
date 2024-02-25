import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalLoginModel {
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
