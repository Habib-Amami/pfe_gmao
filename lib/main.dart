import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/authentication/login/view/login_view.dart';
import 'firebase_options.dart';
import 'firebase_services.dart';
import 'home.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  // if key not exists return null
  String? encryptedKeyString = await secureStorage.read(key: 'key');
  if (encryptedKeyString == null) {
    //genrating AES encryption key with hive helper function
    final List<int> hiveKey = Hive.generateSecureKey();

    //adding the key to the secure storage
    await secureStorage.write(
      key: 'key',
      value: base64Url.encode(hiveKey),
    );
    //getting the keyString after encoding for the secure storage
    encryptedKeyString = await secureStorage.read(key: 'key');

    //decoding the key
    final Uint8List decryptedKeyUint8List =
        base64Url.decode(encryptedKeyString!);

    //creating a encrypted hive box for storing credentials
    await Hive.openBox<String>(
      "credentials",
      encryptionCipher: HiveAesCipher(
        decryptedKeyUint8List,
      ),
    );
  } else {
    //decoding the key
    final Uint8List decryptedKeyUint8List =
        base64Url.decode(encryptedKeyString);

    //creating a encrypted hive box for storing credentials
    await Hive.openBox<String>(
      "credentials",
      encryptionCipher: HiveAesCipher(
        decryptedKeyUint8List,
      ),
    );
  }
  //compacting the credentials box
  await Hive.box<String>("credentials").compact();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: StreamBuilder(
        stream: FirebaseService.instance.authInstance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.hasData ? const Home() : const LoginView();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
