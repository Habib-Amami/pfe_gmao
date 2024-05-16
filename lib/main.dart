// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pfe_gmao/features/notifications/model/notification_model.dart';
import 'package:pfe_gmao/theme/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'features/authentication/login/view/login_view.dart';
import 'firebase/firebase_options.dart';
import 'firebase/firebase_services.dart';
import 'home.dart';

// flutter local notification global initialization
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  //top level function for handling background notifications
  FirebaseMessaging.onBackgroundMessage(
      NotificationsModel.firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.initialize(
    NotificationsModel.initializationSettings,
  );

  // Firebase local notification plugin
  // Android specific notifications channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(NotificationsModel.channel);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await Hive.initFlutter();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  // if key not exists return null
  String? encryptedKeyString = await secureStorage.read(key: 'key');
  if (encryptedKeyString == null) {
    //generating AES encryption key with hive helper function
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
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeProvider.themeData,
          themeMode: ThemeMode.system,
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
      },
    );
  }
}
